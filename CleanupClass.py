import sys
import os

from PyQt6.QtCore import QObejct, pyqtSlot
from ImportClass import ImportFileButton #Need the import class to access the get file path function
import fbx #Imports the fbx sdk


ImportTab = ImportFileButton

FilePath = ImportTab.GetFileName()


#Creates the fbx manager
Manager = fbx.FbxManager.Create()

#Creates the fbx importer
Importer = fbx.FbxImporter.Create("Manager", Manager)


class CleanupFunctions(QObject):
    def __init__(self):
        super().__init__()

    