

from django.urls import path
from . import views
from .views import *

urlpatterns = [
    path("baseuser", baseuser, name='baseuser'),

    path('task/update/<int:task_id>/', update_task, name='update_task'),
    path('task/<int:task_id>/', task_details, name='task_details'),

    path('employee_projects',employee_projects,name='employee_projects'),


    path('employee_dashboard/<str:email>/', views.employee_dashboard, name='employee_dashboard'),




    path("logout/", logout_view, name="logout"),

]