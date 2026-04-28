from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class SyncLog(models.Model):
    """Track mobile app data synchronization"""

    SYNC_TYPE_CHOICES = [
        ('venues', 'Venues'),
        ('timetables', 'Timetables'),
        ('notifications', 'Notifications'),
        ('full', 'Full Sync'),
    ]

    STATUS_CHOICES = [
        ('success', 'Success'),
        ('pending', 'Pending'),
        ('failed', 'Failed'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    device = models.ForeignKey('devices.Device', on_delete=models.SET_NULL, null=True, blank=True)
    sync_type = models.CharField(max_length=50, choices=SYNC_TYPE_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    error_message = models.TextField(blank=True)
    synced_records = models.IntegerField(null=True, blank=True)
    last_sync_time = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'sync_logs'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user} - {self.sync_type} ({self.status})"