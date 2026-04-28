from django.contrib import admin
from .models import SyncLog


@admin.register(SyncLog)
class SyncLogAdmin(admin.ModelAdmin):
    list_display = ('user', 'sync_type', 'status', 'synced_records', 'created_at')
    list_filter = ('sync_type', 'status', 'created_at')
    search_fields = ('user__email', 'error_message')
    ordering = ('-created_at',)