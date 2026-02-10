import sys
import os


#Tab Classes
from ToolFunctions import ToolMethods

#Essential library for UI
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

#Sets up the app variables
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()

Tools = ToolMethods()

#Sets the variable as a context property so that qml can use it
engine.rootContext().setContextProperty("Tools", Tools)

#Loads main.qml for UI
engine.load('./UI/main.qml')

#Sync exits so the user only has to press exit once
engine.quit.connect(app.quit)

sys.exit(app.exec())