//===========================
//作者：MerLin 
//时间：2021-04-16-17-31
//作用：闪烁
//===========================
Shader "MerLinCreat/twinkle"
{
    Properties
    {
        [HideInInspector]
        _MainTex("Texture", 2D) = "white" {}
        [Toggle]_isTwinkle("是否闪烁",float) = 1
        _Brightness("亮度",Range(0,10)) = 5
        _TwinkleFrequency("闪烁频率",Range(0,10)) = 5
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque""Queue" = "Transparent" }
            LOD 100

            Pass
            {
                Blend SrcAlpha OneMinusSrcAlpha
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
            // make fog work
            #pragma multi_compile _fog 

            #include "UnityCG.cginc"
            struct appdata
            {
                fixed4 vertex : POSITION;
                fixed2 uv : TEXCOORD0;
            };

            struct v2f
            {
                fixed2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
               fixed4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed _Brightness;
            fixed _TwinkleFrequency;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 endcol;
                fixed4 twin = col;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                if (col.a == 0)
                {
                    discard;
                }
            #ifdef _ISTWINKLE_ON
                col += (abs(sin(_Time.y * _TwinkleFrequency) / _Brightness));
            #else
                _Time.y = 0;
            #endif

                return col;
            }
            ENDCG
        }

        }
}