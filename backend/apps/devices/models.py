from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Device(models.Model):
    """Mobile device tracking for push notifications"""

    DEVICE_TYPE_CHOICES = [
        ('iOS', 'iOS'),
        ('Android', 'Android'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    device_token = models.CharField(max_length=500, unique=True)
    device_type = models.CharField(max_length=20, choices=DEVICE_TYPE_CHOICES)
    device_name = models.CharField(max_length=255, blank=True)
    is_active = models.BooleanField(default=True)
    last_active = models.DateTimeField(auto_now_add=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'devices'

    def __str__(self):
        return f"{self.user} - {self.device_type} ({self.device_name})"