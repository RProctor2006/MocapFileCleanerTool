import sys
import os

import tkinter as tk
from tkinter.filedialog import askopenfilename

#Essential library for QObjects and Slot to pass through methods to qml
from PyQt6.QtCore import QObject, pyqtSlot

fn = ""

class ImportFileButton(QObject):
    def __init__(self):
        super().__init__()

    #Assigning Slot to this allows it to be called from qml
    @pyqtSlot(str)
    def ImportFile(self): #Opens the file explorer so that the user can select the animation file
        tk.Tk().withdraw()

        #The function that opens the explorer, the arguments limit the chosen file types to only be fbx
        fn = askopenfilename(filetypes=[("FBX Files", ".fbx")])
        print("user chose ", fn)

    def GetFileName(self):
        if (fn != ""):
            return fn
        
        print("No file chosen")