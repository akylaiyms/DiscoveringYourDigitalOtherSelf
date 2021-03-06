Shader "Fractal" {
    // Adjustable properties.
    Properties {
        fractalType ("Fractal Type", Int) = 0 //0 = Mandelbrot, 1 = Julia
        iterations ("Iterations", Int) = 100 //Number of times to iterate each pixel.
        convergenceThreshold ("Convergence Threshold", Float) = 4 //Required amount for a fractal pixel to have converged.
        smoothing ("Smoothing", Int) = 0 //0 = No smoothing, 1 = Smoothing
        centerX ("Center X", Float) = 0 //X co-ordinate of center point of the fractal.
        centerY ("Center Y", Float) = 0 //Y co-ordinate of center point of the fractal.
        scale ("Scale", Float) = 4 //Scale of the fractal.
        multibrot ("Multibrot", Int) = 2 //Multibrot value (2..5).
        juliaConstantReal ("Constant Real", Float) = -0.4 //The real part of the constant for the Julia algorithm.
        juliaConstantImaginary ("Constant Imaginary", Float) = 0.6 //The imaginary part of the constant for the Julia algorithm.
        redFormula ("Red Formula", Int) = 1 //The formula for calculating the red component of the output color.
        redFixedValue ("Red Fixed Value", Float) = 0 //The fixed red value (if "Fixed value" formula is selected).
        redMultiplier ("Red Multiplier", Float) = 1 //The red value multiplier.
        greenFormula ("Green Formula", Int) = 1 //The formula for calculating the green component of the output color.
        greenFixedValue ("Green Fixed Value", Float) = 0 //The fixed green value (if "Fixed value" formula is selected).
        greenMultiplier ("Green Multiplier", Float) = 1 //The green value multiplier.
        blueFormula ("Blue Formula", Int) = 1 //The formula for calculating the blue component of the output color.
        blueFixedValue ("Blue Fixed Value", Float) = 0 //The fixed blue value (if "Fixed value" formula is selected).
        blueMultiplier ("Blue Multiplier", Float) = 1 //The blue value multiplier.
        isTransparent("Transparent", Int) = 0 //0 = Opaque, 1 = Transparent

        [Enum(Off,0,On,1)]_zWrite("Z Write", Float) = 1.0
        [Enum(UnityEngine.Rendering.BlendMode)]_sourceBlend("Blend Source Alpha", Float) = 1.0
        [Enum(UnityEngine.Rendering.BlendMode)]_destinationBlend("Blend Destination Alpha", Float) = 0.0

        minimumFractalAlphaIterations("Minimum Fractal Alpha Iterations", Float) = 0.0
        maximumFractalAlphaIterations("Maximum Fractal Alpha Iterations", Float) = 1.0
        hueChange("Hue Change", Float) = 0.0
        saturationMultiplier("Saturation Multiplier", Float) = 1.0
        valueMultiplier("Value Multiplier", Float) = 1.0
        HSVMatrix1("HSV Matrix 1", Vector) = (0.0, 0.0, 0.0, 0.0)
        HSVMatrix2("HSV Matrix 2", Vector) = (0.0, 0.0, 0.0, 0.0)
        HSVMatrix3("HSV Matrix 3", Vector) = (0.0, 0.0, 0.0, 0.0)
    }

    SubShader {
        Pass {  
            ZWrite [_zWrite]
            Blend [_sourceBlend] [_destinationBlend]

            CGPROGRAM
                #pragma vertex vertexShader
                #pragma fragment fragmentShader
                #pragma target 3.0
                int fractalType;
                int iterations;
                float convergenceThreshold;
                int smoothing;
                float centerX;
                float centerY;
                float scale;
                int multibrot;
                float juliaConstantReal;
                float juliaConstantImaginary;
                int redFormula;
                float redFixedValue;
                float redMultiplier;
                int greenFormula;
                float greenFixedValue;
                float greenMultiplier;
                int blueFormula;
                float blueFixedValue;
                float blueMultiplier;
                float masterAlpha;
                float minimumFractalAlphaIterations;
                float maximumFractalAlphaIterations;
                float hueChange;
                float saturationMultiplier;
                float valueMultiplier;
                float4 HSVMatrix1, HSVMatrix2, HSVMatrix3;

                //Complex numbers multiplication and division.
                float2 complexMultiply(float2 x, float2 y) {
                    return float2((x.x * y.x) - (x.y * y.y), (x.x * y.y) + (x.y * y.x));
                }
                float2 complexDivide(float2 x, float2 y) {
                    float2 numerator = float2((x.x * y.x) + (x.y * y.y), (x.y * y.x) - (x.x * y.y));
                    float denominator = (y.x * y.x) + (y.y * y.y);
                    if (denominator != 0)
                        return numerator / denominator;
                    else
                        return float2(0, 0);
                }

                //Structure for converting a vertex to a fragment.
                struct VertexToFragment {
                    float4 position : POSITION0;
                    float2 pixelPosition : TEXCOORD0;
                };

                //Adjust the hue, saturation and value of a color.
                float3 adjustHSV(float3 color, float hueChange, float saturationMultiplier, float valueMultiplier) {
                    float vsu = valueMultiplier * saturationMultiplier * cos(hueChange);
                    float vsw = valueMultiplier * saturationMultiplier * sin(hueChange);
                    float3 returnColor;
                    returnColor.r = (HSVMatrix1.x * color.r) + (HSVMatrix1.y * color.g) + (HSVMatrix1.z * color.b);
                    returnColor.g = (HSVMatrix2.x * color.r) + (HSVMatrix2.y * color.g) + (HSVMatrix2.z * color.b);
                    returnColor.b = (HSVMatrix3.x * color.r) + (HSVMatrix3.y * color.g) + (HSVMatrix3.z * color.b);
                    return returnColor;
                }
 
                //Vertex shader.
                VertexToFragment vertexShader(float4 vertexPosition : POSITION0, float2 textureCoordinates : TEXCOORD0) {
                    VertexToFragment vertexToFragment;
                    vertexToFragment.position = UnityObjectToClipPos(vertexPosition);
                    vertexToFragment.pixelPosition = textureCoordinates.xy - float2(0.5, 0.5);
                    return vertexToFragment;
                }
                            
                //Fragment shader.                         
                float4 fragmentShader(VertexToFragment vertexToFragment) : COLOR {
                    float2 z = (vertexToFragment.pixelPosition * scale) + float2(centerX, centerY);
                    float2 c = fractalType == 1 ? float2(juliaConstantReal, juliaConstantImaginary) : z;
                    float i = 1;
                    float zn = 0;
                    while (i < (float) iterations - 0.1) {
                        for (int j = 1; j < min(multibrot, 5); j++)
                            z = complexMultiply(z, z);
                        z += c;
                        i += 1;
                        zn = sqrt((z.x * z.x) + (z.y * z.y));
                        if(zn > convergenceThreshold) {
                            if (smoothing == 1)
                                i -= (log(log(zn)) / log(pow(2, multibrot - 1))) - 1;
                            break;
                        }
                    }
                    float value = i / (float) iterations;
                    float r, g, b;
                    if (redFormula == 0)
                        r = redFixedValue;
                    else if (redFormula == 1)
                        r = value;
                    else if (redFormula == 2)
                        r = sin(value * redMultiplier);
                    else if (redFormula == 3)
                        r = cos(value * redMultiplier);
                    else if (redFormula == 4)
                        r = tan(value * redMultiplier);
                    else if (redFormula == 5)
                        r = z.x * redMultiplier;
                    else if (redFormula == 6)
                        r = z.y * redMultiplier;
                    else if (redFormula == 7)
                        r = sin(z.x * redMultiplier);
                    else if (redFormula == 8)
                        r = cos(z.x * redMultiplier);
                    else if (redFormula == 9)
                        r = tan(z.x * redMultiplier);
                    else if (redFormula == 10)
                        r = sin(z.y * redMultiplier);
                    else if (redFormula == 11)
                        r = cos(z.y * redMultiplier);
                    else if (redFormula == 12)
                        r = tan(z.y * redMultiplier);
                    if (greenFormula == 0)
                        g = greenFixedValue;
                    else if (greenFormula == 1)
                        g = value;
                    else if (greenFormula == 2)
                        g = sin(value * greenMultiplier);
                    else if (greenFormula == 3)
                        g = cos(value * greenMultiplier);
                    else if (greenFormula == 4)
                        g = tan(value * greenMultiplier);
                    else if (greenFormula == 5)
                        g = z.x * greenMultiplier;
                    else if (greenFormula == 6)
                        g = z.y * greenMultiplier;
                    else if (greenFormula == 7)
                        g = sin(z.x * greenMultiplier);
                    else if (greenFormula == 8)
                        g = cos(z.x * greenMultiplier);
                    else if (greenFormula == 9)
                        g = tan(z.x * greenMultiplier);
                    else if (greenFormula == 10)
                        g = sin(z.y * greenMultiplier);
                    else if (greenFormula == 11)
                        g = cos(z.y * greenMultiplier);
                    else if (greenFormula == 12)
                        g = tan(z.y * greenMultiplier);
                    if (blueFormula == 0)
                        b = blueFixedValue;
                    else if (blueFormula == 1)
                        b = value;
                    else if (blueFormula == 2)
                        b = sin(value * blueMultiplier);
                    else if (blueFormula == 3)
                        b = cos(value * blueMultiplier);
                    else if (blueFormula == 4)
                        b = tan(value * blueMultiplier);
                    else if (blueFormula == 5)
                        b = z.x * blueMultiplier;
                    else if (blueFormula == 6)
                        b = z.y * blueMultiplier;
                    else if (blueFormula == 7)
                        b = sin(z.x * blueMultiplier);
                    else if (blueFormula == 8)
                        b = cos(z.x * blueMultiplier);
                    else if (blueFormula == 9)
                        b = tan(z.x * blueMultiplier);
                    else if (blueFormula == 10)
                        b = sin(z.y * blueMultiplier);
                    else if (blueFormula == 11)
                        b = cos(z.y * blueMultiplier);
                    else if (blueFormula == 12)
                        b = tan(z.y * blueMultiplier);
                    float fractalAlpha = i / iterations;
                    if (fractalAlpha < minimumFractalAlphaIterations)
                        fractalAlpha = 0;
                    else if (fractalAlpha > maximumFractalAlphaIterations)
                        fractalAlpha = 1;
                    float4 returnColor = (float4(r, g, b, fractalAlpha)) *
                            float4(1, 1, 1, masterAlpha);
                    if (abs(hueChange) > 0.0001 || saturationMultiplier < 0.9999 || saturationMultiplier > 1.0001 || valueMultiplier < 0.9999 ||
                            valueMultiplier > 1.0001)
                        returnColor = float4(adjustHSV(saturate(returnColor.rgb), hueChange * 3.141592654, saturationMultiplier, valueMultiplier),
                                returnColor.a);
                    return returnColor * _Time;
                }
            ENDCG
        }
    }
 }