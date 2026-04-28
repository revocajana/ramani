from django.contrib import admin
from .models import Course, StudentCourse


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'department', 'lecturer', 'credit_hours')
    list_filter = ('department',)
    search_fields = ('code', 'name', 'lecturer__first_name', 'lecturer__last_name')
    ordering = ('code',)


@admin.register(StudentCourse)
class StudentCourseAdmin(admin.ModelAdmin):
    list_display = ('student', 'course', 'enrolled_at')
    list_filter = ('course__department', 'enrolled_at')
    search_fields = ('student__first_name', 'student__last_name', 'course__name')
    ordering = ('-enrolled_at',)