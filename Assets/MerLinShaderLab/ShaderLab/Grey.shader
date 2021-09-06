//===========================
//作者：MerLin 
//时间：2021-04-16-17-29
//作用：图片置灰
//===========================
Shader "MerLinCreat/Grey"
{
	Properties
	{
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
					fixed4 vertex : POSITION;
					fixed2 uv : TEXCOORD0;
					fixed4 mColor : COLOR;
				};

				struct v2f
				{
					fixed2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					fixed4 vertex : SV_POSITION;
					fixed4 mColors : COLOR;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					UNITY_TRANSFER_FOG(o,o.vertex);
					o.mColors = v.mColor;
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{



					// sample the texture
					fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				if (i.mColors.r < 0.001f)
				{
					fixed grey = dot(col, fixed3(0.299, 0.587, 0.114));
					col.rgb = float3(grey, grey, grey);
				}
				else
				{
					col = tex2D(_MainTex, i.uv);
				}

				return col;
			}
			ENDCG
		}
		}
}
