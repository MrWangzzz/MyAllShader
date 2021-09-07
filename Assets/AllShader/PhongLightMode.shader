
//===========================
//作者：MerLin 
//时间：2021-09-04-21-11
//作用：逐像素 Phong光照模型
//===========================
Shader "MerLinCreat/PhongLightMode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
        LOD 100

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
                float3 normal:NORMAL;
                float3 tangent:TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color:COLOR0;
                float3 normal:TEXCOORD1;
                float3 worldPos:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                i.normal = normalize(mul(unity_ObjectToWorld,i.normal));
                float3 lightDir = normalize( _WorldSpaceLightPos0);
                float3 diffuse = saturate(dot(_WorldSpaceLightPos0, i.normal))*0.5+0.5;

                float3 refDir = normalize(reflect(-lightDir, i.normal));
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 ref = saturate(dot(viewDir, refDir));
                ref = pow(ref, 20);
                return float4(ref+ diffuse,1);
            }
            ENDCG
        }
    }
       FallBack "Diffuse"
}
