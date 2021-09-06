//===========================
//作者：MerLin 
//时间：2021-04-16-17-32
//作用：扫光
//===========================
Shader "MerLinCreat/SweepLight"
{
	Properties
	{
	   [HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Saoguang("扫光图片",2D) = "white"{}
		_FLowLightColor("扫光颜色",Color) = (0,0,0,1)
		_Power("扫光大小",float) = 1
		_SpeedX("X轴移动速度",float) = 0.8

	}
		SubShader
		{
			Tags {
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
		}
			LOD 100

			Pass
			{

				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
			// make fog work
			 #pragma multi_compile _fog _ISTWINKLE_ON

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
				float2 uv2 : TEXCOORD1;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				fixed4 mColor : COLOR;
			};
			sampler2D _Saoguang;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Saoguang_ST;
			float _SpeedX;
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.mColor = v.mColor;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				half2 uv = i.uv;
				uv.x /= 2;
				uv.x += 0.5f;


				// uv.x+= _Time.y* _SpeedX;
				if ((i.mColor.r<1)) 
				{
				 uv.x += _Time.y * _SpeedX;
				}
				else 
				{
					_Time.y = 0;
				}
		
				 fixed4 col = tex2D(_MainTex, i.uv);
				 fixed4 cadd = tex2D(_Saoguang, uv);
				 UNITY_APPLY_FOG(i.fogCoord, col);
				 col.rgb = col.rgb * (1 - cadd.a) + cadd.rgb * cadd.a;
				 col.a *= i.mColor.a;;
				 return  col;
			 }
			 ENDCG
		 }
		}
}