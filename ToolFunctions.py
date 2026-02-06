import sys
import os

#File dialog
import tkinter as tk
from tkinter.filedialog import askopenfilename

from difflib import SequenceMatcher
import re

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
        pelvisParent = pelvisNode.GetParent()

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
        pelvisParent.AddChild(rootNode)
        pelvisParent.RemoveChild(pelvisNode)
        rootNode.AddChild(pelvisNode)

        return rootNode
    

    #Update Bind Pose
    def UpdateBindPose(self):
        scene = self.Scene
        poseCount = scene.GetPoseCount()

        #Find the current bound pose and remove it
        for i in range(poseCount):
            pose = scene.GetPose(i)

            if pose.IsBindPose():
                scene.RemovePose(i)
                break

        #Create a new pose and bind it
        bindPose = fbx.FbxPose.Create(scene, "BindPose")
        bindPose.SetIsBindPose(True)


        #Add the bind pose to the scene
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
        self.CreateRootBone(pelvisNode)
        
        self.UpdateBindPose()

    def NormalizeName(self, name: str) -> str:
        name = name.lower()

        replacements = {
            "hip" : "pelvis",
            "spine": "spine_01",
            "spine1": "spine_02",
            "spine2": "spine_03",
            "spine3": "spine_04",
            "neck": "neck_01",
            "neck1": "neck_02",
            "head": "head",
            "leftshoulder": "clavicle_l",
            "leftarm": "upperarm_l",
            "leftforearm": "lowerarm_l",
            "lefthand": "hand_l",
            "lefthandmiddle1": "middle_metacarpal_l",
            "lefthandmiddle2": "middle_01_l",
            "lefthandmiddle3": "middle_02_l",
            "lefthandmiddle4": "middle_03_l",
            "lefthandindex": "index_metacarpal_l",
            "lefthandindex1": "index_01_l",
            "lefthandindex2": "index_02_l",
            "lefthandindex3": "index_03_l",
            "lefthandindex4": "index_04_l",
            "lefthandring": "ring_metacarpal_l",
            "lefthandring1": "ring_01_l",
            "lefthandring2": "ring_02_l",
            "lefthandring3": "ring_03_l",
            "lefthandring4": "ring_04_l",
            "lefthandpinky": "pinky_metacarpal_l",
            "lefthandpinky1": "pinky_01_l",
            "lefthandpinky2": "pinky_02_l",
            "lefthandpinky3": "pinky_03_l",
            "lefthandpinky4": "pinky_04_l",
            "leftthumb1": "thumb_01_l",
            "leftthumb2": "thumb_02_l",
            "leftthumb3": "thumb_03_l",
            "leftthumb4": "thumb_04_l",
            "rightshoulder": "clavicle_r",
            "rightarm": "upperarm_r",
            "rightforearm": "lowerarm_r",
            "righthand": "hand_r",
            "righthandmiddle1": "middle_metacarpal_r",
            "righthandmiddle2": "middle_01_r",
            "righthandmiddle3": "middle_02_r",
            "righthandmiddle4": "middle_03_r",
            "righthandindex": "index_metacarpal_r",
            "righthandindex1": "index_01_r",
            "righthandindex2": "index_02_r",
            "righthandindex3": "index_03_r",
            "righthandindex4": "index_04_r",
            "righthandring": "ring_metacarpal_r",
            "righthandring1": "ring_01_r",
            "righthandring2": "ring_02_r",
            "righthandring3": "ring_03_r",
            "righthandring4": "ring_04_r",
            "righthandpinky": "pinky_metacarpal_r",
            "righthandpinky1": "pinky_01_r",
            "righthandpinky2": "pinky_02_r",
            "righthandpinky3": "pinky_03_r",
            "righthandpinky4": "pinky_04_r",
            "rightthumb1": "thumb_01_r",
            "rightthumb2": "thumb_02_r",
            "rightthumb3": "thumb_03_r",
            "rightthumb4": "thumb_04_r",
            "rightupleg": "thigh_r",
            "rightleg": "calf_r",
            "rightfoot": "foot_r",
            "righttoebase": "ball_r",
            "leftupleg": "thigh_l",
            "leftleg": "calf_l",
            "leftfoot": "foot_l",
            "lefttoebase": "ball_l",
        }

        for key, value in replacements.items():
            name = re.sub(key, value, name)

        # remove non-alphanumeric
        name = "".join(c for c in name if c.isalnum())

        print(name)
        return name
    
    def Similarity(self, a, b) -> float:
        return SequenceMatcher(None, a, b).ratio()
    
    @pyqtSlot()
    def RenameSkeleton(self):
        ueBones = {"root", "pelvis", "spine_01", "spine_02", "spine_03", "spine_04", "spine_05", "clavicle_l", "upperarm_l", "lowerarm_l",
                    "hand_l", "index_metacarpal_l", "index_01_l", "index_02_l", "index_03_l", "middle_metacarpal_l", "middle_01_l", "middle_02_l", 
                    "middle_03_l", "pinky_metacarpal_l", "pinky_01_l", "pinky_02_l", "pinky_03_l", "ring_metacarpal_l", "ring_01_l", "ring_02_l", 
                    "ring_03_l", "thumb_01_l", "thumb_02_l", "thumb_03_l", "lowerarm_twist_01_l", "lowerarm_twist_02_l", "upperarm_twist_01_l", 
                    "upperarm_twist_02_l", "clavicle_r", "upperarm_r", "lowerarm_r", "hand_r", "index_metacarpal_r", "index_01_r", "index_02_r", 
                    "index_03_r", "middle_metacarpal_r", "middle_01_r", "middle_02_r", "middle_03_r", "pinky_metacarpal_r", "pinky_01_r", 
                    "pinky_02_r", "pinky_03_r", "ring_metacarpal_r", "ring_01_r", "ring_02_r", "ring_03_r", "thumb_01_r", "thumb_02_r", 
                    "thumb_03_r", "lowerarm_twist_01_r", "lowerarm_twist_02_r", "upperarm_twist_01_r", "upperarm_twist_02_r", "neck_01", 
                    "neck_02", "head", "thigh_l", "calf_l", "calf_twist_01_l", "calf_twist_02_l", "foot_l", "ball_l", "thigh_twist_01_l", 
                    "thigh_twist_02_l", "thigh_r", "calf_r", "calf_twist_01_r", "calf_twist_02_r", "foot_r", "ball_r", "thigh_twist_01_r", 
                    "thigh_twist_02_r"}

        normalizedUE = {self.NormalizeName(b): b for b in ueBones}
        sourceBone = self.FindCharacterSkeleton()

        def Recurse(node: fbx.FbxNode):

            for i in range(node.GetChildCount()):
                child = node.GetChild(i)

                srcName = child.GetName()
                normSrc = self.NormalizeName(srcName)

                bestMatch = None
                bestScore = 0.0

                for normTgt, tgtName in normalizedUE.items():
                    score = self.Similarity(normSrc, normTgt)

                    if score > bestScore:
                        bestScore = score
                        bestMatch = tgtName

                if bestScore >= 0.5:
                    print(f"Renaming {srcName} → {bestMatch} ({bestScore:.2f})")
                    child.SetName(bestMatch)

                Recurse(child)

        Recurse(sourceBone)

            

