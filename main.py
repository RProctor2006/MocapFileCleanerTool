import sys
import os


#Tab Classes
from ImportClass import ImportFileButton
from CleanupClass import CleanupFunctions
from EventDispatcher import Dispatcher

#Essential library for UI
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine

#Sets up the app variables
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()

ImportTab = ImportFileButton()
CleanupTab = None

def InitialiseCleanupClass():
    CleanupTab = CleanupFunctions(ImportTab.GetFilePath())
    return

Dispatcher.AddListener(InitialiseCleanupClass())




#Sets the variable as a context property so that qml can use it
engine.rootContext().setContextProperty("ImportTab", ImportTab)
engine.rootContext().setContextProperty("CleanupFunctions", CleanupTab)

#Loads main.qml for UI
engine.load('./UI/main.qml')

#Sync exits so the user only has to press exit once
engine.quit.connect(app.quit)

sys.exit(app.exec())