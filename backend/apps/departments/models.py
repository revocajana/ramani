from django.db import models


class Department(models.Model):
    """Academic departments at NIT"""

    name = models.CharField(max_length=255, unique=True)
    code = models.CharField(max_length=50, unique=True)
    head_of_department = models.CharField(max_length=255, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'departments'

    def __str__(self):
        return f"{self.code} - {self.name}"