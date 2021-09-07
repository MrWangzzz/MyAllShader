//===========================
//作者：MerLin 
//时间：2021-09-07-16-35
//作用：
//===========================
Shader "MerLinCreat/RampTexture"
{
    Properties
    {
        _Color("Color Tint",Color)=(1,1,1,1)
        _RampTex("Ramp Tex",2D) = "white"{}
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
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

            #include"Lighting.cginc"

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
                float3 worldNormal:TEXCOORD1;
                float3 worldPos:TEXCOORD2;
            };

            sampler2D _RampTex;
            float4 _RampTex_ST;
            float4 _Color;
            float4 _Specular;
            float _Gloss;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _RampTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLighrDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;


                fixed halfLabmbert = 0.5*dot(worldNormal, worldLighrDir) + 0.5;

                fixed3 diffuseColor = tex2D(_RampTex, fixed2(halfLabmbert, halfLabmbert)).rgb* _Color;


                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                fixed3 halfDir = normalize(viewDir + worldLighrDir);
                fixed3 specular = _Specular * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(ambient+ specular+ diffuseColor,1);
            }
            ENDCG
        }
    }
}
