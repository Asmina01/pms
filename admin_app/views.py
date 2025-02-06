import json
from collections import defaultdict

import openpyxl
import plotly.express as px
from django.forms import fields
from django.http import HttpResponse
from django.template.loader import render_to_string

from .models import Task, TimelineEvent, Milestone, ProjectLead

from datetime import date, timedelta, datetime
from django.utils import timezone
from django.contrib import messages

from django.shortcuts import  get_object_or_404
from django.db.models import Q, ExpressionWrapper

# Create your views here.


from django.shortcuts import render, redirect
from django.utils.timezone import now, localtime

from employee_app.models import Comment, TaskTime
from .models import Task, Taskprogress, Sprint,  ProjectFunctions
from .forms import ProjectForm, TaskForm, UserForm, SprintForm, UserLoginForm, ProjectFunctionForm, MilestoneForm, \
    TimelineEventForm
from django.db.models import Sum, F

from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Project, user


def export_tasks_to_excel(request):
    import openpyxl
    from django.http import HttpResponse
    from .models import Task

    # Create a new workbook and sheet
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Tasks"

    # Add headers
    ws.append(["Task ID", "Task Name", "Assigned To", "Status", "Start Time", "Stop Time", "Total Time"])

    # Fetch all tasks
    tasks = Task.objects.all()

    for task in tasks:
        total_time = sum(
            (entry.stop_time - entry.start_time).total_seconds() / 60 if entry.start_time and entry.stop_time else 0
            for entry in task.task_times.all()
        )  # Total time in minutes

        assigned_employees = ", ".join([emp.name for emp in task.assigned_to.all()]) if task.assigned_to.exists() else "Unassigned"

        # Remove timezone before inserting into Excel
        start_time = task.task_times.first().start_time.replace(tzinfo=None) if task.task_times.exists() and task.task_times.first().start_time else "N/A"
        stop_time = task.task_times.last().stop_time.replace(tzinfo=None) if task.task_times.exists() and task.task_times.last().stop_time else "N/A"

        ws.append([
            task.id,
            task.task_name,
            assigned_employees,
            task.status,
            start_time,
            stop_time,
            f"{total_time:.2f}"
        ])

    # Create response
    response = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    response["Content-Disposition"] = 'attachment; filename="tasks.xlsx"'

    # Save workbook to response
    wb.save(response)

    return response


def get_project_members(request):
    project_id = request.GET.get('project_id')
    assigned = []
    if project_id:
        try:
            project = Project.objects.get(id=project_id)
            assigned = project.assigned.all()
        except Project.DoesNotExist:
            pass

    return render(request, 'members_list.html', {'assigned': assigned})

def admin_assigned_projects(request):
    # Get filter parameters from the request
    status_filter = request.GET.get('status', '')
    priority_filter = request.GET.get('priority', '')
    category_filter=request.GET.get('category','')
    start_date = request.GET.get('start_date', '')
    due_date = request.GET.get('due_date', '')
    no_deadline = request.GET.get('no_deadline', '')
    client_filter = request.GET.get('client', '')

    search_query = request.GET.get('search', '')

    # Start with all projects
    projects = Project.objects.all()

    # Apply filters if provided
    if status_filter:
        projects = projects.filter(status=status_filter)
    if priority_filter:
        projects = projects.filter(priority=priority_filter)
    if category_filter:
        projects=projects.filter(category=category_filter)
    if start_date:
        projects = projects.filter(start_date=start_date)
    if due_date:
        projects = projects.filter(due_date=due_date)
    if no_deadline:  # Check if "No Deadline" is selected
        projects = projects.filter(due_date__isnull=True)
    if client_filter:  # Filter by client if provided
        projects = projects.filter(client=client_filter)

    total_projects = projects.count()  # Count total number of projects

    # Apply search filter
    if search_query:
        projects = projects.filter(
            Q(name__icontains=search_query) |  # Search in project name
            Q(assigned__name__icontains=search_query)  # Search in assigned employee's name
        ).distinct()

    clients = Project.objects.values_list('client', flat=True).distinct()
    form = ProjectFunctionForm()


    project_data = []

    for project in projects:
        tasks = project.tasks.all()

        # Calculate project progress as the average of all task progress
        total_progress = 0
        total_tasks = tasks.count()
        pending_tasks = tasks.filter(status='Pending').count()
        in_progress_tasks = tasks.filter(status='In Progress').count()
        completed_tasks = tasks.filter(status='Completed').count()

        for task in tasks:
            if task.status == 'Completed':
                total_progress += 100
            elif task.status == 'In Progress':
                total_progress += 60  # assuming 60% for tasks in progress
            else:
                total_progress += 0  # Pending tasks have 0% progress

        project_progress = total_progress / total_tasks if total_tasks else 0  # Average task progress

        project_data.append({
            'project_name': project.name,
            'project_description': project.description,
            'project_progress': project_progress,
            'total_tasks': total_tasks,
            'pending_tasks': pending_tasks,
            'in_progress_tasks': in_progress_tasks,
            'completed_tasks': completed_tasks,
            'tasks': tasks
        })

    # Pass current filters to the template for maintaining state
    context = {
        'projects': projects,
        'total_projects': total_projects,
        'status_filter': status_filter,
        'priority_filter': priority_filter,
        'category_filter':category_filter,
        'search_query': search_query,
        'start_date': start_date,
        'due_date': due_date,
        'no_deadline': no_deadline,
        'client_filter': client_filter,
        'clients':clients,
        'form': form,
        'project_data': project_data,
    }
    return render(request, 'admin_assigned_projects.html', context)

