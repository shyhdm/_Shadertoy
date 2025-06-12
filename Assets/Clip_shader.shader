Shader "Unlit/Circle"
{
    Properties
    {
        _Color("Color", Color) = (0, 1, 0, 1)
        _Radius("Radius", float) = 0.2
        _Center("Center", Vector) = (0.5, 0.5, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float _Radius;
            float4 _Color;
            float2 _Center;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.vertex.xy * 0.5 + 0.5; 
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 center = _Center.xy;
                float radius = _Radius;
                float dist = distance(uv, center); 

                clip(radius - dist);
                return _Color;
            }
            ENDCG
        }
    }
}
