import sys
import os

import tkinter as tk
from tkinter.filedialog import askopenfilename

from EventDispatcher import Dispatcher

import shutil #High level file operations module

#Essential library for QObjects and Slot to pass through methods to qml
from PyQt6.QtCore import QObject, pyqtSlot

class ImportFileButton(QObject):
    
    def __init__(self):
        super().__init__()
        self.fn = ""
        self.fileImported = False

    def BackupFile(self):
        if self.fn != "":
            shutil.copy2(self.fn, "./FileBackup") #Calling shutils 'copy2'   is better than normal 'copy' as it attempts to preserve metadata

    #Assigning Slot to this allows it to be called from qml
    @pyqtSlot()
    def ImportFile(self): #Opens the file explorer so that the user can select the animation file
        tk.Tk().withdraw()

        #The function that opens the explorer, the arguments limit the chosen file types to only be fbx
        self.fn = askopenfilename(filetypes=[("FBX Files", ".fbx")])
        print("user chose ", self.fn)

        ImportFileButton.BackupFile(self)
        Dispatcher.TriggerEvent()

    def GetFilePath(self):
        return self.fn
    
    def GetFileImported(self):
        return self.fileImported