import requests
import datetime
import time
import sys
from requests.auth import HTTPBasicAuth
from urllib3.exceptions import InsecureRequestWarning

class Logger(object):
    def __init__(self):
        self.terminal = sys.stdout
        self.log = open("logfile.log", "a")

    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def flush(self):
        # this flush method is needed for python 3 compatibility.
        # this handles the flush command by doing nothing.
        # you might want to specify some extra behavior here.
        pass

sys.stdout = Logger()
# this flush method is needed for python 3 compatibility.
# this handles the flush command by doing nothing.
# you might want to


REPLICATOR_URL = "https://localhost:8083/WorkerMetrics/replicator"
REPLICATOR_USER = "emmy"
REPLIACTOR_USER_PASSWORD = "emmy-secret"
# How often to query (in seconds)
POLL_FREQUENCY = 1
# How many times to poll
POLL_COUNT = 40000


requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)


count = 0
while count < POLL_COUNT:
    res = requests.get(REPLICATOR_URL, verify=False, auth=HTTPBasicAuth(REPLICATOR_USER, REPLIACTOR_USER_PASSWORD))
    data = res.json()
    for task in data['tasks']:
        for subtask in task['metrics']:
            # if subtask['srcTopic'] == "test-producing":
                # print("FOUND:" + subtask['srcTopic'])
            if subtask['messageLag'] > 0:
                print("ALERT!!!   Replicator Lag Greater than ZERO")
                print(subtask['destTopic'])
                print(subtask['messageLag'])
                # Maybe we want the script to quit if this is lag??
                # quit()
            ct = datetime.datetime.now()
            print(ct.strftime("%H:%M:%S") + " topic: " + subtask['destTopic'] + "/Partition " +
                  str(subtask['srcPartition']) + " | message lag: " + str(subtask['messageLag']))
    time.sleep(POLL_FREQUENCY)
    count = count + 1