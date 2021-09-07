//===========================
//作者：MerLin 
//时间：2021-09-07-00-30
//作用：
//===========================
Shader "MerLinCreat/NormalMap"
{
    Properties
    {
        _Color("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap("NormalMap",2D) = "bump"{}
        _BumpScale("凹凸程度",Float)=1.0
         _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 tangent:TANGENT;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 lithtDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _BumpScale;
            float4 _Specular;
            float _Gloss;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _NormalMap);
                //首先叉乘计算副法线，然后通过w的分量取正确的方向
                float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
                float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
                o.lithtDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 tangentLightDir = normalize(i.lithtDir);
                fixed3 tangenViewDir = normalize(i.viewDir);
                fixed3 tangeNormal;

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                fixed4 packedNormal = tex2D(_NormalMap, i.uv.zw);
                tangeNormal = UnpackNormal(packedNormal);
                tangeNormal.xy *= _BumpScale;
                tangeNormal.z = sqrt(1 - saturate(dot(tangeNormal.xy, tangeNormal.xy)));

                fixed3 diffuse = _LightColor0.rgb* col * saturate(dot (tangeNormal, tangentLightDir));
                fixed3 halfDir = normalize(tangentLightDir + tangenViewDir);
              
                fixed3 specula = _LightColor0.rgb * _Specular.rgb*pow(saturate(dot(tangeNormal, halfDir)), _Gloss);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(diffuse+ specula,1);
            }
            ENDCG
        }
    }
}
