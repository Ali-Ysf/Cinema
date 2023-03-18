texture gTexture;
float4 brightness = float4(0.5, 0.5, 0.5, 0.5);

technique TexReplace
{
    pass P0
    {
        Texture[0] = gTexture;
        MaterialEmissive = brightness;
    }
}


