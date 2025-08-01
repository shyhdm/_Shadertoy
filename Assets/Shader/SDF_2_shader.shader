Shader "Unlit/SDF_2"
{
    Properties
    {
        _Strength("Strength", Range(0, 0.1)) = 0.02
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float _Strength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 offset = float2( sin(i.uv.y * 30),  cos(i.uv.x * 30)) * _Strength;
                float y = i.uv.y + offset.y;

                fixed4 col;
                if (y < 0.166)      col = fixed4(1, 0, 0, 1);    
                else if (y < 0.333) col = fixed4(1, 0.5, 0, 1);  
                else if (y < 0.5)   col = fixed4(1, 1, 0, 1);    
                else if (y < 0.666) col = fixed4(0, 1, 0, 1);    
                else if (y < 0.833) col = fixed4(0, 0, 1, 1);    
                else                col = fixed4(1, 0, 1, 1);    

                return col;
            }
            ENDCG
        }
    }
}
