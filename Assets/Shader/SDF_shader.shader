Shader "Unlit/Circle"
{
    Properties
    {
        _Background("Background", Color) = (1, 1, 1, 1)
        factor_k ("blend_value",Range(0, 1.0)) = 0.5

        [Header(Circle)]
        circle_Color("Circle Color", Color) = (1, 0, 0, 1)
        circle_Position("circle_Position", Vector) = (0.5, 0.5, 0, 0)
        _Radius("circle_Radius", float) = 0.2

        [Header(Box)]
        box_Color("Box Color", Color) = (0, 1, 0, 1)
        box_Position("box_Position", Vector) = (0.5, 0.5, 0, 0)
        _Size("box_Size", Vector) = (0.3, 0.2, 0, 0)
    }
    //unity  π”√shadertoy
    
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _Background;
            float factor_k;

            float4 circle_Color;
            float2 circle_Position;
            float _Radius;
            float4 box_Color;
            float2 box_Position;
            float2 _Size;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;  //
                return o;
            }
            
            float sdf_circle(float2 p, float r)
            {
                return length(p) - r;
            }
            float sdf_box( float2 p, float2 b )
            {
                float2 d = abs(p)-b;
                return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
            }

            float smoothMin(float a, float b, float k)
            {
                float h = max(k - abs(a - b), 0.0) / k;
                return min(a, b) - h*h*h* k* 1/6.0;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                float2 p = i.uv; 
                float d_circle = sdf_circle(p-circle_Position, _Radius);
                float d_box = sdf_box(p-box_Position, _Size); 
                float d = smoothMin(d_circle, d_box, factor_k);

                float w1 = exp(-8.0 * abs(d_circle - d));
                float w2 = exp(-8.0 * abs(d_box - d));
                float total = w1 + w2;
                float4 color = (w1 * circle_Color + w2 * box_Color) / total;

                return d < 0 ? color : _Background;
            }

            ENDCG
        }
    }
}
