//===========================
//作者：MerLin 
//时间：2021-09-06-18-17
//作用：Blinn_Phong 光照模型
//===========================
Shader "MerLinCreat/Blinn_PhongLightMode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
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
                float4 tangent:TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal:TEXCOORD1;
                float3 worldPos:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
     

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 albedo = tex2D(_MainTex,i.uv);
                i.normal = normalize(mul(unity_ObjectToWorld,i.normal));
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                float3 diffuse = (saturate(dot(lightDir, i.normal))*0.5+0.5)* albedo;
                //视线方向
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                //视线方向与
                float3 halfDir = normalize(lightDir + viewDir);
                float3 hf = saturate(dot(halfDir, i.normal));
                hf = pow(hf, 20);
                return float4(diffuse+ hf,1);
            }
            ENDCG
        }
    }
}
