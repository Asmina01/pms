# Generated by Django 4.2.14 on 2025-02-10 08:10

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('admin_app', '0011_project_details'),
    ]

    operations = [
        migrations.CreateModel(
            name='ProjectFunctions',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('function', models.TextField()),
                ('project', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='admin_app.project_details')),
            ],
        ),
    ]
