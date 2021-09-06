//===========================
//作者：MerLin 
//时间：2021-08-03-14-15
//作用：镂空
//===========================
Shader "MerLinCreat/HollowedOut2"
{
    Properties
    {
        _Edge("边缘光",color) = (1,1,1,1)
        _EdgeSize("边缘光大小",float) = 0.01
        _Pos("位置",Vector)=(0,0,0,0)
        _RADIUSBUCE("圆半径",Float)=1
      [HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		[HideInInspector]
		_StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector]
		_Stencil("Stencil ID", Float) = 0
		[HideInInspector]
		_StencilOp("Stencil Operation", Float) = 0
		[HideInInspector]
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector]
		_StencilReadMask("Stencil Read Mask", Float) = 255
		[HideInInspector]
		_ColorMask("Color Mask", Float) = 15
    }
    SubShader
    {
       Tags {
             "Queue" = "Transparent"
                    "IgnoreProjector" = "True"
                    "RenderType" = "Transparent"
                    "PreviewType" = "Plane"
                    "CanUseSpriteAtlas" = "True"
			}
			Stencil
			{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
			}
			LOD 100

            Cull Off
			Lighting Off
			ZWrite Off
			ZTest[unity_GUIZTestMode]
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask[_ColorMask]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 mcolor:COLOR;
              
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                fixed4 vertex : SV_POSITION;
                fixed4 mcolor:COLOR;
                fixed3 worldPos:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed2 _Pos;
            float _RADIUSBUCE;
            float4 _Edge;
            float _EdgeSize;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.mcolor = v.mcolor;
                o.worldPos= mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 dis = distance(i.worldPos,_Pos);
              

                i.mcolor.a = dis.x > _RADIUSBUCE ? i.mcolor.a : 0;
                //i.mcolor = dis.x > _RADIUSBUCE && dis.x < _RADIUSBUCE + _EdgeSize ? smoothstep(_Edge, _Edge/2, i.uv.x) : i.mcolor;
              
                return i.mcolor;
            }
            ENDCG
        }
    }
}
