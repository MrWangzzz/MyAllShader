
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class BuildMaterial : UnityEditor.AssetModificationProcessor
{
    private static string Materialspath = "Assets/MerLinShaderLab/Material/";
    public static void CreatMateral(string name) 
    {
        Material mater = new Material(Shader.Find(string.Format("MerLinCreat/{0}", name)));
        AssetDatabase.CreateAsset(mater, Materialspath+ name + ".mat");

    }

}
