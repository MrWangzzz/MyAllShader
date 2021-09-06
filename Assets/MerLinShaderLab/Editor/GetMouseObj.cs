
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class GetMouseObj : Editor
{

    public static void Save() 
    {
        Object[] o = Selection.objects;
        for (int i = 0; i < o.Length; i++) 
        {
            EditorUtility.SetDirty(o[i]);
            DebugEX.Log(o[i],"保存成功");
            
        }
    }
}
