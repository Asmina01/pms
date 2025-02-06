from datetime import timedelta

from django.core.exceptions import ValidationError
from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from django.utils.dateparse import parse_datetime

from admin_app.models import *

class TaskTime(models.Model):
    task = models.ForeignKey(Task, related_name='task_times', on_delete=models.CASCADE)
    start_time = models.DateTimeField(null=True, blank=True)
    stop_time = models.DateTimeField(null=True, blank=True)
    completed_time = models.DateTimeField(null=True, blank=True)

    def save(self, *args, **kwargs):
        """Ensure stop_time is after start_time"""

        # Convert strings to datetime if they are not already datetime objects
        if isinstance(self.start_time, str):
            self.start_time = parse_datetime(self.start_time)

        if isinstance(self.stop_time, str):
            self.stop_time = parse_datetime(self.stop_time)

        if self.start_time and self.stop_time:
            if self.start_time > self.stop_time:
                raise ValidationError("Stop time cannot be earlier than start time.")

        super().save(*args, **kwargs)

    @property
    def time_spent(self):
        """Return time spent in HH:MM format for this session"""
        if self.start_time and self.stop_time:
            total_seconds = (self.stop_time - self.start_time).total_seconds()
            hours = int(total_seconds // 3600)
            minutes = int((total_seconds % 3600) // 60)
            return f"{hours}h {minutes}m"
        return None

    def __str__(self):
        return f"{self.task.task_name} - {self.time_spent}"






class Comment(models.Model):
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(user, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Comment by {self.user.name} on {self.project.name}"

