
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class ShaderEditor : EditorWindow
{



    [MenuItem("Shader/字典")]
    public static void Dictionaries()
    {
        ShaderDictionaries sd = GetWindowWithRect<ShaderDictionaries>(new Rect(0, 0, 500, 700), false, "字典");

        sd.Show();
    }
    [MenuItem("Shader/Shader列表")]
    public static void CurrentShadrlist()
    {
        CurrentShaderlist csl = GetWindow<CurrentShaderlist>("当前已有shader列表及功能介绍");
        csl.Show();
    }
    [MenuItem("Shader/ShaderFurnace")]
    public static void ShaderFurnace()
    {
        ShaderFurnaceController shaderFurnace = GetWindowWithRect<ShaderFurnaceController>(new Rect(0, 0, 1080, 600), false, "ShaderFurnace");

        shaderFurnace.Show();
    }

    [MenuItem("Assets/Create/MerLinShaderModle", false, 80)]
    public static void CreatShader()
    {
        ShaderCreat.CreatShaderLab(1);
    }
    [MenuItem("Assets/Create/MerLinShaderUI", false, 80)]
    public static void CreatUiShader()
    {
          ShaderCreat.CreatShaderLab(0);
       
    }
    [MenuItem("Assets/ModifySave", false, 20)]
    public static void ModifyMouseSave() 
    {
       GetMouseObj.Save();
    }
}
