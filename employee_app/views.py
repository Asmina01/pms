from datetime import datetime

from django.db.models import Q, Sum

from django.utils import timezone

from django.shortcuts import render, redirect, get_object_or_404
from django.utils.timezone import make_aware, now

from admin_app.models import *
from .forms import CommentForm
from .models import *

from employee_app.models import TaskTime




def task_details(request, task_id):
    task = get_object_or_404(Task, id=task_id)

    # Get the latest time entry for the task
    task_time = task.times.last() if task.times.exists() else None

    if task_time:
        # Calculate time spent if the task is completed
        if task_time.stop_time:
            time_spent = task_time.stop_time - task_time.start_time
        else:
            time_spent = timezone.now() - task_time.start_time
    else:
        time_spent = None

    return render(request, 'employee/task_details.html', {
        'task': task,
        'time_spent': time_spent,
    })


def update_task(request, task_id):
    task = get_object_or_404(Task, id=task_id)

    if request.method == 'POST':
        start_time = request.POST.get('start_time')
        stop_time = request.POST.get('stop_time')

        # Start Timer
        if start_time:
            if task.status == "Pending":
                task.status = "In Progress"
                task.save()

            # Only create a new TaskTime entry if no active timer exists
            latest_time = task.task_times.filter(stop_time__isnull=True).last()
            if not latest_time:
                TaskTime.objects.create(task=task, start_time=start_time)

        # Stop Timer
        if stop_time:
            latest_time = task.task_times.filter(stop_time__isnull=True).last()
            if latest_time and latest_time.start_time:
                latest_time.stop_time = stop_time
                latest_time.save()
        assigned_employee = task.assigned_to.first()
        if assigned_employee:
            return redirect('employee_dashboard', email=assigned_employee.email)
        return redirect('some_fallback_page')


    return render(request, 'employee/update_task.html', {
        'task': task,
        'total_time_spent': task.total_time_spent()
    })

