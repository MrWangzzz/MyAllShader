//===========================
//作者：MerLin 
//时间：2021-04-16-17-30
//作用：模型描边
//===========================
Shader "MerLinCreat/ObjectStroke"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Scale("描边延伸宽度",Range(0,0.05)) = 0
        _OutLineColor("描边颜色",Color) = (0,0,0,1)
    }
        SubShader
        {
            Tags {
                    "RenderType" = "Opaque"
        }
            LOD 100
            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
            //WriteMask[_StencilWriteMask]
        }


        Pass
        {
            Cull Back
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
            fixed4 col = tex2D(_MainTex, i.uv);
            UNITY_APPLY_FOG(i.fogCoord, col);
            return col;
        }
        ENDCG
        }
        Tags { "RenderType" = "Opaque""LightMode" = "ForwardBase" }
        LOD 100
        Pass
        {
            Name"ObjectStroke"
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "ObjectStroke.cginc"
       ENDCG
        }
        }
}
