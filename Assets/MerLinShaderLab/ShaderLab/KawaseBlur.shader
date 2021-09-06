//===========================
//作者：MerLin 
//时间：2021-05-25-14-20
//作用：图片模糊，性能比高斯好的多
//===========================
Shader "MerLinCreat/KawaseBlur"
{
    Properties
    {
        [HideInInspector]
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Blur("Blur", Range(0.0, 100)) = 1.0
        _MainTex_TexelSize("MainTex_TexelSize",Range(0.01,0.2))=0
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
            sampler2D _MainTex;
            float4 _MainTex_ST;
             float _MainTex_TexelSize;
             half _Blur;
             float4 _ScreenResolution;
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
            half4 KawaseBlur(sampler2D tex, float2 uv, float texelSize, half pixelOffset)
            {
                half4 o = 0;
                o += tex2D(tex, uv + float2(pixelOffset + 0.5, pixelOffset + 0.5) * texelSize);
                o += tex2D(tex, uv + float2(-pixelOffset - 0.5, pixelOffset + 0.5) * texelSize);
                o += tex2D(tex, uv + float2(-pixelOffset - 0.5, -pixelOffset - 0.5) * texelSize);
                o += tex2D(tex, uv + float2(pixelOffset + 0.5, -pixelOffset - 0.5) * texelSize);
                return o * 0.25;
            }
 

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
    
                UNITY_APPLY_FOG(i.fogCoord, col);

            return KawaseBlur(_MainTex, i.uv.xy, _MainTex_TexelSize, _Blur);
            }
            ENDCG
        }
    }
}
