from django.contrib import admin
from .models import Timetable


@admin.register(Timetable)
class TimetableAdmin(admin.ModelAdmin):
    list_display = ('course', 'venue', 'day_of_week', 'start_time', 'end_time', 'semester', 'academic_year')
    list_filter = ('day_of_week', 'semester', 'academic_year', 'course__department')
    search_fields = ('course__name', 'course__code', 'venue__name', 'venue__building')
    ordering = ('day_of_week', 'start_time')