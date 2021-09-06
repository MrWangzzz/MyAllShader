//===========================
//作者：MerLin 
//时间：2021-06-21-10-53
//作用：图片由上至下渐变
//===========================
Shader "MerLinCreat/GradualImg"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
		[HideInInspector]
		_StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector]
		_Stencil("Stencil ID", Float) = 0
		[HideInInspector]
		_StencilOp("Stencil Operation", Float) = 0
		[HideInInspector]
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector]
		_StencilReadMask("Stencil Read Mask", Float) = 255
		[HideInInspector]
		_ColorMask("Color Mask", Float) = 15
    }
    SubShader
    {
       Tags {
				 "Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}
			Stencil
			{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
			}
			LOD 100

            Cull Off
			Lighting Off
			ZWrite Off
			ZTest[unity_GUIZTestMode]
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask[_ColorMask]

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
                float3 mColor:COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 mColor:COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.mColor = v.mColor;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                i.mColor.rgb= i.mColor.rgb* i.uv.y*2;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(i.mColor,1);
            }
            ENDCG
        }
    }
}
