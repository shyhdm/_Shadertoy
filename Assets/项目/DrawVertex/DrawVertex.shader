Shader "Unlit/SimplePoints"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        Pass
        {
            ZWrite On
            Cull Off

            CGPROGRAM
            #pragma target 4.5
            #pragma vertex   vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            StructuredBuffer<float3> _Vertices; // 从 C# 传入的顶点缓冲

            struct VIn  
            {
                uint vertexID : SV_VertexID; 
            };

            struct VOut 
            {
                float4 pos : SV_POSITION; 
                float  size : PSIZE;
            };

            VOut vert (VIn i)
            {
                float3 p = _Vertices[i.vertexID];

                float c = cos(_Time.y);
                float s = sin(_Time.y);
                float2 r = mul(float2x2(c, -s, s, c), p.xy);
                p.xy = r;

                float4 world = mul(unity_ObjectToWorld, float4(p,1));
                VOut o;
                o.pos = mul(UNITY_MATRIX_VP, world);
                return o;
            }

            fixed4 frag() : SV_Target 
            {
                return float4(1, 1, 1, 1); 
            } 

            ENDCG
        }
    }
    FallBack Off
}
