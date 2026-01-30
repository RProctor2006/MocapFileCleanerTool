import sys

Dispatcher = None

class EventDispatcherC:
    def __init__(self):
        self.listners = []

    def AddListener(self, listener):
        self.listners.append(listener)

    def TriggerEvent(self, data = None):
        for listener in self.listners:
            listener(data)

Dispatcher = EventDispatcherC
