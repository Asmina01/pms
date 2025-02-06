from django import forms
from .models import Project, Task, Taskprogress, user, Sprint, ProjectFunctions, Milestone, TimelineEvent


# Form for user model
class UserForm(forms.ModelForm):
    class Meta:
        model = user
        fields = ['reg_no', 'name', 'designation', 'image', 'phone', 'email','password']
        widgets = {
            'reg_no': forms.TextInput(attrs={'class': 'form-control'}),
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'designation': forms.TextInput(attrs={'class': 'form-control'}),
            'phone': forms.TextInput(attrs={'class': 'form-control'}),
            'email': forms.EmailInput(attrs={'class': 'form-control'}),
            'image': forms.ClearableFileInput(attrs={'class': 'form-control-file'}),
            'password': forms.PasswordInput(attrs={'class': 'form-control'})
        }

        def save(self, commit=True):
            # Create a user instance but don't save it yet
            instance = super().save(commit=False)


            if commit:
                instance.save()
            return instance

# Form for Project model
class ProjectForm(forms.ModelForm):
    no_deadline = forms.BooleanField(required=False, label="No Deadline for this project", initial=False)

    assigned = forms.ModelMultipleChoiceField(
        queryset=user.objects.all(),
        widget=forms.CheckboxSelectMultiple,  # This will render a list of checkboxes
        label="Assigned Members"
    )

    class Meta:
        model = Project
        fields = ['name','short_code', 'client','description','category', 'files', 'assigned','budget', 'start_date', 'due_date', 'progress','category','status','priority']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'short_code': forms.TextInput(attrs={'class': 'form-control'}),
            'client': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control'}),
            'start_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'due_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'progress': forms.NumberInput(attrs={'class': 'form-control', 'min': 0, 'max': 100}),
            'category': forms.Select(attrs={'class': 'form-select'}),
            'assigned': forms.Select(attrs={'class': 'form-select'}),
            'status': forms.Select(attrs={'class':'form-select'}),
            'priority': forms.Select(attrs={'class': 'form-select'}),
            'budget': forms.TextInput(attrs={'class': 'form-control'}),


        }

        def clean_due_date(self):
            if self.cleaned_data.get('no_deadline'):
                return None  # If 'No Deadline' is selected, set due_date to None
            return self.cleaned_data.get('due_date')




class MilestoneForm(forms.ModelForm):
    class Meta:
        model = Milestone
        fields = ['title', 'description', 'due_date', 'completed']

class TimelineEventForm(forms.ModelForm):
    class Meta:
        model = TimelineEvent
        fields = ['event_type', 'description','start_date','end_date']
        widgets={
            'start_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'end_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
        }


class SprintForm(forms.ModelForm):
    class Meta:
        model = Sprint
        fields = ['sprint_name', 'start_date', 'end_date','description']

    widgets = {

        'start_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
        'end_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
        'estimated_hours': forms.NumberInput(attrs={'class': 'form-control'}),
    }



class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = '__all__'
        widgets = {
            'task_name': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class': 'form-control'}),
            'category': forms.Select(attrs={'class': 'form-control'}),
            'priority': forms.Select(attrs={'class': 'form-control'}),
            'status': forms.Select(attrs={'class': 'form-control'}),
            'start_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'due_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'estimated_hours': forms.NumberInput(attrs={'class': 'form-control'}),
        }

    def __init__(self, *args, **kwargs):
        project_id = kwargs.pop('project_id', None)  # Get project ID if provided
        super(TaskForm, self).__init__(*args, **kwargs)

        if project_id:
            self.fields['function'].queryset = ProjectFunctions.objects.filter(project_id=project_id)
        else:
            self.fields['function'].queryset = ProjectFunctions.objects.none()


class TaskProgressForm(forms.ModelForm):
    class Meta:
        model = Taskprogress
        fields = ['task', 'user', 'start_time', 'end_time']
        widgets = {
            'start_time': forms.DateTimeInput(attrs={'class': 'form-control', 'type': 'datetime-local'}),
            'end_time': forms.DateTimeInput(attrs={'class': 'form-control', 'type': 'datetime-local'}),
        }


class UserLoginForm(forms.Form):
    email = forms.CharField(max_length=50, widget=forms.EmailInput(attrs={'class': 'form-control'}))
    password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control'}))


class ProjectFunctionForm(forms.ModelForm):
    project = forms.ModelChoiceField(
        queryset=Project.objects.all(),
        empty_label="Select a Project",
        label="Project",
        widget=forms.Select(attrs={'class': 'form-select'})
    )

    function = forms.CharField(
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Enter Function Name'}),
        label="Function Name"
    )

    class Meta:
        model = ProjectFunctions
        fields = ['project', 'function']
        fields = ['project', 'function']