# Generated by Django 4.2.14 on 2025-03-13 05:22

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('employee_app', '0011_tasktime_time_spent'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tasktime',
            name='time_spent',
        ),
    ]
