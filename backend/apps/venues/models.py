from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Venue(models.Model):
    """Campus venues (lecture halls, offices, labs, etc.)"""

    VENUE_TYPE_CHOICES = [
        ('lecture_hall', 'Lecture Hall'),
        ('office', 'Office'),
        ('laboratory', 'Laboratory'),
        ('library', 'Library'),
        ('cafeteria', 'Cafeteria'),
        ('bookshop', 'Bookshop'),
        ('auditorium', 'Auditorium'),
        ('wellness_center', 'Wellness Center'),
        ('computer_lab', 'Computer Lab'),
        ('sports_facility', 'Sports Facility'),
        ('parking', 'Parking'),
        ('other', 'Other'),
    ]

    name = models.CharField(max_length=255)
    building = models.CharField(max_length=255)
    venue_type = models.CharField(max_length=50, choices=VENUE_TYPE_CHOICES)
    latitude = models.DecimalField(max_digits=10, decimal_places=8)
    longitude = models.DecimalField(max_digits=11, decimal_places=8)
    capacity = models.IntegerField(null=True, blank=True)
    assigned_user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    amenities = models.TextField(blank=True)
    description = models.TextField(blank=True)
    floor_number = models.IntegerField(null=True, blank=True)
    is_accessible = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'venues'
        unique_together = ('name', 'building')

    def __str__(self):
        return f"{self.building} - {self.name}"