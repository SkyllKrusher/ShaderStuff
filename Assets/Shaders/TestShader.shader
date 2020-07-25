Shader "Unlit/TestShader"
{
    Properties
    {
        _Color( "Color", Color) = (1, 1, 1, 1)
        _Gloss( "Gloss", Range(1, 100)) = 1
        // _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;       
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: TEXCOORD1;
                float4 worldPos: TEXCOORD2;
            };

            float4 _Color;
            float4 _ColorB;
            float _GradientCentre;
            float _GradientThick;
            float _Gloss;

            v2f vert (VertexInput v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.normal);


                //Lighting
                float3 lightColor = _LightColor0.rgb;
                float3 lightDir = _WorldSpaceLightPos0.xyz;

                //Diffused Direct Light
                float diffuseShade = max(0, dot(normal, lightDir));
                float3 directDiffuseLight = diffuseShade * lightColor;

                //Ambient Light
                float3 ambientLight = float3( 0.35, 0.25, 0.5);

                //Specular Direct Light
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - i.worldPos;
                float3 viewDir = normalize(fragToCam);
                float3 viewReflectDir = reflect(-viewDir, normal);
                float specularShade = max(0, dot(viewReflectDir, lightDir));
                specularShade = pow(specularShade, _Gloss);
                float directSpecularLight = specularShade * lightColor;

                //Composite
                float3 diffuseLight = directDiffuseLight + ambientLight;
                float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecularLight;

                return float4(finalSurfaceColor, 0);
            }
            ENDCG
        }
    }
}