def assign_task(request):
    project_id = request.GET.get('project_id')  # Get project_id from request (if exists)

    if request.method == "POST":
        form = TaskForm(request.POST, project_id=request.POST.get('project'))
        if form.is_valid():
            form.save()
            return redirect('task_list')  # Return success response
        else:
            return redirect('assign_task')

    form = TaskForm(project_id=project_id)
    return render(request, "assign_task.html", {"form": form})

def get_client(request):
    project_id = request.GET.get('project_id')
    try:
        project = Project.objects.get(id=project_id)
        return JsonResponse({'client': project.client})
    except Project.DoesNotExist:
        return JsonResponse({'client': 'No Client'})
def create_project(request):
    if request.method == 'POST':
        form = ProjectForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()  # This will save the project along with the selected members
            return redirect('admin_assigned_projects')  # Redirect to a success page or project list
    else:
        form = ProjectForm()

    return render(request, 'create_project.html', {'form': form})

def view_progress(request):


    projects = Project.objects.all()
    progress_data = []

    for project in projects:
        total_tasks = project.tasks.count()
        completed_tasks = project.tasks.filter(status='Completed').count()
        progress_percentage = (completed_tasks / total_tasks) * 100 if total_tasks > 0 else 0
        progress_data.append({'project': project, 'progress': progress_percentage})

    context = {'progress_data': progress_data}
    return render(request, 'view_progress.html', context)



def view_time_tracking(request):


    time_logs = Taskprogress.objects.values('task__name', 'task__project__name', 'employee__username').annotate(
        total_hours=Sum(F('end_time') - F('start_time'))
    )

    context = {'time_logs': time_logs}
    return render(request, 'view_time_tracking.html', context)


def adminindex(request):
    return render(request, 'adminindex.html')
