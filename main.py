import sys
import os

from pathlib import Path

#Tab Classes
from ImportClass import ImportFileButton

#Essential library for UI and QObjects
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

#Sets up the app variables
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()


ImportTab = ImportFileButton()


#Sets the variable as a context property so that qml can use it
engine.rootContext().setContextProperty("ImportTab", ImportTab)

#Sync exits so the user only has to press exit once
engine.quit.connect(app.quit)
engine.load('./UI/main.qml')

sys.exit(app.exec())