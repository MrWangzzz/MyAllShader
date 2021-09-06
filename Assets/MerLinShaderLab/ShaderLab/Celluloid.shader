//===========================
//
//作者:      MerLin     
//
//===========================
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "MerLinCreat/Celluloid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Smoothness("表面光滑度",Range(0,1)) = 0.5
        _SpecularTint("反射率",Color) = (0.5,0.5,0.5)

        _HColor("高光",Color) = (1,1,1,1)
        _SColor("阴影",Color) = (1,1,1,1)
        _RampThreshold("色阶阈值",Range(0,1)) = 0.5
        _RampSmooth("色阶平滑度",Range(0,1)) = 0.5
        _OutlineColor("描边颜色",Color) = (1,1,1,1)
        _OutlineScale("描边大小",Range(0,0.05)) = 0
         _Test("高光位置",Range(0,1)) = 0
        
        _SpecSmooth("镜面高光平滑度",Range(0,1))=0.5
        _Shininess("镜面反射度",Range(0,100))=0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque""LightMode"="ForwardBase" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include"UnityStandardBRDF.cginc"
            struct appdata
            {
                fixed4 vertex : POSITION;
                fixed3 normal:NORMAL;
                fixed2 uv : TEXCOORD0;
            };

            struct v2f
            {
                fixed2 uv : TEXCOORD0;
                fixed3 normal:TEXCOORD1;
                fixed3 worldPos : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                fixed4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
          
            fixed  _Smoothness;
            fixed4 _SpecularTint;
            fixed _RampThreshold;
            fixed _RampSmooth;
            fixed _Test;
            fixed4 _HColor;
            fixed4 _SColor;
            fixed _Shininess;

       

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                i.normal = normalize(i.normal);
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 lightDir = _WorldSpaceLightPos0.xyz;
                fixed3 lightColor = _LightColor0.rgb;
                fixed3 viewDir = normalize(lightDir + i.worldPos);
                lightDir.y -= _Test;

                fixed ndl = DotClamped(lightDir, i.normal);
                fixed ndh = DotClamped(viewDir, i.normal);
      
                fixed spec = pow(ndh, _Shininess * 128.0) * col.a;

                _SColor = lerp(_HColor, _SColor, _SColor.a);

                fixed3 ramp = smoothstep(_RampThreshold- _RampSmooth *0.5, _RampThreshold + _RampSmooth * 0.5, ndl);
                spec= smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, spec);

                fixed3 rampColor = lerp(_SColor.rgb, _HColor.rgb, ramp);
                fixed3 specular = _SpecColor.rgb * lightColor * spec;


                fixed3 diffuse = col*lightColor * rampColor;

                ramp *= 1;

   

              
                UNITY_APPLY_FOG(i.fogCoord, col);

                return fixed4(diffuse,1);
            }
            ENDCG
        }


        Tags { "RenderType" = "Opaque""LightMode" = "ForwardBase" }
        LOD 100
          Pass
            {
                Cull Front
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"


                fixed4 _OutlineColor;
                fixed _OutlineScale;
                struct appdata 
                {
                fixed4 vertex : POSITION;
                };
                struct v2f 
                {
                    fixed4 vertex : SV_POSITION;
                };
               
                v2f vert(appdata v) 
                {
                    v2f o;
                    v.vertex *= 1 + _OutlineScale;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) :SV_Target
                {

                    return _OutlineColor;
                }


                ENDCG
            }
    }
}
