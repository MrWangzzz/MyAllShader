//===========================
//作者：MerLin 
//时间：2021-09-07-22-06
//作用：
//===========================
Shader "MerLinCreat/MaskTexture"
{
    Properties
    {
        _Color("Color",Color)=(1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap("Normal Map",2D) = "white"{}
        _BumpScale("Bump Scale",Float)=1.0
     
        _SpecularMask("Specular Mask",2D) = "white"{}
        _SpecularColor("Specular Color",Color)=(1,1,1,1)
        _SpecularScale("Specular Scale",Float)=1.0
               _Gloss("Gloss",Float) = 1.0
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

            #include "Lighting.cginc"
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
                float3 LightDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            sampler2D _SpecularMask;
            float4 _SpecularMask_ST;
            float _SpecularScale;
            float _Gloss;
            float4 _SpecularColor;
            float4 _Color;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw 同下等价;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                TANGENT_SPACE_ROTATION;
                o.LightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 tangentLight = normalize(i.LightDir);
                fixed3 tangentView = normalize(i.viewDir);
              
       

                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap,i.uv ));
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));



                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                fixed3 diffuse = _LightColor0.rgb* albedo * max(0, dot(tangentNormal, tangentLight)) * _Color.rgb;

                fixed3 halfDir = normalize(tangentLight + tangentView);
                fixed specularMask = tex2D(_SpecularMask, i.uv).r* _SpecularScale;

                fixed3 specular = _LightColor0.rgb *pow(max(0, dot(tangentNormal, halfDir)), _Gloss)* specularMask* _SpecularColor.rgb;

             
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(diffuse+ specular+ ambient,1);
            }
            ENDCG
        }
    }
}
