from django.contrib import admin
from .models import Venue


@admin.register(Venue)
class VenueAdmin(admin.ModelAdmin):
    list_display = ('name', 'building', 'venue_type', 'capacity', 'is_accessible')
    list_filter = ('venue_type', 'building', 'is_accessible')
    search_fields = ('name', 'building', 'description')
    ordering = ('building', 'name')