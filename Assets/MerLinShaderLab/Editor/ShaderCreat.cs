
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.ProjectWindowCallback;
using UnityEngine;

public class ShaderCreat 
{
    public static void CreatShaderLab(int type)
    {

        string model = type == 1 ? "ShaderLabModel.shader.txt" : "ShaderLabUI.shader.txt";

        ProjectWindowUtil.StartNameEditingIfProjectWindowExists(0,
      ScriptableObject.CreateInstance<MyDoCreateScriptAsset>(),
      GetSelectedPathOrFallback() + "/New Shader.shader",
      null,
     Application.dataPath + "/MerLinShaderLab/Editor/ScriptTemplates/"+ model);
    }

    public static string GetSelectedPathOrFallback()
    {
        string path = "Assets";


        foreach (UnityEngine.Object obj in Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.Assets))
        {
            path = AssetDatabase.GetAssetPath(obj);
            if (!string.IsNullOrEmpty(path) && File.Exists(path))
            {
                path = Path.GetDirectoryName(path);
                break;
            }
        }
        return path;
    }
}
class MyDoCreateScriptAsset : EndNameEditAction
{
    public override void Action(int instanceId, string pathName, string resourceFile)
    {
        UnityEngine.Object o = CreateScriptAssetFromTemplate(pathName, resourceFile);
        ProjectWindowUtil.ShowCreatedAsset(o);
    }

    internal static UnityEngine.Object CreateScriptAssetFromTemplate(string pathName, string resourceFile)
    {
        //string fullPath = Application.dataPath + "/MerLinShaderLab/ShaderLab/"+ pathName;
        string fullPath = Path.GetFullPath(pathName);
        StreamReader streamReader = new StreamReader(resourceFile);
        string text = streamReader.ReadToEnd();
        streamReader.Close();
        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(pathName);
        //TODO:脚本内容处理
        text = Regex.Replace(text, "#NAME#", fileNameWithoutExtension);
        text = Regex.Replace(text, "#CREATTIME#", System.DateTime.Now.ToString("yyyy-MM-dd-HH-mm"));
        bool encoderShouldEmitUTF8Identifier = true;
        bool throwOnInvalidBytes = false;
        UTF8Encoding encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier, throwOnInvalidBytes);
        bool append = false;
        StreamWriter streamWriter = new StreamWriter(fullPath, append, encoding);
        streamWriter.Write(text);
        streamWriter.Close();
        AssetDatabase.ImportAsset(pathName);
        BuildMaterial.CreatMateral(fileNameWithoutExtension);
        return AssetDatabase.LoadAssetAtPath(pathName, typeof(UnityEngine.Object));
    }
}
