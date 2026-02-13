import sys
import os


#Tab Classes
from ToolFunctions import ToolMethods

#Essential library for UI
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

#Gets the resource path
def ResourcePath(relativePath):
    if hasattr(sys, "_MEIPASS"):
        return os.path.join(sys._MEIPASS, relativePath)
    return os.path.join(os.path.abspath("."), relativePath)

#Gets the base path of the application
def AppBasePath():
    if hasattr(sys, "_MEIPASS"):
        #Running pyinstaller bundle
        return os.path.dirname(sys.executable)
    else:
        #Running normally
        return os.path.abspath(".")
    
#Creates export and backup folders
def EnsureDirectories():
    base = AppBasePath()

    exportPath = os.path.join(base, "Exports")
    backupPath = os.path.join(base, "FileBackup")

    os.makedirs(exportPath, exist_ok=True)
    os.makedirs(backupPath, exist_ok=True)

    return exportPath, backupPath

#Sets up the app variables
app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()

Tools = ToolMethods()

#Sets the variable as a context property so that qml can use it
engine.rootContext().setContextProperty("Tools", Tools)

EnsureDirectories()

#Loads main.qml for UI
engine.load(ResourcePath('./UI/main.qml'))

#Sync exits so the user only has to press exit once
engine.quit.connect(app.quit)

sys.exit(app.exec())