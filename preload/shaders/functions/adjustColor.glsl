// this shader is a slighly edited recreation of the Animate/Flash "Adjust Color" filter,
// which was kindly provided and written by Rozebud https://github.com/ThatRozebudDude ( thank u rozebud :) )
// Adapted from Andrey-Postelzhuks shader found here: https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
// Hue rotation stuff is from here: https://www.w3.org/TR/filter-effects/#feColorMatrixElement

vec3 applyBrightness(vec3 color, float brightness)
{
	return clamp(color + (brightness / 255.0), 0.0, 1.0);
}

const mat3 hueRotationM1 = mat3(0.213, 0.213, 0.213, 0.715, 0.715, 0.715, 0.072, 0.072, 0.072);
const mat3 hueRotationM2 = mat3(0.787, -0.213, -0.213, -0.715, 0.285, -0.715, -0.072, -0.072, 0.928);
const mat3 hueRotationM3 = mat3(-0.213, 0.143, -0.787, -0.715, 0.140, 0.715, 0.928, -0.283, 0.072);

vec3 applyHue(vec3 color, float hue)
{
	float angle = radians(hue);
	mat3 m = hueRotationM1 + cos(angle) * hueRotationM2 + sin(angle) * hueRotationM3;
	return m * color;
}

const vec3 grayscaleValues = vec3(0.3098039215686275, 0.607843137254902, 0.0823529411764706);

vec3 applySaturation(vec3 color, float saturation)
{
	if (saturation > 0.0) saturation = saturation * 3.0;

	vec3 grayscale = vec3(dot(color, grayscaleValues));
	return clamp(mix(grayscale, color, 1.0 + (saturation / 100.0)), 0.0, 1.0);
}

const float contrastEuler = 2.718281828459045;

vec3 applyContrast(vec3 color, float contrast)
{
	if (contrast > 0.0) contrast = 1.0 + (((0.00852259 * pow(contrastEuler, 4.76454 * contrast / 100.0)) * 1.01) - 0.0086078159) * 10.0;
	else contrast = 1.0 + contrast / 100.0;

	return clamp(0.25 + (color - 0.25) * contrast, 0.0, 1.0);
}