import sys
import os

import tkinter as tk
from tkinter.filedialog import askopenfilename

import shutil #High level file operations module

#Essential library for QObjects and Slot to pass through methods to qml
from PyQt6.QtCore import QObject, pyqtSlot

import fbx

class ToolMethods(QObject):

    #Store prefixes
    CamPrefix = ""
    ULMarkPrefix = ""
    
    #Lists that will be filled with the found markers and cameras
    Cameras: list[fbx.FbxNode] = []
    ULMarkers: list[fbx.FbxNode] = []

    FilePath = ""

    #FBX SDK Objects
    Manager = fbx.FbxManager.Create()
    Scene = fbx.FbxScene.Create(Manager, "Scene")

    #Get Root Node (The parent of all the scene elements)
    Root = Scene.GetRootNode()

    
    #Import functions
    #Constructor
    def __init__(self):
        super().__init__()
        self.FilePath = ""

    def BackupFile(self):
        if self.FilePath != "":
            shutil.copy2(self.FilePath, "./FileBackup") #Calling shutils 'copy2'   is better than normal 'copy' as it attempts to preserve metadata

    #Imports the scene to access the elements
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

    #Assigning Slot to this allows it to be called from qml
    @pyqtSlot()
    def ImportFile(self): #Opens the file explorer so that the user can select the animation file
        tk.Tk().withdraw()

        #The function that opens the explorer, the arguments limit the chosen file types to only be fbx
        self.FilePath = askopenfilename(filetypes=[("FBX Files", ".fbx")])
        print("user chose ", self.FilePath)

        ToolMethods.BackupFile(self)
        self.ImportSceneFbx()
        

    #Cleanup functions
    #Debug function to show how many nodes have been found
    def PrintNodeCount(self):
        print(f"Cameras found: {len(self.Cameras)}")
        print(f"Unlabelled Markers found: {len(self.ULMarkers)}")


    #Temporary export function to test deletion methods
    def ExportScene(self):
        OutputPath = "./Exports/TestExport"

        #If no scene
        if not self.Scene:
            print("No scene to export.")
            return
        
        #Creates exporter object
        exporter = fbx.FbxExporter.Create(self.Manager, "Exporter")

        #If can't initialize exporter
        if not exporter.Initialize(OutputPath, -1, self.Manager.GetIOSettings()):
            print(f"Failed to initialize exporter for {OutputPath}")
            exporter.Destroy()
            return
        
        exporter.Export(self.Scene)
        exporter.Destroy()

        print(f"Scene exported to: {OutputPath}")


    #Pre function of recursive node finder function
    #Gets the root and checks if its valid to feed into the recursive function with the root node being passsed in
    @pyqtSlot()
    def FindNodes(self):
        print(self.FilePath)
        root = self.Scene.GetRootNode()
        if root:
            self.FindNodesRecursive(root)

    #Recursively checks all of the root children for cameras and markers
    def FindNodesRecursive(self, node: fbx.FbxNode):
        print("recursive function called")

        #Iterate through root scene and get all children & their attribute type
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
                    if not self.ULMarkPrefix or child.GetName().startswith(self.ULMarkPrefix):
                        self.ULMarkers.append(child)
            self.FindNodesRecursive(child)
        self.PrintNodeCount()

    @pyqtSlot()
    def DeleteCameras(self):
        
        #Check if there are cameras to delete
        if not self.Cameras:
            print("No cameras to delete.")
            return
        
        #Iterates through all found cameras
        for cameraNode in self.Cameras:
            parent = cameraNode.GetParent() #Gets the parent of the camera as it must be removed from the parent before being destroyed.

            if parent:
                parent.RemoveChild(cameraNode)
                
            cameraNode.Destroy()

        self.Cameras.clear()

    @pyqtSlot()
    def DeleteULMarkers(self):

        if not self.ULMarkers:
            print("No un-labelled markers to delete.")
            return
        
        for marker in self.ULMarkers:
            parent = marker.GetParent()

            if parent:
                parent.RemoveChild(marker)

            marker.Destroy()

        self.ULMarkers.clear()
        self.ExportScene()
    


    #Edit Functions
    #Finds top level skeleton nodes but doesn't stop when finding one
    def FindSkeletonRoots(self, node: fbx.FbxNode, roots: list[fbx.FbxNode]):
        attr = node.GetNodeAttribute()
        print(node.GetChildCount())

        if attr and attr.GetAttributeType() == fbx.FbxNodeAttribute.EType.eSkeleton:
            parent = node.GetParent()

            if not parent or not parent.GetNodeAttribute() or \
            parent.GetNodeAttribute().GetAttributeType() != fbx.FbxNodeAttribute.EType.eSkeleton:
                roots.append(node)
        
        for i in range(node.GetChildCount()):
            self.FindSkeletonRoots(node.GetChild(i), roots)
    

    #Counts bones under the skeleton roots
    def CountSkeletonBones(self, node: fbx.FbxNode) -> int:
        count = 1
        for i in range(node.GetChildCount()):
            count += self.CountSkeletonBones(node.GetChild(i))
        
        return count
    

    #Finds the character skeleton based on the amount of bones
    def FindCharacterSkeleton(self) -> fbx.FbxNode | None:

        #Makes the list that 'FindSkeletonRoots' appends to
        roots: list[fbx.FbxNode] = []
        self.FindSkeletonRoots(self.Scene.GetRootNode(), roots)

        #If there are no skeleton bones found return none
        if not roots:
            print("No bones found.")
            return None
        
        #Initialises best root and best count vars
        bestRoot = None #Will hold the character root bone
        bestCount = 0   #Best count set to 0 to be overriden by root counts

        for root in roots:
            count = self.CountSkeletonBones(root)
            print(f"Skeleton '{root.GetName()}' has {count} bones")

            if count > bestCount:
                bestCount = count
                bestRoot = root
        
        return bestRoot
    
    def CollectSkeletonBones(self, root: fbx.FbxNode) -> list[fbx.FbxNode]:
        bones = []

        def recurse(n: fbx.FbxNode):
            bones.append(n)
            for i in range(n.GetChildCount()):
                recurse(n.GetChild(i))

        recurse(root)
        return bones

    #Creates the root bone and reparents the skeleton to the root bone
    def CreateRootBone(self, pelvisNode: fbx.FbxNode) -> fbx.FbxNode:
        scene = self.Scene
        sceneRoot = scene.GetRootNode()

        pelvisGlobal = pelvisNode.EvaluateGlobalTransform()

        # Create skeleton attribute
        rootSkel = fbx.FbxSkeleton.Create(scene, "root")
        rootSkel.SetSkeletonType(fbx.FbxSkeleton.EType.eRoot)

        # Create root node
        rootNode = fbx.FbxNode.Create(scene, "root")
        rootNode.SetNodeAttribute(rootSkel)

        # Match pelvis global transform
        t = pelvisGlobal.GetT()
        r = pelvisGlobal.GetR()
        s = pelvisGlobal.GetS()

        rootNode.LclTranslation.Set(fbx.FbxDouble3(t[0], t[1], t[2]))
        rootNode.LclRotation.Set(fbx.FbxDouble3(r[0], r[1], r[2]))
        rootNode.LclScaling.Set(fbx.FbxDouble3(s[0], s[1], s[2]))

        # Insert root above pelvis
        sceneRoot.AddChild(rootNode)
        sceneRoot.RemoveChild(pelvisNode)
        rootNode.AddChild(pelvisNode)

        return rootNode
    

    #Update Bind Pose
    def UpdateBindPose(self):
        scene = self.Scene
        poseCount = scene.GetPoseCount()

        for i in range(poseCount):
            pose = scene.GetPose(i)

            if pose.IsBindPose():
                scene.RemovePose(i)
                break

        bindPose = fbx.FbxPose.Create(scene, "BindPose")
        bindPose.SetIsBindPose(True)

        def AddToPose(node: fbx.FbxNode):
            globalAMatrix = node.EvaluateGlobalTransform()
            globalMatrix = fbx.FbxMatrix(globalAMatrix)

            bindPose.Add(node, globalMatrix)
            
            for i in range(node.GetChildCount()):
                AddToPose(node.GetChild(i))

        AddToPose(scene.GetRootNode())
        scene.AddPose(bindPose)
    
    @pyqtSlot()
    def EnsureRootBone(self):
        skelRoot = self.FindCharacterSkeleton()

        if not skelRoot:
            print("No skeleton found in scene.")
            return
        

        if skelRoot.GetName().lower() in ("root", "armature"):
            print("Skeleton already has a root bone.")
            return
        
        pelvisNode = skelRoot
        print(f"Pelvis bone detected as '{pelvisNode.GetName()}'")

        print ("Creating root bone")
        rootNode = self.CreateRootBone(pelvisNode)
        
        self.UpdateBindPose()
