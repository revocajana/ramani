from django.contrib import admin
from .models import Device


@admin.register(Device)
class DeviceAdmin(admin.ModelAdmin):
    list_display = ('user', 'device_type', 'device_name', 'is_active', 'last_active')
    list_filter = ('device_type', 'is_active', 'last_active')
    search_fields = ('user__email', 'device_name', 'device_token')
    ordering = ('-last_active',)