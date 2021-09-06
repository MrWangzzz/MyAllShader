//===========================
//作者：MerLin 
//时间：2021-09-01-14-13
//作用：瓶中液体
//===========================
Shader "MerLinCreat/WaterInBottle"
{
	Properties
	{
		
		_BottleScale("瓶子大小",Range(0,0.3))=0.2
		_BottleColor("瓶子颜色",Color)=(1,1,1,1)
		_BottleSmoothness("瓶子光滑度",Range(0,1))=0.5
	}

	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"RenderType" = "Transparent"
			"LightMode"="ForwardBase"
		}
		LOD 100
		Pass
		{
			Tags
		{
			"RenderType"="Opaque"
			"Queue"="Geomtry"
		}
			Cull Off
			AlphaToMask On
			Zwrite on
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
				float3 normal:NORMAL;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 normal :TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				i.normal = normalize(i.normal);
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				// sample the texture
				float3 diffuse = max(0, dot(i.normal, lightDir));

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);

				return fixed4(1,1,1,1);
				}
			ENDCG
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
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
				float3 normal:NORMAL;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 normal:TEXCOORD1;
				float3 WorldPos:TEXCOORD2;
			};
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _BottleScale;
			float4 _BottleColor;
			float _BottleSmoothness;
			v2f vert(appdata v)
			{
				v2f o;
				v.vertex.xyz += v.normal.xyz* _BottleScale;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.normal = v.normal;
				o.WorldPos = mul(unity_ObjectToWorld, v.vertex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			fixed4 frag(v2f i, fixed facing : VFace) : SV_Target
			{
				i.normal = normalize(i.normal);
				
				// sample the texture
				fixed4 col = _BottleColor;
				fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				fixed3 diffuse = max(0, dot(lightDir, i.normal));
				
				fixed3 viewDir = normalize( _WorldSpaceCameraPos- i.WorldPos );
				//fixed3 reflectionDir = reflect(-lightDir, i.normal);
				fixed3 halfwayDir = normalize(lightDir + viewDir);
				fixed3 ref = max(0, dot(halfwayDir, viewDir));
				ref = dot(ref, _BottleSmoothness);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				col.xyz = col.xyz * diffuse* ref;
			return col;
			}
			ENDCG
		}
	}
}