def base(request):
    projects = Project.objects.all()
    total_projects = projects.count()
    employees = user.objects.filter(role="employee")
    total_employees = employees.count()

    admin_tasks = Task.objects.filter(assigned_to__role="admin")
    today_date = date.today().strftime("%B %d, %Y")
    overdue_projects = projects.filter(due_date__lt=now(), progress__lt=100).count()
    total_admin_tasks = admin_tasks.count()

    admin_users = user.objects.filter(role="admin")
    completed_admin_tasks = admin_tasks.filter(status='Completed').count()

    today = timezone.localdate()
    employee_work_hours = []

    for employee in employees:
        # Get today's task time records for this employee
        today_task_times = TaskTime.objects.filter(
            task__assigned_to=employee,
            start_time__date=today,
            stop_time__isnull=False  # Only completed tasks
        )

        # Calculate total working hours today
        total_seconds_today = sum(
            (entry.stop_time - entry.start_time).total_seconds() for entry in today_task_times
        )

        total_hours_today = int(total_seconds_today // 3600)
        total_minutes_today = int((total_seconds_today % 3600) // 60)

        employee_work_hours.append({
            "employee": employee,
            "hours": total_hours_today,
            "minutes": total_minutes_today,
        })



    project_data = []

    for project in projects:
        tasks = project.tasks.all()

        # Calculate project progress as the average of all task progress

        total_tasks = tasks.count()


        completed_count = 0
        ongoing_count = 0
        pending_count = 0

        for project in projects:
            tasks = project.tasks.all()  # Assuming the related_name for tasks is 'tasks'

            if not tasks.exists():
                pending_count += 1
            elif all(task.status == 'Completed' for task in tasks):
                completed_count += 1
            else:
                ongoing_count += 1

        project_data.append({
            'project_name': project.name,
            'project_description': project.description,

            'total_tasks': total_tasks,

            'tasks': tasks  # Include tasks for detailed progress view
        })

    today = date.today()
    admin_task_times = TaskTime.objects.filter(
        task__assigned_to__role="admin",
        start_time__date=today,
        stop_time__isnull=False  # Ensure the task has been stopped
    )

    total_seconds_today = sum(
        (entry.stop_time - entry.start_time).total_seconds()
        for entry in admin_task_times
    )

    total_hours_today = int(total_seconds_today // 3600)
    total_minutes_today = int((total_seconds_today % 3600) // 60)

    grand_total_seconds_today = 0

    for employee in employees:
        today_task_times = TaskTime.objects.filter(
            task__assigned_to=employee,
            start_time__date=today,
            stop_time__isnull=False  # Completed tasks
        )

        total_seconds_today = sum(
            (entry.stop_time - entry.start_time).total_seconds()
            for entry in today_task_times
        )

        grand_total_seconds_today += total_seconds_today

    # Convert to hours and minutes
    grand_total_hours_today = int(grand_total_seconds_today // 3600)
    grand_total_minutes_today = int((grand_total_seconds_today % 3600) // 60)


    active_task_times = TaskTime.objects.filter(
        start_time__date=today,
        stop_time__isnull=True  # Timer is still running
    )

    # Get employee emails with active timers
    active_employee_emails = active_task_times.values_list('task__assigned_to__email', flat=True).distinct()

    # Filter employees with running timers
    employees_with_running_timer = employees.filter(email__in=active_employee_emails)
    total_employees_with_running_timer = employees_with_running_timer.count()


    context = {
        'projects': projects,
        'admin_tasks' : admin_tasks,
        'admin_users': admin_users,
        'total_projects': total_projects,
        'employees': employees,
        'total_employees': total_employees,
        'project_data': project_data,
        'today_date' : today_date,
        'overdue_projects' : overdue_projects,
        'total_admin_tasks' :total_admin_tasks,
        'completed_count': completed_count,
        'ongoing_count': ongoing_count,
        'pending_count': pending_count,
        'completed_admin_tasks': completed_admin_tasks,
        'total_hours_today': total_hours_today,
        'total_minutes_today': total_minutes_today,
        'grand_total_hours_today': grand_total_hours_today,
        'grand_total_minutes_today': grand_total_minutes_today,
        'employees_with_running_timer': employees_with_running_timer,
        'total_employees_with_running_timer': total_employees_with_running_timer,
        "employee_work_hours": employee_work_hours,

    }
    return render(request, 'base.html', context)
def add_member(request):
    if request.method == 'POST':
        form = UserForm(request.POST, request.FILES)  # Include request.FILES for handling file uploads
        if form.is_valid():
            form.save()
            messages.success(request, "Employee created successfully.") # Save the form data
            return redirect('members_list')  # Redirect to member list view
        else:
            print(form.errors)  # Add this line to print form errors if it's not valid
    else:
        form = UserForm()

    return render(request, 'add_member.html', {'form': form})


def members_list(request):
    members = user.objects.all()  # Fetch all members from the database
    return render(request, 'members_list.html', {'members': members})

def project_list(request):
    projects = Project.objects.all()  # Fetch all projects from the database
    return render(request, 'project_list.html', {'projects': projects})

def stop_task_timer(request, task_id):
    task_time = TaskTime.objects.get(task_id=task_id, stop_time__isnull=True)
    task_time.stop_time = timezone.now()
    task_time.save()

    # Update Project Total Time
    task_time.task.project.total_time_spent()
    return redirect('task_list')

def project_overview(request, project_id):
    project = get_object_or_404(Project, id=project_id)
    project_lead = ProjectLead.objects.filter(project=project).first()
    tasks = Task.objects.filter(project=project)
    today = now().date()
    tomorrow = today + timedelta(days=1)

    # Filters
    search_query = request.GET.get('search', '').strip()
    employee_id = request.GET.get('employee', '')  # Get the selected employee ID
    employees = user.objects.filter(role='employee')  # Fetch all employees

    # If an employee is selected, filter by ID
    selected_employee = None
    if employee_id:
        selected_employee = user.objects.filter(reg_no=employee_id).first()

    completed_filter = request.GET.get('completed', '').strip()
    date_filter = request.GET.get('date', '').strip()

    task_times = TaskTime.objects.select_related('task__project') \
        .prefetch_related('task__assigned_to') \
        .filter(task__project_id=project_id) \
        .order_by('-start_time')

    if search_query:
        task_times = task_times.filter(
            Q(task__task_name__icontains=search_query) |
            Q(task__project__short_code__icontains=search_query)
        )

    if employee_id:
        task_times = task_times.filter(task__assigned_to__id=employee_id)

    if completed_filter:
        if completed_filter.lower() == "yes":
            task_times = task_times.filter(stop_time__isnull=False)
        elif completed_filter.lower() == "no":
            task_times = task_times.filter(stop_time__isnull=True)

    if date_filter:
        task_times = task_times.filter(start_time__date=date_filter)

    upcoming_tasks = tasks.filter(due_date__gte=today, due_date__lte=tomorrow).order_by('due_date')

    # Task progress counts
    completed_tasks = tasks.filter(status="Completed").count()
    pending_tasks = tasks.filter(status="Pending").count()
    in_progress_tasks = tasks.filter(status="In Progress").count()
    all_members = user.objects.exclude(reg_no__in=project.assigned.all())
    total_tasks = tasks.count()

    if total_tasks == completed_tasks and total_tasks > 0:
        project.status = "Completed"
    elif in_progress_tasks > 0:
        project.status = "In Progress"
    elif pending_tasks == total_tasks:
        project.status = "Not Started"
    else:
        project.status = "Pending"

        # Save updated project status
    project.save()


    progress_data = json.dumps([completed_tasks, pending_tasks, in_progress_tasks])

    for task in task_times:
        if task.stop_time:
            duration = task.stop_time - task.start_time
            hours, remainder = divmod(duration.total_seconds(), 3600)
            minutes = remainder // 60

            # Ensure stored value is numeric for calculations, not a string
            task.total_duration_value = int(hours) + int(minutes) / 60  # Numeric value
            task.total_duration = f"{int(hours)}h {int(minutes)}m"
        else:
            task.total_duration_value = 0
            task.total_duration = "In Progress"

    # Project due status
    if project.due_date:
        if project.due_date >= today:
            status = "🟢 On Track"
            days_remaining = (project.due_date - today).days
        else:
            status = "🔴 Overdue"
            days_remaining = (today - project.due_date).days
    else:
        status = "⚪ No Due Date"
        days_remaining = None

    filtered_seconds = sum(
        (task_time.stop_time - task_time.start_time).total_seconds()
        for task_time in task_times if task_time.start_time and task_time.stop_time
    )if task_times.exists() else 0

    filtered_hours = int(filtered_seconds // 3600)
    filtered_minutes = int((filtered_seconds % 3600) // 60)
    filtered_time_spent = f"{filtered_hours}h {filtered_minutes}m" if task_times.exists() else "0h 0m"

    # Calculate overall project total time (Ignoring Filters)
    all_task_times = TaskTime.objects.filter(task__project=project)

    total_seconds = sum(
        (task_time.stop_time - task_time.start_time).total_seconds()
        for task_time in all_task_times if task_time.start_time and task_time.stop_time
    )

    total_hours = int(total_seconds // 3600)
    total_minutes = int((total_seconds % 3600) // 60)
    total_time_spent = f"{total_hours}h {total_minutes}m"

    # Task details with durations
    task_list = []
    for task in tasks:
        total_seconds = sum(
            (entry.stop_time - entry.start_time).total_seconds() or 0
            for entry in task.task_times.all() if entry.start_time and entry.stop_time
        )
        total_hours, remainder = divmod(int(total_seconds), 3600)
        total_minutes = remainder // 60

        completed_time = task.task_times.filter(stop_time__isnull=False).order_by('-stop_time').first()
        completed_time_display = completed_time.stop_time if completed_time else None

        task_details = {
            'id': task.id,
            'task_name': task.task_name,
            'description': task.description,
            'start_date': task.start_date,
            'due_date': task.due_date,
            'status': task.status,
            'priority': task.priority,
            'category': task.category,
            'assigned_to': task.assigned_to.name if task.assigned_to else "Unassigned",
            'estimated_hours': task.estimated_hours,
            'total_hours': total_hours,
            'total_minutes': total_minutes,
            'completed_time_display': completed_time_display,
        }
        task_list.append(task_details)

    total_estimated_hours = int(project.total_estimated_hours()) if project.total_estimated_hours() else 0


    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        return JsonResponse({
            'total_estimated_hours': total_estimated_hours,
            'filtered_time_spent': filtered_time_spent,  # Make sure this is included
            'total_time_spent': total_time_spent,  # Optional, for comparison
            'table_html': render_to_string('partials/timesheet.html', {'task_times': task_times})
        })
    return render(request, 'project_overview.html', {
        'project': project,
        'tasks': task_list,
        'upcoming_tasks': upcoming_tasks,
        'progress_data': progress_data,
        'project_status': project.status,  # Pass the updated project status to the template
        'total_tasks': total_tasks,
        'completed_tasks': completed_tasks,
        'status': status,
        'days_remaining': days_remaining,
        'project_lead': project_lead,
        'task_times': task_times,
        'search_query': search_query,
        'employee_id': employee_id,
        'date_filter' : date_filter,
        'completed_filter': completed_filter,
        'all_members': all_members,
        'total_estimated_hours': total_estimated_hours,
        'filtered_time_spent': filtered_time_spent,
        'total_time_spent': total_time_spent,

    })


def filter_tasks(request):
    project_id = request.GET.get('project_id')  # Required
    search_query = request.GET.get('search', '').strip()
    selected_date = request.GET.get('date', '').strip()

    if not project_id:
        return JsonResponse({'error': 'Project ID is required'}, status=400)

    # Get tasks for the specific project
    task_times = TaskTime.objects.filter(task__project_id=project_id).select_related('task')

    # ✅ Fix: Check if `assigned_to` exists in the Task model before querying
    try:
        TaskTime._meta.get_field("task__assigned_to")
        assigned_to_exists = True
    except:
        assigned_to_exists = False

    # Apply Search Filter (Tasks & Employees)
    if search_query:
        query = Q(task__task_name__icontains=search_query)
        query |= Q(task__assigned_to__name__icontains=search_query)

        if assigned_to_exists:
            query |= Q(task__assigned_to__name__icontains=search_query)

        task_times = task_times.filter(query).distinct()

    # Apply Date Filter
    if selected_date:
        try:
            filter_date = datetime.strptime(selected_date, '%Y-%m-%d').date()
            task_times = task_times.filter(start_time__date=filter_date)
        except ValueError:
            return JsonResponse({'error': 'Invalid date format'}, status=400)

    # Render the updated timesheet HTML
    html = render_to_string('partials/timesheet.html', {'task_times': task_times})

    return JsonResponse({'html': html})


def set_project_lead(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            print("Received Data:", data)  # ✅ Debugging

            project_id = data.get("project_id")
            member_reg_no = data.get("member_id")  # ✅ Use reg_no instead of id

            print("Project ID:", project_id)
            print("Member reg_no:", member_reg_no)

            project = Project.objects.get(id=project_id)
            member = user.objects.get(reg_no=member_reg_no)  # ✅ Use reg_no

            # ✅ Check if ProjectLead exists, then update or create
            project_lead, created = ProjectLead.objects.update_or_create(
                project=project,
                defaults={"user": member}
            )

            print("Project Lead Updated:", project_lead.user.name)  # ✅ Debugging
            return JsonResponse({"status": "success","message":"project lead update"})

        except user.DoesNotExist:
            return JsonResponse({"status": "error", "message": "User not found"}, status=400)

        except Project.DoesNotExist:
            return JsonResponse({"status": "error", "message": "Project not found"}, status=400)

        except Exception as e:
            print("Error:", e)  # ✅ Print the full error
            return JsonResponse({"status": "error", "message": str(e)}, status=400)

    return JsonResponse({"status": "error"}, status=400)

def remove_member(request, project_id, reg_no):
    project = get_object_or_404(Project, pk=project_id)
    member = get_object_or_404(user, reg_no=reg_no)  # Get user by reg_no

    if member in project.assigned.all():
        project.assigned.remove(member)  # Remove the user from the project
        messages.success(request, f"{member.name} has been removed from the project.")
    else:
        messages.error(request, "This member is not assigned to the project.")

    return redirect(request.META.get('HTTP_REFERER', 'project_overview'))

def new_member(request, project_id):
    project = get_object_or_404(Project, id=project_id)

    if request.method == "POST":
        member_reg_no= request.POST.get("member_reg_no")
        member = get_object_or_404(user, reg_no=member_reg_no)  # Adjust if you have a different user model

        if member in project.assigned.all():
            messages.warning(request, "Member is already assigned to this project.")
        else:
            project.assigned.add(member)
            messages.success(request, "Member added successfully!")

        return redirect("project_overview", project_id=project.id)

    return redirect("project_overview", project_id=project.id)

def task_list(request):
    tasks = Task.objects.all()  # Fetch all tasks
    project = Project.objects.all()

    # Get filter and search values from the request
    status_filter = request.GET.get('status', '')
    category_filter = request.GET.get('category', '')
    priority_filter = request.GET.get('priority', '')
    project_filter = request.GET.get('project', '')
    assigned_to_filter = request.GET.get('assigned_to', '')
    start_date_filter = request.GET.get('start_date', '')
    due_date_filter = request.GET.get('due_date', '')
    estimated_hours_filter = request.GET.get('estimated_hours', '')
    hide_completed = request.GET.get('hide_completed', '')
    search_query = request.GET.get('search', '').strip()

    if hide_completed == 'on':  # Checkbox sends 'on' if checked
        tasks = tasks.exclude(status='Completed')

    if search_query:
        tasks = tasks.filter(Q(task_name__icontains=search_query))

    if status_filter:
        tasks = tasks.filter(status=status_filter)
    if category_filter:
        tasks = tasks.filter(category=category_filter)
    if priority_filter:
        tasks = tasks.filter(priority=priority_filter)
    if project_filter:
        tasks = tasks.filter(project__id=project_filter)
    if assigned_to_filter:
        tasks = tasks.filter(assigned_to__id=assigned_to_filter)
    if start_date_filter:
        tasks = tasks.filter(start_date__gte=start_date_filter)
    if due_date_filter:
        tasks = tasks.filter(due_date__lte=due_date_filter)
    if estimated_hours_filter:
        tasks = tasks.filter(estimated_hours__gte=estimated_hours_filter)

    # Calculate time spent on tasks
    total_company_seconds = 0  # Variable to store total company time

    for task in tasks:
        total_seconds = sum(
            (entry.stop_time - entry.start_time).total_seconds()
            if entry.start_time and entry.stop_time else 0
            for entry in task.task_times.all()
        )

        # Convert seconds to hours and minutes
        task.total_hours = int(total_seconds // 3600)
        task.total_minutes = int((total_seconds % 3600) // 60)
        total_company_seconds += total_seconds  # Add to total time spent by all employees

        completed_time = task.task_times.filter(stop_time__isnull=False).order_by('-stop_time').first()
        task.completed_time_display = completed_time.stop_time if completed_time else None

    # Convert total time spent by all employees


    return render(request, 'task_list.html', {
        'tasks': tasks,
        'project': project,
        'status_filter': status_filter,
        'search_query': search_query,
        'category_filter': category_filter,
        'priority_filter': priority_filter,
        'project_filter': project_filter,
        'assigned_to_filter': assigned_to_filter,
        'start_date_filter': start_date_filter,
        'due_date_filter': due_date_filter,
        'estimated_hours_filter': estimated_hours_filter,
        'hide_completed': hide_completed,

    })

def delete_member(request, reg_no):
    member = get_object_or_404(user, reg_no=reg_no)  # Get member by reg_no
    if request.method == 'POST':
        member.delete()  # Delete the member
        return redirect('members_list')


def delete_project(request, project_id):
    project = get_object_or_404(Project, id=project_id)
    project.delete()
    return redirect('admin_assigned_projects')


def progress_page(request):
    projects = Project.objects.all()
    project_data = []

    for project in projects:
        tasks = project.tasks.all()

        # Calculate project progress as the average of all task progress
        total_progress = 0
        total_tasks = tasks.count()
        pending_tasks = tasks.filter(status='Pending').count()
        in_progress_tasks = tasks.filter(status='In Progress').count()
        completed_tasks = tasks.filter(status='Completed').count()

        for task in tasks:
            if task.status == 'Completed':
                total_progress += 100
            elif task.status == 'In Progress':
                total_progress += 60  # assuming 60% for tasks in progress
            else:
                total_progress += 0  # Pending tasks have 0% progress

        project_progress = total_progress / total_tasks if total_tasks else 0  # Average task progress

        project_data.append({
            'project_name': project.name,
            'project_description': project.description,
            'project_progress': project_progress,
            'total_tasks': total_tasks,
            'pending_tasks': pending_tasks,
            'in_progress_tasks': in_progress_tasks,
            'completed_tasks': completed_tasks,
            'tasks': tasks
        })

    return render(request, 'progress_page.html', {'project_data': project_data})

def backlog_list(request):
    # Filter tasks: High priority and Pending
    # Filter tasks: High priority and Pending
    high_priority_pending_tasks = Task.objects.filter( status='Pending').order_by('-start_date')

    # Get the most recent tasks (ordered by start_date)
    recent_tasks = Task.objects.all().order_by('-start_date')[:5]  # Adjust the limit as needed
    backlog_tasks=Task.objects.filter(status="Backlog")

    # Pass tasks to the template
    return render(request, 'backlog_list.html', {
        'high_priority_pending_tasks': high_priority_pending_tasks,
        'recent_tasks': recent_tasks,
        'backlog_tasks':backlog_tasks
    })


def sprint_dashboard(request):
    sprints = Sprint.objects.all()
    backlog_tasks = Task.objects.filter(status="Backlog")
    return render(request, 'sprint_dashboard.html', {'sprints': sprints,'backlog_tasks': backlog_tasks})
def create_sprint(request):
    if request.method == 'POST':
        form = SprintForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('sprint_dashboard')
    else:
        form = SprintForm()
    return render(request, 'create_sprint.html', {'form': form})

def sprint_detail(request, sprint_id):
    sprint = get_object_or_404(Sprint, id=sprint_id)
    sprints = Sprint.objects.all()

    # Categorize tasks by status for the selected sprint
    pending_tasks = sprint.tasks.filter(status='Pending')
    in_progress_tasks = sprint.tasks.filter(status='In Progress')
    completed_tasks = sprint.tasks.filter(status='Completed')
    backlog_tasks = Task.objects.filter(status="Backlog").exclude(sprints=sprint)

    return render(request, 'sprint_dashboard.html', {
        'sprint': sprint,
        'sprints': sprints,
        'pending_tasks': pending_tasks,
        'in_progress_tasks': in_progress_tasks,
        'completed_tasks': completed_tasks,
        'backlog_tasks': backlog_tasks,
    })


def add_task_to_sprint(request):
    if request.method == 'POST':
        task_id = request.POST.get('task_id')
        sprint_id = request.POST.get('sprint_id')

        if not task_id or not sprint_id:
            messages.error(request, "All fields are required.")
            return redirect('sprint_dashboard')

        # Fetch the task and sprint objects
        task = get_object_or_404(Task, id=task_id)
        sprint = get_object_or_404(Sprint, id=sprint_id)

        # Check the task's current status and assign it accordingly
        if task.status == "In Progress":
            sprint.in_progress_tasks.add(task)
        elif task.status == "Completed":
            sprint.completed_tasks.add(task)
        else:
            sprint.pending_tasks.add(task)
            task.status = "Pending"

        # Add the task to the sprint (will update the sprint's task list)
        sprint.tasks.add(task)
        task.save()

        messages.success(request,
                         f"Task '{task.task_name}' added to sprint '{sprint.sprint_name}' with status '{task.status}'.")
        return redirect('sprint_detail', sprint_id=sprint.id)

    return redirect('sprint_dashboard')

def update_task_status(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        task_id = data.get('id')
        new_status = data.get('status')
        try:
            task = Task.objects.get(id=task_id)
            task.status = new_status
            task.save()
            return JsonResponse({'success': True, 'status': task.status})
        except Task.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'Task not found'})
    return JsonResponse({'success': False, 'error': 'Invalid request'})


def login(request):
    if request.method == 'POST':
        email = request.POST['email']
        password = request.POST['password']

        try:
            employee = user.objects.get(email=email)

            if employee.password == password:  # Use hashed password checking in production
                request.session['employee_id'] = employee.email  # Store in session

                # Check role and redirect accordingly
                if employee.role == "admin":
                    return redirect('base')  # Redirect to admin dashboard
                else:
                    return redirect(f'/employee_dashboard/{employee.email}/')  # Redirect to employee dashboard
            else:
                messages.error(request, 'Invalid credentials.')
        except user.DoesNotExist:
            messages.error(request, "Employee not found.")

    return render(request, 'login.html')


def create_project_function(request):
    if request.method == 'POST':
        form = ProjectFunctionForm(request.POST)
        if form.is_valid():
            form.save()
            return JsonResponse({'success': True})  # Respond with success
        else:
            return JsonResponse({'success': False, 'errors': form.errors})
    return JsonResponse({'success': False, 'errors': "Invalid request"})



def get_project_details(request):
    project_id = request.GET.get('project_id')
    if project_id:
        project = get_object_or_404(Project, id=project_id)

        # Fetch client name
        client_name = project.client

        # Fetch related functions for the project
        project_functions = ProjectFunctions.objects.filter(project=project)
        functions_data = [{'id': pf.id, 'function': pf.function} for pf in project_functions]

        return JsonResponse({'client_name': client_name, 'functions': functions_data})

    return JsonResponse({'error': 'Project not found'}, status=400)


def work_hours_chart(request):
    work_hours_per_day = defaultdict(float)
    task_times = TaskTime.objects.filter(stop_time__isnull=False)

    for task in task_times:
        date = localtime(task.start_time).date()
        if task.stop_time:
            delta = task.stop_time - task.start_time
            work_hours_per_day[date] += delta.total_seconds() / 3600

    labels = list(work_hours_per_day.keys())  # Dates
    data = list(work_hours_per_day.values())  # Work hours

    print("Labels:", labels)  # Debugging
    print("Data:", data)  # Debugging

    return render(request, "employee/overview.html", {
        "labels": json.dumps(labels, default=str),
        "data": json.dumps(data)
    })




def create_milestone(request, project_id):
    project = get_object_or_404(Project, id=project_id)

    if request.method == 'POST':
        form = MilestoneForm(request.POST)
        if form.is_valid():
            milestone = form.save(commit=False)
            milestone.project = project  # Associate milestone with project
            milestone.save()
            return redirect('project_overview', project_id=project.id)
    else:
        form = MilestoneForm()

    return render(request, 'create_milestone.html', {'form': form, 'project': project})

def update_milestone(request, milestone_id):
    milestone = get_object_or_404(Milestone, id=milestone_id)

    if request.method == 'POST':
        form = MilestoneForm(request.POST, instance=milestone)
        if form.is_valid():
            milestone = form.save()

            if milestone.completed:
                TimelineEvent.objects.create(
                    project=milestone.project,
                    event_type="Milestone Reached",
                    description=f"Milestone '{milestone.title}' completed"
                )

            return redirect('project_milestone', project_id=milestone.project.id)
    else:
        form = MilestoneForm(instance=milestone)

    return render(request, 'update_milestone.html', {'form': form, 'milestone': milestone})


def project_milestone(request, project_id):
    project = get_object_or_404(Project, id=project_id)
    milestones = Milestone.objects.filter(project=project)

    return render(request, 'project_milestone.html', {'project': project, 'milestones': milestones})  # Updated here


def add_event(request, project_id):
    project = get_object_or_404(Project, id=project_id)

    if request.method == "POST":
        form = TimelineEventForm(request.POST)
        if form.is_valid():
            event = form.save(commit=False)
            event.project = project  # Associate milestone with project
            event.save()
            return redirect('project_timeline', project_id=project.id)  # Redirect after adding event
    else:
        form = TimelineEventForm()

    return render(request, "add_event.html", {"form": form, 'project':project})


def project_timeline(request, project_id):
    project = get_object_or_404(Project, id=project_id)
    milestones = Milestone.objects.filter(project=project)
    events = TimelineEvent.objects.filter(project=project)

    print("Fetched Milestones:", list(milestones))  # Debugging
    print("Fetched Events:", list(events))  # Debugging

    data = []

    for milestone in milestones:
        print(f"Processing Milestone: {milestone.title}, Due Date: {milestone.due_date}")  # Debugging
        if milestone.due_date:
            data.append({
                "Type": "Milestone",
                "Name": milestone.title,
                "Start": milestone.due_date,
                "End": milestone.due_date + timedelta(days=5),
                "Completed": "Yes" if milestone.completed else "No",
            })

    for event in events:
        print(f"Processing Event: {event.description}, Start: {event.start_date}, End: {event.end_date}")  # Debugging
        if event.start_date and event.end_date:
            data.append({
                "Type": "Event",
                "Name": event.event_type,
                "Start": event.start_date,
                "End": event.end_date,
                "Completed": "N/A",
            })

    print("Final Data for Chart:", data)  # Debugging

    if data:
        fig = px.timeline(
            data,
            x_start="Start",
            x_end="End",
            y="Name",
            color="Type",
            title=f"Project Timeline - {project.name}"
        )
        fig.update_layout(xaxis_title="Timeline", yaxis_title="Tasks & Milestones", xaxis=dict(tickformat="%Y-%m-%d"))
        chart_html = fig.to_html(full_html=False)
    else:
        chart_html = "<p>No milestones or events found for this project.</p>"

    # ✅ Pass `milestones` and `events` to the template
    return render(request, "project_timeline.html", {
        "project": project,
        "chart": chart_html,
        "milestones": milestones,  # ✅ Add this
        "events": events,  # ✅ Add this
    })


def admin_update_task(request, task_id):
    task = get_object_or_404(Task, id=task_id)

    if request.method == 'POST':
        start_time = request.POST.get('start_time')
        stop_time = request.POST.get('stop_time')

        # Start Timer
        if start_time:
            if task.status == "Pending":
                task.status = "In Progress"
                task.save()

            # Ensure no active timer exists
            latest_time = task.task_times.filter(stop_time__isnull=True).last()
            if not latest_time:
                TaskTime.objects.create(task=task, start_time=start_time)

        # Stop Timer
        if stop_time:
            latest_time = task.task_times.filter(stop_time__isnull=True).last()
            if latest_time and latest_time.start_time:
                latest_time.stop_time = stop_time
                latest_time.save()

        # Redirect Logic
        assigned_employee = task.assigned_to.first()
        if assigned_employee:
            return redirect('base')
        else:
            return redirect('some_fallback_page')  # Make sure this URL exists

    return render(request, 'admin_update_task.html', {
        'task': task,
        'total_time_spent': task.total_time_spent()  # Ensure this method is implemented in the Task model
    })