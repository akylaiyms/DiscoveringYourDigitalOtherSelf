Shader "Unlit/PerlinNoise"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1, 1, 1, 1)
        _Color2 ("Color 2", Color) = (0, 0, 0, 1)
        _Color3 ("Color 3", Color) = (0, 0, 0, 1)
        _Color4 ("Color 4", Color) = (0, 0, 0, 1)
    }
    SubShader
    {
        Tags {"LightMode" = "ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 diffuse : COLOR0;
                float4 specular : COLOR1;
                float4 edges : COLOR2;
            };

            fixed4 _Color1;
            fixed4 _Color2;
            fixed4 _Color3;
            fixed4 _Color4;

            fixed colorMap(fixed x)
            {
                fixed adj_x = x * 5;
                if (adj_x < 1) {
                    return _Color1;
                } else if (adj_x < 2) {
                    return lerp(_Color1, _Color2, frac(adj_x));
                } else if (adj_x < 3) {
                    return lerp(_Color2, _Color3, frac(adj_x));
                } else if (adj_x < 4) {
                    return lerp(_Color3, _Color4, frac(adj_x));
                } else {
                    return _Color4;  
                }
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);

                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float3 eye = normalize(UnityWorldSpaceViewDir(worldPos));

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 lightVector = _WorldSpaceLightPos0.xyz;
                fixed howMuchLight = max(0, dot(worldNormal, lightVector));
               
                o.diffuse = howMuchLight * fixed4(1, 1, 1, 1);
                o.diffuse.rgb += ShadeSH9(float4(worldNormal, 1));

                float3 projection = dot(worldNormal, lightVector) * worldNormal;
                float3 reflection = 2 * projection - lightVector;

                float howMuchSpecular = max(0, dot(reflection, eye));
                o.specular = pow(howMuchSpecular, 4) * fixed4(1, 1, 1, 1);

                o.edges = (1 - max(0, dot(worldNormal, eye))) * fixed4(1, 1, 1, 1);
                return o;
            }

            fixed random01(fixed x)
            {   // random number between 0 and 1 
                return frac(sin(x * 2321.2));
            }

            fixed srandom(fixed x)
            {   // random number between -1 and 1
                return random01(x) * 2 - 1;
            }

            fixed randomCombo(fixed x, fixed y)
            {   // random combination between x and y 
                return srandom(x * 0.472 + y * y * x * 0.125 + x * x * -0.125);
            }

            fixed2 randomUnitVector(fixed x, fixed y)
            {   // random vector from random combination
                fixed theta = randomCombo(x, y) * 3.1415;
                return fixed2(cos(theta), sin(theta));
            }
            
            fixed dotWithCorner(fixed column, fixed row, fixed2 coordinates)
            {
                fixed2 randomVector = randomUnitVector(column, row);
                fixed2 vectorToPoint = coordinates - fixed2(column, row);
                return dot(randomVector, vectorToPoint);   
            }


            fixed perlinNoise(fixed2 coordinates)
            {   // random number between -1 and 1 for every pixel
                fixed column = floor(coordinates.x);
                fixed row = floor(coordinates.y);

                fixed dot_upperleft = dotWithCorner(column, row, coordinates);
                fixed dot_upperright = dotWithCorner(column + 1, row, coordinates);

                fixed dot_lowerleft = dotWithCorner(column, row + 1, coordinates);
                fixed dot_lowerright = dotWithCorner(column + 1, row + 1, coordinates);


                fixed upper_edge = lerp(dot_upperleft, dot_upperright, smoothstep(0.1, 0.9, frac(coordinates.x)));
                fixed lower_edge = lerp(dot_lowerleft, dot_lowerright, smoothstep(0.1, 0.9, frac(coordinates.x)));

                return lerp(upper_edge, lower_edge, smoothstep(0.1, 0.9, frac(coordinates.y))) * _Time;
            }

            fixed fractalSum(fixed2 coordinates, fixed minimum_f, fixed maximum_f, fixed stepSize)
            {
                fixed value = 0;
                for (fixed f = minimum_f; f < maximum_f; f *= stepSize) 
                {
                    value += perlinNoise(coordinates * f) /f * _Time % 2;
                }
                return value; 
            }

            fixed turbulence(fixed2 coordinates, fixed minimum_f, fixed maximum_f, fixed stepSize)
            {
                fixed value = 0;
                for (fixed f = minimum_f; f < maximum_f; f *= stepSize) 
                {
                    value += abs(perlinNoise(coordinates * f)) /f * 1.5;
                }
                return value; 
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed value = fractalSum(i.uv * 15, 1, 10, 10) * 3.1415 + 0.31415;
                return colorMap(value);
            }
            ENDCG
        }
    }
}