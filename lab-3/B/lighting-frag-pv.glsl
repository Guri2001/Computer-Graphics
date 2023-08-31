precision mediump float;

// light data
uniform struct {
    vec4 position, ambient, diffuse, specular;  
} light;

// material data
uniform struct {
    vec4 ambient, diffuse, specular;
    float shininess;
} material;

// clipping plane depths
uniform float near, far;

// normal, source and taget -- interpolated across all triangles
varying vec3 m, s, t;


void main()
{

    vec3 n = normalize(m);
    vec3 r = -normalize(reflect(s,n));


    vec4 diffuse = material.diffuse * 
                   max(dot(s,n),0.0) * 
                   light.diffuse;

    vec4 ambient = material.ambient * light.ambient*0.5;

  

    vec4 specular = material.specular *pow(max(dot(r,t),0.0), material.shininess) *light.specular;

    gl_FragColor = vec4((ambient+ diffuse ).rgb, 1.0);
}