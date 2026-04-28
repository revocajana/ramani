from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Notification(models.Model):
    """System notifications for users"""

    TYPE_CHOICES = [
        ('class_reminder', 'Class Reminder'),
        ('schedule_change', 'Schedule Change'),
        ('venue_update', 'Venue Update'),
        ('system', 'System'),
        ('other', 'Other'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    type = models.CharField(max_length=50, choices=TYPE_CHOICES)
    title = models.CharField(max_length=255)
    message = models.TextField()
    related_course = models.ForeignKey('courses.Course', on_delete=models.SET_NULL, null=True, blank=True)
    related_timetable = models.ForeignKey('timetables.Timetable', on_delete=models.SET_NULL, null=True, blank=True)
    is_read = models.BooleanField(default=False)
    sent_at = models.DateTimeField(auto_now_add=True)
    read_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notifications'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user} - {self.title}"