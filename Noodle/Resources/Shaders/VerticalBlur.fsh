float offset0 = 0.0;
float weight0 = 0.2270270270;

float offset1 = 1.3846153846;
float weight1 = 0.3162162162;

float offset2 = 3.2307692308;
float weight2 = 0.0702702703;

void main(void)
{
    vec3 tc = vec3(1.0, 0.0, 0.0);
    
    vec2 uv = v_tex_coord.xy;
    
    tc = texture2D(u_texture,v_tex_coord).rgb * weight0;
    
    /*tc += texture2D(u_texture, uv + vec2(0.0, offset1)/iResolution.y).rgb \
    * weight1;
    tc += texture2D(u_texture, uv - vec2(0.0, offset1)/iResolution.y).rgb \
    * weight1;
        
    tc += texture2D(u_texture, uv + vec2(0.0, offset2)/iResolution.y).rgb \
    * weight2;
    tc += texture2D(u_texture, uv - vec2(0.0, offset2)/iResolution.y).rgb \
    * weight2;*/
    
    //gl_FragColor = vec4(tc, 1.0);
    
    tc += texture2D(u_texture, uv + vec2(offset1, 0.0)/iResolution.y).rgb \
    * weight1;
    tc += texture2D(u_texture, uv - vec2(offset1, 0.0)/iResolution.y).rgb \
    * weight1;
        
    tc += texture2D(u_texture, uv + vec2(offset2, 0.0)/iResolution.y).rgb \
    * weight2;
    tc += texture2D(u_texture, uv - vec2(offset2, 0.0)/iResolution.y).rgb \
    * weight2;
    
    gl_FragColor = vec4(tc, 1.0);
}