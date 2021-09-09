//===========================
//作者：MerLin 
//时间：2021-09-09-21-36
//作用：
//===========================
Shader "MerLinCreat/ForwardRendering"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss("Gloss",Float)=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile_fwdbase
            #include "Lighting.cginc"

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                fixed3 LightDir = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 halfDir = normalize(viewDir + LightDir);


                fixed3 diffuse = _LightColor0.rgb * max(0, dot(LightDir, i.worldNormal));

                fixed3 specular = _LightColor0.rgb * pow(max(0, dot(halfDir, i.worldNormal)), _Gloss);
                fixed atten = 1.0f;
                return fixed4(ambient+ (diffuse+ specular)* atten,1);
            }
            ENDCG
        }
            Pass
            {
             Tags { "LightMode" = "ForwardAdd" }
                Blend One One
                   CGPROGRAM
                    #pragma vertex vert
                 #pragma fragment frag
                // make fog work
      
                #pragma multi_compile_fwdadd
                      #include "Lighting.cginc"
                    #include "AutoLight.cginc"
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _Gloss;
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
                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                    o.worldNormal = UnityObjectToWorldNormal(v.normal);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                fixed3 worldNormal = normalize(i.worldNormal);
                #ifdef USING_DIRECTIONAL_LIGHT
                fixed3 LightDir = normalize(_WorldSpaceLightPos0.xyz);
                #else
                fixed3 LightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                #endif
                fixed3 diffuse = _LightColor0.rgb * max(0, dot(LightDir, worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                fixed3 halfDir = normalize(viewDir + LightDir);
                fixed3 specular = _LightColor0.rgb * pow(max(0, dot(halfDir, worldNormal)), _Gloss);
           

        

          

                #ifdef USING_DIRECTIONAL_LIGHT
                                fixed atten = 1.0;
                #else
                #if defined (POINT)
                                float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
                                fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                #elif defined (SPOT)
                                float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
                                fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
                #else
                                fixed atten = 1.0;
                #endif
                #endif
       


             

           
            
                return fixed4((diffuse + specular) * atten,1);
                }
                ENDCG
            }
    }
}
