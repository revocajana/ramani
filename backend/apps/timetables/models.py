from django.db import models


class Timetable(models.Model):
    """Course schedule assignments"""

    DAY_CHOICES = [
        ('Monday', 'Monday'),
        ('Tuesday', 'Tuesday'),
        ('Wednesday', 'Wednesday'),
        ('Thursday', 'Thursday'),
        ('Friday', 'Friday'),
        ('Saturday', 'Saturday'),
    ]

    course = models.ForeignKey('courses.Course', on_delete=models.CASCADE)
    venue = models.ForeignKey('venues.Venue', on_delete=models.RESTRICT)
    day_of_week = models.CharField(max_length=10, choices=DAY_CHOICES)
    start_time = models.TimeField()
    end_time = models.TimeField()
    semester = models.IntegerField(choices=[(1, 'Semester 1'), (2, 'Semester 2')])
    academic_year = models.CharField(max_length=10)  # e.g., "2024-2025"
    capacity = models.IntegerField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'timetables'
        unique_together = ('venue', 'day_of_week', 'start_time', 'end_time')

    def __str__(self):
        return f"{self.course.code} - {self.day_of_week} {self.start_time}-{self.end_time}"