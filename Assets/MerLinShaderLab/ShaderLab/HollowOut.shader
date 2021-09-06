// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//===========================
//作者：MerLin 
//时间：2021-04-26-11-46
//作用：遮罩镂空
//===========================
Shader "MerLinCreat/HollowOut"
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
		_Pos("Position",Vector) = (0,0,0,0)
		_LengthAndWidth("LengthAndWidth",Vector) = (0,0,0,0)
		_RADIUSBUCE("_RADIUSBUCE",Range(50,100)) = 0.2
	}
		SubShader
		{
			Tags
			{
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
					fixed4 mColor : COLOR;
				};
				struct v2f
				{
					float2 uv : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					float4 vertex : SV_POSITION;
					fixed4 mColor : COLOR;
					fixed3 WorldPos : TEXCOORD1;

				};
				sampler2D _MainTex;
				float4 _MainTex_ST;
				float2 _Pos;
				float2 _LengthAndWidth;
				float _RADIUSBUCE;
				sampler2D _TestTex;
				float4 _TestTex_ST;

				v2f vert(appdata v)
				{
					v2f o;

					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					o.mColor = v.mColor;
					o.WorldPos = mul(unity_ObjectToWorld,v.vertex);
					UNITY_TRANSFER_FOG(o,o.vertex);
		
					return o;
				}
				fixed4 frag(v2f i) : SV_Target
				{
					float x = distance(i.WorldPos.x,_Pos.x);
					float y= distance(i.WorldPos.y, _Pos.y);
					_LengthAndWidth = mul(unity_ObjectToWorld, _LengthAndWidth)/2;
					i.mColor.a = x < _LengthAndWidth.x&& y < _LengthAndWidth.y ? 0 : i.mColor.a;
				return i.mColor;
			}
		ENDCG
		}
	}
}
