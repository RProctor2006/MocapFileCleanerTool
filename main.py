import sys
import os


#Tab Classes
from ImportClass import ImportFileButton

#Essential library for UI
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

#Sets up the app variables
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()


ImportTab = ImportFileButton()


#Sets the variable as a context property so that qml can use it
engine.rootContext().setContextProperty("ImportTab", ImportTab)

#Loads main.qml for UI
engine.load('./UI/main.qml')

#Sync exits so the user only has to press exit once
engine.quit.connect(app.quit)

sys.exit(app.exec())