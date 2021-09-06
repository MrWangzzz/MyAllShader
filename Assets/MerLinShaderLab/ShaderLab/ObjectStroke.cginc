#include "Lighting.cginc"
#include "UnityCG.cginc"
struct appdata
{

    fixed4 vertex : POSITION;
    fixed4 uv : TEXCOORD0;
    fixed3 normal : NORMAL;
    fixed4 tangent : TANGENT;
};

struct v2f
{
    fixed4 uv : TEXCOORD0;
    UNITY_FOG_COORDS(1)
        fixed4 vertex : SV_POSITION;
    fixed3 LightDir : TEXCOORD1;
    fixed3 ViewDir : TEXCOORD2;
};

fixed _Scale;
sampler2D _MainTex;
fixed4 _OutLineColor;
fixed4 _MainTex_ST;
v2f vert(appdata v)
{
    v2f o;
    v.vertex.xyz *= (_Scale+1);
    o.vertex = UnityObjectToClipPos(v.vertex);
    TANGENT_SPACE_ROTATION;
    o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
    
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    return _OutLineColor;
}
