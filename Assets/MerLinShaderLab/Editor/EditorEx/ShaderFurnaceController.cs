
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;
using UnityEditor.ProjectWindowCallback;

public class ShaderFurnaceController : EditorWindow
{
    public GUIStyle subject = new GUIStyle();
    public GUIStyle button;
    private static Texture2D tex;
    private Vector2 scrollpos;
    private bool NewShaderShow;


    private int startW = 120;
    private int endW;

    private List<int> test = new List<int> { 112, 26, 3, 5, 1, 1 };
    private GUIStyle ScrollView = new GUIStyle();
    private GUIStyle ScrollView2 = new GUIStyle();



    GameObject mcagameObject;
    Editor gameObjectEditor;



    public void Awake()
    {
        SetTopLab();
        SetBg();
        CreateCamere();
    }
    public void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, maxSize.x, maxSize.y), tex, ScaleMode.StretchToFill);
        GUILayout.Space(20);
        GUILayout.Label("Shader Furnace", subject);

        GUI.backgroundColor = new Color(0.3215686f, 0.3215686f, 0.3215686f, 1);
        if (!NewShaderShow)
        {
            NewShader();
            LoadShader();
        }
        else
        {
            SelectShaderModel();

            if (GUI.Button(new Rect(515, 500, 50, 50), "Back"))
            {
                NewShaderShow = false;
            }
        }
        GUILayout.Space(300);
        GUILayout.Label("Shader名字");

        //mcagameObject = (GameObject)EditorGUILayout.ObjectField(mcagameObject, typeof(GameObject), true);

        //GUIStyle bgColor = new GUIStyle();
        //bgColor.normal.background = EditorGUIUtility.whiteTexture;

        //if (mcagameObject != null)
        //{

        //    if (gameObjectEditor == null)
        //        gameObjectEditor = Editor.CreateEditor(mcagameObject);

        //    gameObjectEditor.OnInteractivePreviewGUI(GUILayoutUtility.GetRect(256, 256), bgColor);
        //}
    }

    public void CreateCamere()
    {
        mcagameObject = new GameObject("myCamera");
        Camera cam = mcagameObject.AddComponent<Camera>();
        cam.transform.localPosition = Vector3.zero;
        cam.transform.localScale = Vector3.one * 0.002777778f;

        cam.clearFlags = CameraClearFlags.Depth;

        cam.orthographic = true;        //投射方式：orthographic正交//
        cam.orthographicSize = 1;       //投射区域大小//
        cam.nearClipPlane = -2.7f;      //前距离//
        cam.farClipPlane = 2.92f;       //后距离//
        cam.rect = new Rect(0, 0, 1f, 1f);
    }

    private void SelectShaderModel()
    {


        for (int i = 0; i < test.Count; i++)
        {
            if (GUI.Button(new Rect(startW + i * 150, 300, 100, 100), i.ToString()))
            {
                Debug.LogError("？？？" + i);
            };
        }

    }
    private int GetWith<T>(List<T> ts)
    {
        int withd = 0;
        withd = ts.Count * 150;


        return withd;
    }


    private void NewShader()
    {
        if (GUI.Button(new Rect(150, 80, 380, 50), "New Shader"))
        {
           // NewShaderShow = true;
        }
    }
    

    private void LoadShader()
    {
        if (GUI.Button(new Rect(550, 80, 380, 50), "Load Shader"))
        {

        }
    }



    public void SetBg()
    {
        tex = new Texture2D(1, 1, TextureFormat.RGBA32, false);
        tex.SetPixel(0, 0, new Color(0.2196079f, 0.2196079f, 0.2196079f));
        tex.Apply();
    }
    public void SetTopLab()
    {
        subject.fontSize = 30;
        subject.alignment = TextAnchor.MiddleCenter;
        subject.normal.textColor = new Color(1, 1, 1, 1);
        subject.fontStyle = FontStyle.Bold;
    }

    private void SetScrolview<T>(List<T> test)
    {
        if (test.Count / 2 == 0)
        {
            startW = 1080 / 2 - (test.Count - 1) * 125;
            endW = 1080 / 2 + (test.Count - 1) * 125;

            if (startW < 0)
            {
                startW = 120;
                endW = 860;
            }
        }
        else
        {
            startW = 1080 / 2 - (test.Count - 1) * 100;
            endW = 1080 / 2 + (test.Count - 1) * 100;
            if (startW < 0)
            {
                startW = 120;
                endW = 860;
            }
        }
    }
    private void OnDestroy()
    {
        DestroyImmediate(mcagameObject);
    }
}
