from django.contrib import admin
from .models import Department


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'head_of_department')
    search_fields = ('code', 'name', 'head_of_department')
    ordering = ('code',)