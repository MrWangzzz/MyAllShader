
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugEX
{
    public static void Log(params object[] ob)
    {
        string log = "";
        for (int i = 0; i < ob.Length; i++)
        {
            log += (">>>" + ob[i]);
        }

        Debug.Log(log);
    }
    public static void LogError(params object[] ob)
    {

        string log = "";
        for (int i = 0; i < ob.Length; i++)
        {
            log += (">>>" + ob[i]);
        }
        Debug.LogError(log);
    }
}
