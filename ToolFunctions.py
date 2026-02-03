import sys
import os

import tkinter as tk
from tkinter.filedialog import askopenfilename

import shutil #High level file operations module

#Essential library for QObjects and Slot to pass through methods to qml
from PyQt6.QtCore import QObject, pyqtSlot

import fbx

class ToolMethods(QObject):

    #Store prefixes and file path
    CamPrefix = ""
    ULMarkPrefix = ""
    FilePath = ""

    #FBX SDK Objects
    Manager = fbx.FbxManager.Create()
    Scene = fbx.FbxScene.Create(Manager, "Scene")

    #Get Root Node (The parent of all the scene elements)
    Root = Scene.GetRootNode()

    #Lists that will be filled with the found markers and cameras
    Cameras: list[fbx.FbxNode] = []
    ULMarkers: list[fbx.FbxNode] = []
    
    def __init__(self):
        super().__init__()
        self.FilePath = ""

    def BackupFile(self):
        if self.FilePath != "":
            shutil.copy2(self.FilePath, "./FileBackup") #Calling shutils 'copy2'   is better than normal 'copy' as it attempts to preserve metadata

    #Assigning Slot to this allows it to be called from qml
    @pyqtSlot()
    def ImportFile(self): #Opens the file explorer so that the user can select the animation file
        tk.Tk().withdraw()

        #The function that opens the explorer, the arguments limit the chosen file types to only be fbx
        self.FilePath = askopenfilename(filetypes=[("FBX Files", ".fbx")])
        print("user chose ", self.FilePath)

        ToolMethods.BackupFile(self)

    def GetFilePath(self):
        return self.FilePath
    
    def GetFileImported(self):
        return self.fileImported
        

    def ImportSceneFbx(self):
        Importer = fbx.FbxImporter.Create(self.Manager, "Importer")

        #Import FBX file
        if not Importer.Initialize(self.FilePath, -1, None):
            print(f"Failed to initialize importer for {self.FilePath}")
            Importer.Destroy #Manual garbage collection since the sdk is a C++ library wrapped in python there is risk 
            self.Manager.Destroy  #of memory not being fully managed by Pythons GC, ensures no memory leaks and other problems
            return
        
        Importer.Import(self.Scene)
        Importer.Destroy()


    #Recursively checks the scene for cameras and markers
    @pyqtSlot()
    def FindNodes(self):
        print(self.FilePath)
        self.ImportSceneFbx()
        root = self.Scene.GetRootNode()
        if root:
            self.FindNodesRecursive(root)

    def PrintNodeCount(self):
        print(f"Cameras found: {len(self.Cameras)}")
        print(f"Unlabelled Markers found: {len(self.ULMarkers)}")

    def FindNodesRecursive(self, node: fbx.FbxNode):
        print("recursive function called")

        for i in range(node.GetChildCount()):
            child = node.GetChild(i)
            attr = child.GetNodeAttribute()

            if attr:
                attrType = attr.GetAttributeType()
                
                #Cameras
                if attrType == fbx.FbxNodeAttribute.EType.eCamera:
                    if not self.CamPrefix or child.GetName().startswith(self.CamPrefix):
                        self.Cameras.append(child)

                #Markers
                if attrType == fbx.FbxNodeAttribute.EType.eMarker:
                    name = child.GetName()
                    if not name or (
                        self.ULMarkPrefix and name.startswith(self.ULMarkPrefix)
                    ):
                        self.ULMarkers.append(child)
            self.FindNodesRecursive(child)
        self.PrintNodeCount()