from django import forms

from admin_app.models import Task
from .models import *
from employee_app.models import TaskTime


class TaskUpdateForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ['status']


from django import forms


class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ['content']
        widgets = {
            'content': forms.Textarea(attrs={'class': 'form-control', 'rows': 3}),
        }
