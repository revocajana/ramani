from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Course(models.Model):
    """Academic courses offered at NIT"""

    code = models.CharField(max_length=100, unique=True)
    name = models.CharField(max_length=255)
    department = models.ForeignKey('departments.Department', on_delete=models.CASCADE)
    lecturer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True,
                                limit_choices_to={'role': 'lecturer'})
    credit_hours = models.IntegerField(null=True, blank=True)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'courses'

    def __str__(self):
        return f"{self.code} - {self.name}"


class StudentCourse(models.Model):
    """Junction table for student-course enrollments"""

    student = models.ForeignKey(User, on_delete=models.CASCADE, limit_choices_to={'role': 'student'})
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    enrolled_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'student_courses'
        unique_together = ('student', 'course')

    def __str__(self):
        return f"{self.student} - {self.course}"