def employee_dashboard(request, email):
    try:
        # Get the employee object using the email from the URL
        employee = user.objects.get(email=email)

        # Get the tasks assigned to the employee
        tasks = Task.objects.filter(assigned_to=employee)

        # Calculate task summary
        total_tasks = tasks.count()
        completed_tasks = tasks.filter(status='Completed').count()
        pending_tasks = tasks.filter(status='Pending').count()
        in_progress_tasks = tasks.filter(status='In Progress').count()

        # Get today's date
        today = timezone.localdate()

        # Filter TaskTime entries for the specific employee today
        today_task_times = TaskTime.objects.filter(
            task__assigned_to=employee,
            start_time__date=today,
            stop_time__isnull=False  # Ensure completed tasks are considered
        )

        # Calculate total hours worked today for this employee
        total_seconds_today = sum(
            (entry.stop_time - entry.start_time).total_seconds()
            for entry in today_task_times
        )

        # Convert to hours and minutes
        total_hours_today = int(total_seconds_today // 3600)
        total_minutes_today = int((total_seconds_today % 3600) // 60)

        # Calculate total hours and minutes for each task **before filtering**
        for task in tasks:
            total_seconds = sum(
                (entry.stop_time - entry.start_time).total_seconds()
                for entry in task.task_times.all() if entry.start_time and entry.stop_time
            )

            setattr(task, 'total_hours', int(total_seconds // 3600))
            setattr(task, 'total_minutes', int((total_seconds % 3600) // 60))

        # Retrieve GET parameters for filtering tasks
        hide_completed = request.GET.get('hide_completed')
        search_query = request.GET.get('search', '').strip()
        status_filter = request.GET.get('status', '')
        category_filter = request.GET.get('category', '')
        priority_filter = request.GET.get('priority', '')
        project_filter = request.GET.get('project', '')
        start_date = request.GET.get('start_date', '')
        due_date = request.GET.get('due_date', '')
        estimated_hours = request.GET.get('estimated_hours', '')

        # Apply filters to tasks
        if hide_completed == 'on':
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
        if start_date:
            tasks = tasks.filter(start_date__gte=start_date)
        if due_date:
            tasks = tasks.filter(due_date__lte=due_date)
        if estimated_hours:
            tasks = tasks.filter(estimated_hours__gte=estimated_hours)

        # Additional details about the tasks
        for task in tasks:
            total_seconds = task.task_times.aggregate(
                total_time=Sum(models.F('stop_time') - models.F('start_time'))
            )['total_time']

            if total_seconds:
                hours = int(total_seconds.total_seconds() // 3600)
                minutes = int((total_seconds.total_seconds() % 3600) // 60)
                task.total_time_spent_formatted = f"{hours}h {minutes}m"
            else:
                task.total_time_spent_formatted = "0h 0m"

            # Fetch the last updated time entry
            completed_time = task.task_times.filter(stop_time__isnull=False).order_by('-stop_time').first()
            task.completed_time_display = completed_time.stop_time if completed_time else None

            # Prepare task details for display
            task.task_details = {
                'task_name': task.task_name,
                'description': task.description,
                'start_date': task.start_date,
                'due_date': task.due_date,
                'status': task.status,
                'priority': task.priority,
                'category': task.category,
                'total_hours': task.total_hours,
                'total_minutes': task.total_minutes,
                'completed_time_display': task.completed_time_display,
            }

        return render(request, 'employee/baseuser.html', {
            'employee': employee,
            'tasks': tasks,
            'total_tasks': total_tasks,
            'completed_tasks': completed_tasks,
            'pending_tasks': pending_tasks,
            'in_progress_tasks': in_progress_tasks,
            'total_hours_today': total_hours_today,
            'total_minutes_today': total_minutes_today,
            'search_query': search_query,
            'status_filter': status_filter,
            'category_filter': category_filter,
            'priority_filter': priority_filter,
            'project_filter': project_filter,
            'start_date': start_date,
            'due_date': due_date,
            'hide_completed': hide_completed,
            'estimated_hours': estimated_hours,
        })

    except user.DoesNotExist:
        return redirect('login')




def baseuser(request):
    if 'user_email' not in request.session:
        return redirect('login')  # Redirect to login if not authenticated

    user_instance = user.objects.get(email=request.session['user_email'])
    tasks = Task.objects.filter(assigned_to=user_instance)

    total_tasks = tasks.count()
    completed_tasks = tasks.filter(status='Completed').count()
    pending_tasks = tasks.filter(status='Pending').count()
    in_progress_tasks = tasks.filter(status='In Progress').count()

    # Assume each working day has 8 hours
    working_hours_per_day = 8
    total_working_hours = total_tasks * working_hours_per_day

    # Get today's date
    today = timezone.localdate()

    # Filter TaskTime entries for today
    today_task_times = TaskTime.objects.filter(task__assigned_to=user_instance, start_time__date=today)

    # Calculate total hours worked today
    total_seconds_today = sum(
        (entry.stop_time - entry.start_time).total_seconds()
        if entry.stop_time else (timezone.now() - entry.start_time).total_seconds()
        for entry in today_task_times
    )

    for task in tasks:
        total_seconds = sum((entry.stop_time - entry.start_time).total_seconds()
                            for entry in task.task_times.all() if entry.start_time and entry.stop_time)
        task.total_hours = int(total_seconds // 3600)
        task.total_minutes = int((total_seconds % 3600) // 60)

    total_hours_today = int(total_seconds_today // 3600)
    total_minutes_today = int((total_seconds_today % 3600) // 60)

    # Retrieve GET parameters for filtering tasks
    hide_completed = request.GET.get('hide_completed')
    search_query = request.GET.get('search', '').strip()
    status_filter = request.GET.get('status', '')
    category_filter = request.GET.get('category', '')
    priority_filter = request.GET.get('priority', '')
    project_filter = request.GET.get('project', '')
    start_date = request.GET.get('start_date', '')
    due_date = request.GET.get('due_date', '')
    estimated_hours = request.GET.get('estimated_hours', '')

    # Base queryset
    tasks = Task.objects.filter(assigned_to=user_instance)

    # Apply filters to tasks
    if hide_completed == 'on':
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
    if start_date:
        tasks = tasks.filter(start_date__gte=start_date)
    if due_date:
        tasks = tasks.filter(due_date__lte=due_date)
    if estimated_hours:
        tasks = tasks.filter(estimated_hours__gte=estimated_hours)

    # Additional details about the tasks
    for task in tasks:
        total_seconds = sum((entry.stop_time - entry.start_time).total_seconds()
                            for entry in task.task_times.all() if entry.start_time and entry.stop_time)
        task.total_hours = int(total_seconds // 3600)
        task.total_minutes = int((total_seconds % 3600) // 60)

        completed_time = task.task_times.filter(stop_time__isnull=False).order_by('-stop_time').first()
        task.completed_time_display = completed_time.stop_time if completed_time else None

        # You can include task details like description, start date, and other fields here
        task_details = {
            'task_name': task.task_name,
            'description': task.description,
            'start_date': task.start_date,
            'due_date': task.due_date,
            'status': task.status,
            'priority': task.priority,
            'category': task.category,
            'assigned_to': task.assigned_to.username,
            'total_hours': task.total_hours,
            'total_minutes': task.total_minutes,
            'completed_time_display': task.completed_time_display,
        }
        task.task_details = task_details

    context = {
        'user': user_instance,
        'tasks': tasks,
        'total_tasks': total_tasks,
        'completed_tasks': completed_tasks,
        'pending_tasks': pending_tasks,
        'in_progress_tasks': in_progress_tasks,
        'total_working_hours': total_working_hours,
        'total_hours_today': total_hours_today,
        'total_minutes_today': total_minutes_today,
        'search_query': search_query,
        'status_filter': status_filter,
        'category_filter': category_filter,
        'priority_filter': priority_filter,
        'project_filter': project_filter,
        'start_date': start_date,
        'due_date': due_date,
        'hide_completed': hide_completed,
        'estimated_hours': estimated_hours,
    }

    return render(request, 'employee/baseuser.html', context)


def logout_view(request):
    request.session.flush()  # Clear session data
    return redirect('login')


def employee_projects(request):
    # Ensure the user is logged in
    if 'user_reg_no' not in request.session:
        return redirect('login')

    # Get the logged-in user instance
    user_instance = user.objects.get(reg_no=request.session['user_reg_no'])

    # Get filter parameters from the request
    status_filter = request.GET.get('status', '')
    priority_filter = request.GET.get('priority', '')
    category_filter = request.GET.get('category', '')
    start_date = request.GET.get('start_date', '')
    due_date = request.GET.get('due_date', '')
    no_deadline = request.GET.get('no_deadline', '')
    client_filter = request.GET.get('client', '')
    search_query = request.GET.get('search', '')

    # Start with projects assigned to the logged-in employee
    projects = Project.objects.filter(assigned=user_instance)

    # Apply filters if provided
    if status_filter:
        projects = projects.filter(status=status_filter)
    if priority_filter:
        projects = projects.filter(priority=priority_filter)
    if category_filter:
        projects = projects.filter(category=category_filter)
    if start_date:
        projects = projects.filter(start_date__gte=start_date)
    if due_date:
        projects = projects.filter(due_date__lte=due_date)
    if no_deadline:  # Check if "No Deadline" is selected
        projects = projects.filter(due_date__isnull=True)
    if client_filter:  # Filter by client if provided
        projects = projects.filter(client=client_filter)

    # Apply search filter
    if search_query:
        projects = projects.filter(
            Q(name__icontains=search_query) |
            Q(assigned_to__name__icontains=search_query)  # Ensure field name matches your model
        ).distinct()

    total_projects = projects.count()  # Count total number of projects

    clients = Project.objects.values_list('client', flat=True).distinct()

    # Pass current filters to the template for maintaining state
    context = {
        'projects': projects,
        'total_projects': total_projects,
        'status_filter': status_filter,
        'priority_filter': priority_filter,
        'category_filter': category_filter,
        'search_query': search_query,
        'start_date': start_date,
        'due_date': due_date,
        'no_deadline': no_deadline,
        'client_filter': client_filter,
        'clients': clients
    }

    return render(request, 'employee/employee_projects.html', context)



