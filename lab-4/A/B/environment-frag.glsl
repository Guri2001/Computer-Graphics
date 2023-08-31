// ECS610U -- Miles Hansard

precision highp float;

uniform mat4 modelview, modelview_inv, projection, view_inv;

uniform struct {
    vec4 position, ambient, diffuse, specular;  
} light;

uniform bool render_skybox, render_texture;
uniform samplerCube cubemap;
uniform sampler2D texture;
uniform float image_width;
uniform float image_height;

float radius = image_width/2.0;

varying vec2 map;
varying vec3 d, m;
varying vec4 p, q;


vec4 gamma_transform(vec4 colour, float gamma)
{
    return vec4(pow(colour.rgb, vec3(gamma)), colour.a);
}


float vignette(vec4 fragCoord) {
  // get the distance of the fragment from the center of the image
  vec2 resolution = vec2(512,512);
  vec2 uv = fragCoord.xy / resolution.xy;
  float dist = distance(uv, vec2(0.5));

  // use a smoothed version of the distance to get a smooth transition
  // between the vignette and the center of the image
  float val = smoothstep(0.8, 1.0, dist);

  // return the vignette value, clamped to the range [vmin, 1]
  return clamp(val, 1.0, 1.0);
}





void main()
{ 
 
    vec3 n = normalize(m);

    if(render_skybox) {
        gl_FragColor = textureCube(cubemap,vec3(-d.x,d.y,d.z));
    }
    else {

        // object colour
        vec4 material_colour = texture2D(texture,map);

        //vec4 colours = vec4(1.0 - material_colour.r, 1.0 - material_colour.g, 1.0 - material_colour.b,1.0);
        // sources and target directions 
        vec3 s = normalize(q.xyz - p.xyz);
        vec3 t = normalize(-p.xyz);

        // reflection vector in world coordinates
        vec3 r = (view_inv * vec4(reflect(-t,n),0.0)).xyz;

        // reflected background colour
        vec4 reflection_colour = textureCube(cubemap,vec3(-r.x,r.y,r.z));

        // blinn-phong lighting

        vec4 ambient = material_colour * light.ambient;
        vec4 diffuse = material_colour * max(dot(s,n),0.0) * light.diffuse;

        // halfway vector
        vec3 h = normalize(s + t);
        vec4 specular = pow(max(dot(h,n), 0.0), 4.0) * light.specular;       
  
    //     float dark = length(vec3(material_colour.rgb));
    //     if(dark < 0.05){
    //         material_colour.a = 0.0;
    //     }

        
    //     gl_FragColor = material_colour + reflection_colour*0.1;
    
    // }
        //gl_FragColor = colours + reflection_colour*0.1;
        
        
            // do gamma transformation here
             
    
        
        


//        combined colour
        if(render_texture) {
            // B2 -- MODIFY
            gl_FragColor = vec4((0.5 * ambient + 
                                 0.5 * diffuse + 
                                 0.01 * specular + 
                                 0.1 * reflection_colour).rgb, 1.0);
        }
        else {
            // reflection only 
            gl_FragColor = reflection_colour;
        }


        // scale the final fragment rgb by vignette value
        // gl_FragColor.rgb *= vignette(gl_FragCoord);

        // if(gl_FragCoord.x > 425.0){

        //     gl_FragColor = gamma_transform(material_colour+reflection_colour*0.1,2.0);   
        // }

        //set fragment to white -- for debugging only

    

        // scale the final fragment rgb by vignette value


    
    }


    gl_FragColor = vec4(1.0);


 
}

