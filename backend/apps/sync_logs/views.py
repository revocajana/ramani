from rest_framework import viewsets
from .models import SyncLog
from .serializers import SyncLogSerializer


class SyncLogViewSet(viewsets.ModelViewSet):
    queryset = SyncLog.objects.all()
    serializer_class = SyncLogSerializer