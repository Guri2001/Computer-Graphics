uniform mat4 modelview, projection;


uniform struct {
    mediump vec4 position, ambient, diffuse, specular;
} light;

attribute vec3 vertex, normal;
varying vec3 m, s, t;

void main()
{
// transformed point and normal
    vec4 p = modelview * vec4(vertex,1.0);
    m = normalize(modelview * vec4(normal,0.0)).xyz;
    // light and camera relative to point
    s = normalize(light.position.xyz - p.xyz);
    t = normalize(-p.xyz);
    gl_Position = projection * p;
}
