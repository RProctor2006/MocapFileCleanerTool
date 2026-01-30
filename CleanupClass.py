import sys
import os

from PyQt6.QtCore import QObject, pyqtSlot
from ImportClass import ImportFileButton #Need the import class to access the get file path function
import fbx #Imports the fbx sdk


class CleanupFunctions(QObject):

    def __init__(self, filePath: str, CamPrefix = "", ULMarkPrefix = ""):        #Constructor w/ prefix variables
        super().__init__()

        print(filePath)

        #Store prefixes and file path
        self.CamPrefix = CamPrefix
        self.ULMarkPrefix = ULMarkPrefix
        self.FilePath = filePath

        #FBX SDK Objects
        self.Manager = fbx.FbxManager.Create()
        self.Scene = fbx.FbxScene.Create(self.Manager, "Scene")

        #Get Root Node (The parent of all the scene elements)
        Root = self.Scene.GetRootNode()
        
        if not Root:
            print("No root node found in scene.")
            self.Manager.Destroy()
            return
        
        #Lists that will be filled with the found markers and cameras
        self.Cameras: list[fbx.FbxNode] = []
        self.ULMarkers: list[fbx.FbxNode] = []
        

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

    def FindNodesRecursive(self, node: fbx.FbxNode):
        print("recursive function called")
        print(f"Root Node Child Count: {node.GetChildCount()}")

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
            print(f"Number of Cameras: {len(self.Cameras.count())}         Number of Unlabelled Markers: {len(self.ULMarkers.count())}")

