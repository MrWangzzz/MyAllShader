
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class ShaderDictionaries : EditorWindow
{
    //字典存储的位置
    private string path = "Assets/MerLinEditor/TextFile/mDictionaries.csv";

    private string[] mDictionarie;
    private Vector2 scrollpos;
    private int select;
    private GUIStyle sty = new GUIStyle();
    private List<bool> isDictionariesInout = new List<bool>();
    private string Inputsearch;
    private List<string> mDictionars = new List<string>();
    private bool isAddDictionaries;


    private string isSemanticName;
    private string istype;
    private string explain;

    private void Awake()
    {
        mDictionarie = File.ReadAllLines(path);
        for (int i = 0; i < mDictionarie.Length; i++)
        {
            isDictionariesInout.Add(false);
        }
        for (int i = 0; i < mDictionarie.Length; i++)
        {
            var mdc = mDictionarie[i].Split(',');
            mDictionars.Add("数据类型:" + mdc[1] + "。解释:" + mdc[2]);
        }
    }

    private void OnGUI()
    {
        scrollpos = GUILayout.BeginScrollView(scrollpos, GUILayout.Width(500), GUILayout.Height(400));
        GUILayout.Space(10);
        for (int i = 1; i < mDictionarie.Length; i++)
        {
            if (GUILayout.Button(mDictionarie[i].Split(',')[0]))
            {
                isDictionariesInout[i] = !isDictionariesInout[i];
            }
            if (isDictionariesInout[i])
            {
                var mdc = mDictionarie[i].Split(',');
                mDictionars[i] = GUILayout.TextArea(mDictionars[i]);
            }
            GUILayout.Space(10);
        }
        GUILayout.EndScrollView();

        GUILayout.Space(20);
        GUILayout.Label("输入搜索内容");
        Inputsearch = GUILayout.TextField(Inputsearch);
        if (GUILayout.Button("搜索"))
        {
            for (int i = 1; i < mDictionarie.Length; i++)
            {
                //scrollpos += new Vector2(0,1);
                if (mDictionarie[i].Split(',')[0].StartsWith(Inputsearch))
                {
                    isDictionariesInout[i] = true;
                    scrollpos = new Vector2(0, 20 * (i - 1));
                    break;
                }
                else
                {

                    isDictionariesInout[i] = false;
                }
            }
        }
        if (GUILayout.Button("添加"))
        {
            isAddDictionaries = !isAddDictionaries;
        }
        if (isAddDictionaries)
        {
            GUILayout.BeginVertical();
            GUILayout.Label("语意");
            isSemanticName = GUILayout.TextArea(isSemanticName);
            GUILayout.Label("类型");
            istype = GUILayout.TextArea(istype);
            GUILayout.Label("解释");
            explain = GUILayout.TextArea(explain);
        }

        GUILayout.Space(100);
        if (GUILayout.Button("修改"))
        {

        }
    }
}
