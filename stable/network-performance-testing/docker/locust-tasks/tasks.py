import uuid

from datetime import datetime
from locust import FastHttpUser, TaskSet, task


# [START locust_test_task]

class MetricsTaskSet(TaskSet):
    _deviceid = None

    def on_start(self):
        self._deviceid = str(uuid.uuid4())

    @task(1)
    def login(self):
        self.client.post(
            '/login', {"deviceid": self._deviceid})

    @task(999)
    def post_metrics(self):
        self.client.post(
            "/metrics", {"deviceid": self._deviceid, "timestamp": datetime.now()})


class MetricsLocust(FastHttpUser):
    tasks = {MetricsTaskSet}