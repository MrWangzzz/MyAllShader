
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public static class  EditorWindowEx 
{
    public static void CenterOnMainWin(this EditorWindow editor) 
    {
        var main = AppExtension.GetEditorMainWindowPos();
        var pos = editor.position;
        float w = (main.width - pos.width) * 0.5f;
        float h = (main.height - pos.height) * 0.5f;
        pos.x = main.x + w;
        pos.y = main.y + h;
        editor.position = pos;

    }
}
