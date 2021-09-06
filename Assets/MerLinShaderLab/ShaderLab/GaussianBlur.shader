//===========================
//作者：MerLin 
//时间：2021-05-25-10-20
//作用：图片模糊
//===========================
Shader "MerLinCreat/Gaussian"
{
	Properties
	{
			
		_TextureSize("_TextureSize",Float) = 256
		_BlurSize("_BlurRadius",Range(1,15)) = 1
		[HideIninspector]
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
					fixed4 vertex : POSITION;
					fixed2 uv : TEXCOORD0;
					fixed4 color:COLOR;
				};

				struct v2f
				{
					fixed2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					fixed4 vertex : SV_POSITION;
					float4 color:COLOR;
					half4 uvoff[3]:TEXCOORD1;
				};
				sampler2D _MainTex;
				fixed4 _MainTex_ST;
				fixed _TextureSize;
				fixed _BlurRadius;
				uniform half4 _MainTex_TexelSize;
				uniform float _BlurSize;
				static const half weight[4] = { 0.0205, 0.0855, 0.232, 0.324 };
				static const half4 coordOffset = half4(1.0h, 1.0h, -1.0h, -1.0h);



				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.color = v.color;

					half2 offs = _MainTex_TexelSize.xy * half2(1, 1) * _BlurSize;
					o.uvoff[0] = o.uv.xyxy + offs.xyxy * coordOffset * 3;
					o.uvoff[1] = o.uv.xyxy + offs.xyxy * coordOffset * 2;
					o.uvoff[2] = o.uv.xyxy + offs.xyxy * coordOffset;

					UNITY_TRANSFER_FOG(o,o.vertex);

					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					
				fixed4 c = tex2D(_MainTex, i.uv) * weight[3] ;
				
				for (int idx = 0; idx < 3; idx++)
				{
					c += tex2D(_MainTex, i.uvoff[idx].xy) * weight[idx];
					c += tex2D(_MainTex, i.uvoff[idx].zw) * weight[idx];
					
				}
		
				return c;
				}
				ENDCG
			}
		}
}
