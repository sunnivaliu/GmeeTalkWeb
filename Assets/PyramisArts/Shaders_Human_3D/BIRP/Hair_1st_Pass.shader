Shader "PyramisArts/BIRP/Human/Hair 1st Pass"
{
	Properties
	{
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,0)
		_DiffuseStrength("Diffuse Strength", Range( 0 , 2)) = 1
		_VertexBaseColor("Vertex Base Color", Color) = (0,0,0,0)
		_VertexColorStrength("Vertex Color Strength", Range( 0 , 1)) = 0.5
		_AlphaPower("Alpha Power", Range( 0.01 , 2)) = 1
		_AlphaRemap("Alpha Remap", Range( 0.5 , 1)) = 0.5
		_AlphaClip("Alpha Clip", Range( 0 , 1)) = 0.15
		_MaskMap("Mask Map", 2D) = "white" {}
		_AOStrength("Ambient Occlusion Strength", Range( 0 , 1)) = 1
		_AOOccludeAll("AO Occlude All", Range( 0 , 1)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0.5 , 2)) = 1.25
		_SmoothnessMin("Smoothness Min", Range( 0 , 1)) = 0
		_SmoothnessMax("Smoothness Max", Range( 0 , 1)) = 1
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Range( 0 , 2)) = 1
		_BlendMap("Blend Map", 2D) = "white" {}
		_BlendStrength("Blend Strength", Range( 0 , 1)) = 1
		_FlowMap("Flow Map", 2D) = "gray" {}
		[Toggle]_FlowMapFlipGreen("Flow Map Flip Green", Float) = 0
		_SpecularMap("Specular  Map", 2D) = "white" {}
		_SpecularTint("Specular Tint", Color) = (1,1,1,0)
		_SpecularMultiplier("Specular Strength", Range( 0 , 2)) = 1
		_SpecularPowerScale("Specular Smoothness", Range( 0 , 10)) = 2
		_SpecularShiftMin("Specular Shift Min", Range( -1 , 1)) = -0.25
		_SpecularShiftMax("Specular Shift Max", Range( -1 , 1)) = 0.25
		_SpecularMix("Specular Mix", Range( 0.5 , 1)) = 1
		_Translucency("Translucency", Range( 0 , 1)) = 0
		_RimPower("Rim Hardness", Range( 1 , 10)) = 4
		_RimTransmissionIntensity("Rim Transmission Intensity", Range( 0 , 75)) = 10
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		[Toggle(BOOLEAN_ENABLECOLOR_ON)] BOOLEAN_ENABLECOLOR("Enable Color", Float) = 0
		_RootMap("Root Map", 2D) = "gray" {}
		_BaseColorStrength("Base Color Strength", Range( 0 , 1)) = 1
		_GlobalStrength("Global Strength", Range( 0 , 1)) = 1
		_RootColorStrength("Root Color Strength", Range( 0 , 1)) = 1
		_EndColorStrength("End Color Strength", Range( 0 , 1)) = 1
		_InvertRootMap("Invert Root Map", Range( 0 , 1)) = 0
		_RootColor("Root Color", Color) = (0.3294118,0.1411765,0.05098039,0)
		_EndColor("End Color", Color) = (0.6039216,0.454902,0.2862745,0)
		_IDMap("ID Map", 2D) = "gray" {}
		_HighlightBlend("Highlight Blend", Range( 0 , 1)) = 1
		_HighlightAStrength("Highlight A Strength", Range( 0 , 1)) = 1
		_HighlightAColor("Highlight A Color", Color) = (0.9137255,0.7803922,0.6352941,0)
		_HighlightADistribution("Highlight A Distribution", Vector) = (0.1,0.2,0.3,0)
		_HighlightAOverlapEnd("Highlight A Overlap End", Range( 0 , 1)) = 1
		_HighlightAOverlapInvert("Highlight A Overlap Invert", Range( 0 , 1)) = 1
		_HighlightBStrength("Highlight B Strength", Range( 0 , 1)) = 1
		_HighlightBColor("Highlight B Color", Color) = (1,1,1,0)
		_HighlightBDistribution("Highlight B Distribution", Vector) = (0.1,0.2,0.3,0)
		_HighlightBOverlapEnd("Highlight B Overlap End", Range( 0 , 1)) = 1
		_HighlightBOverlapInvert("Highlight B Overlap Invert", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite On
		ZTest LEqual
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local BOOLEAN_ENABLECOLOR_ON
		#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
		#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			half3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_DiffuseMap);
		uniform half4 _DiffuseMap_ST;
		SamplerState sampler_DiffuseMap;
		uniform half _AlphaRemap;
		uniform half _AlphaPower;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_FlowMap);
		uniform half4 _FlowMap_ST;
		uniform half _FlowMapFlipGreen;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalMap);
		uniform half4 _NormalMap_ST;
		uniform half _NormalStrength;
		uniform half _SpecularShiftMin;
		uniform half _SpecularShiftMax;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_IDMap);
		uniform half4 _IDMap_ST;
		uniform half _SmoothnessMin;
		uniform half _SmoothnessMax;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MaskMap);
		uniform half4 _MaskMap_ST;
		uniform half _SmoothnessPower;
		uniform half _SpecularPowerScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecularMap);
		uniform half4 _SpecularMap_ST;
		uniform half _SpecularMultiplier;
		uniform half _Translucency;
		uniform half4 _SpecularTint;
		uniform half4 _DiffuseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendMap);
		uniform half4 _BlendMap_ST;
		uniform half _DiffuseStrength;
		uniform half _BaseColorStrength;
		uniform half4 _RootColor;
		uniform half4 _EndColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_RootMap);
		uniform half4 _RootMap_ST;
		uniform half _InvertRootMap;
		uniform half _RootColorStrength;
		uniform half _EndColorStrength;
		uniform half _GlobalStrength;
		uniform half4 _HighlightAColor;
		uniform half3 _HighlightADistribution;
		uniform half _HighlightAStrength;
		uniform half _HighlightAOverlapEnd;
		uniform half _HighlightAOverlapInvert;
		uniform half _HighlightBlend;
		uniform half4 _HighlightBColor;
		uniform half3 _HighlightBDistribution;
		uniform half _HighlightBStrength;
		uniform half _HighlightBOverlapEnd;
		uniform half _HighlightBOverlapInvert;
		uniform half _BlendStrength;
		uniform half4 _VertexBaseColor;
		uniform half _VertexColorStrength;
		uniform half _SpecularMix;
		uniform half _RimPower;
		uniform half _RimTransmissionIntensity;
		uniform half _AOStrength;
		uniform half _AOOccludeAll;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionMap);
		uniform half4 _EmissionMap_ST;
		SamplerState sampler_EmissionMap;
		uniform half4 _EmissiveColor;
		uniform half _AlphaClip;


		half ThreePointDistribution( half3 From, half ID, half Fac )
		{
			float lower = smoothstep(From.x, From.y, ID);
			float upper = 1.0 - smoothstep(From.y, From.z, ID);
			return Fac * lerp(lower, upper, step(From.y, ID));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			half4 tex2DNode19 = SAMPLE_TEXTURE2D( _DiffuseMap, sampler_DiffuseMap, uv_DiffuseMap );
			half saferPower23 = abs( saturate( ( tex2DNode19.a / _AlphaRemap ) ) );
			half alpha518 = pow( saferPower23 , _AlphaPower );
			half temp_output_521_0 = alpha518;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			half4 break109_g880 = SAMPLE_TEXTURE2D( _FlowMap, sampler_DiffuseMap, uv_FlowMap );
			half lerpResult123_g880 = lerp( break109_g880.g , ( 1.0 - break109_g880.g ) , _FlowMapFlipGreen);
			half3 appendResult98_g880 = (half3(break109_g880.r , lerpResult123_g880 , break109_g880.b));
			half3 flowTangent107_g880 = (WorldNormalVector( i , ( ( appendResult98_g880 * float3( 2,2,2 ) ) - float3( 1,1,1 ) ) ));
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			half3 normal282 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _NormalMap, sampler_DiffuseMap, uv_NormalMap ), _NormalStrength );
			half3 worldNormal86_g880 = normalize( (WorldNormalVector( i , normal282 )) );
			float2 uv_IDMap = i.uv_texcoord * _IDMap_ST.xy + _IDMap_ST.zw;
			half idMap383 = SAMPLE_TEXTURE2D( _IDMap, sampler_DiffuseMap, uv_IDMap ).r;
			half lerpResult81_g880 = lerp( _SpecularShiftMin , _SpecularShiftMax , idMap383);
			half3 normalizeResult10_g883 = normalize( ( flowTangent107_g880 + ( worldNormal86_g880 * lerpResult81_g880 ) ) );
			half3 shiftedTangent119_g880 = normalizeResult10_g883;
			float3 ase_worldPos = i.worldPos;
			half3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			half3 viewDIr52_g881 = ase_worldViewDir;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			half3 ase_worldlightDir = 0;
			#else //aseld
			half3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			half3 worldLight272_g880 = ase_worldlightDir;
			half3 lightDIr80_g881 = worldLight272_g880;
			half3 normalizeResult14_g882 = normalize( ( viewDIr52_g881 + lightDIr80_g881 ) );
			half dotResult16_g882 = dot( shiftedTangent119_g880 , normalizeResult14_g882 );
			half smoothstepResult22_g882 = smoothstep( -1.0 , 0.0 , dotResult16_g882);
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			half4 tex2DNode115 = SAMPLE_TEXTURE2D( _MaskMap, sampler_DiffuseMap, uv_MaskMap );
			half saferPower126 = abs( tex2DNode115.a );
			half lerpResult128 = lerp( _SmoothnessMin , _SmoothnessMax , pow( saferPower126 , _SmoothnessPower ));
			half smoothness587 = lerpResult128;
			half temp_output_233_0_g880 = max( ( 1.0 - smoothness587 ) , 0.001 );
			half specularPower237_g880 = ( max( ( ( 2.0 / ( temp_output_233_0_g880 * temp_output_233_0_g880 ) ) - 2.0 ) , 0.001 ) * _SpecularPowerScale );
			float2 uv_SpecularMap = i.uv_texcoord * _SpecularMap_ST.xy + _SpecularMap_ST.zw;
			half dotResult266_g880 = dot( normalize( (WorldNormalVector( i , normal282 )) ) , worldLight272_g880 );
			half translucencyWrap283_g880 = _Translucency;
			half lambertMask290_g880 = saturate( ( ( dotResult266_g880 * ( 1.0 - translucencyWrap283_g880 ) ) + translucencyWrap283_g880 ) );
			half temp_output_84_0_g881 = lambertMask290_g880;
			half4 temp_output_13_0_g881 = ( ( smoothstepResult22_g882 * pow( saturate( ( 1.0 - ( dotResult16_g882 * dotResult16_g882 ) ) ) , specularPower237_g880 ) ) * ( SAMPLE_TEXTURE2D( _SpecularMap, sampler_DiffuseMap, uv_SpecularMap ).g * _SpecularMultiplier ) * temp_output_84_0_g881 * _SpecularTint * alpha518 );
			float2 uv_BlendMap = i.uv_texcoord * _BlendMap_ST.xy + _BlendMap_ST.zw;
			half4 diffuseMap517 = tex2DNode19;
			half4 lerpResult41_g773 = lerp( float4( 1,1,1,0 ) , diffuseMap517 , _BaseColorStrength);
			float2 uv_RootMap = i.uv_texcoord * _RootMap_ST.xy + _RootMap_ST.zw;
			half root58 = SAMPLE_TEXTURE2D( _RootMap, sampler_DiffuseMap, uv_RootMap ).r;
			half temp_output_55_0_g773 = root58;
			half lerpResult50_g773 = lerp( temp_output_55_0_g773 , ( 1.0 - temp_output_55_0_g773 ) , _InvertRootMap);
			half4 lerpResult44_g773 = lerp( _RootColor , _EndColor , lerpResult50_g773);
			half lerpResult43_g773 = lerp( _RootColorStrength , _EndColorStrength , lerpResult50_g773);
			half4 lerpResult53_g773 = lerp( lerpResult41_g773 , lerpResult44_g773 , ( lerpResult43_g773 * _GlobalStrength ));
			half3 From8_g778 = _HighlightADistribution;
			half ID8_g778 = idMap383;
			half Fac8_g778 = _HighlightAStrength;
			half localThreePointDistribution8_g778 = ThreePointDistribution( From8_g778 , ID8_g778 , Fac8_g778 );
			half temp_output_24_0_g778 = root58;
			half lerpResult16_g778 = lerp( temp_output_24_0_g778 , ( 1.0 - temp_output_24_0_g778 ) , _HighlightAOverlapInvert);
			half4 lerpResult18_g778 = lerp( lerpResult53_g773 , _HighlightAColor , saturate( ( localThreePointDistribution8_g778 * ( 1.0 - ( _HighlightAOverlapEnd * lerpResult16_g778 ) ) * _HighlightBlend ) ));
			half3 From8_g779 = _HighlightBDistribution;
			half ID8_g779 = idMap383;
			half Fac8_g779 = _HighlightBStrength;
			half localThreePointDistribution8_g779 = ThreePointDistribution( From8_g779 , ID8_g779 , Fac8_g779 );
			half temp_output_24_0_g779 = root58;
			half lerpResult16_g779 = lerp( temp_output_24_0_g779 , ( 1.0 - temp_output_24_0_g779 ) , _HighlightBOverlapInvert);
			half4 lerpResult18_g779 = lerp( lerpResult18_g778 , _HighlightBColor , saturate( ( localThreePointDistribution8_g779 * ( 1.0 - ( _HighlightBOverlapEnd * lerpResult16_g779 ) ) * _HighlightBlend ) ));
			#ifdef BOOLEAN_ENABLECOLOR_ON
				half4 staticSwitch95 = lerpResult18_g779;
			#else
				half4 staticSwitch95 = diffuseMap517;
			#endif
			half4 blendOpSrc101 = SAMPLE_TEXTURE2D( _BlendMap, sampler_DiffuseMap, uv_BlendMap );
			half4 blendOpDest101 = ( _DiffuseStrength * staticSwitch95 );
			half4 lerpBlendMode101 = lerp(blendOpDest101,( blendOpSrc101 * blendOpDest101 ),_BlendStrength);
			half4 lerpResult112 = lerp( ( saturate( lerpBlendMode101 )) , _VertexBaseColor , ( ( 1.0 - i.vertexColor.r ) * _VertexColorStrength ));
			half4 baseColor331 = ( _DiffuseColor * lerpResult112 );
			half4 temp_output_42_0_g880 = baseColor331;
			half4 temp_output_32_0_g881 = temp_output_42_0_g880;
			half4 lerpResult36_g881 = lerp( temp_output_13_0_g881 , ( temp_output_13_0_g881 * temp_output_32_0_g881 ) , _SpecularMix);
			half3 temp_output_24_0_g881 = worldNormal86_g880;
			half dotResult82_g881 = dot( lightDIr80_g881 , temp_output_24_0_g881 );
			half temp_output_40_0_g881 = translucencyWrap283_g880;
			half dotResult54_g881 = dot( temp_output_24_0_g881 , viewDIr52_g881 );
			half dotResult57_g881 = dot( viewDIr52_g881 , lightDIr80_g881 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			half4 ase_lightColor = 0;
			#else //aselc
			half4 ase_lightColor = _LightColor0;
			#endif //aselc
			half lerpResult608 = lerp( 1.0 , tex2DNode115.g , _AOStrength);
			half ambientOcclusion570 = lerpResult608;
			half temp_output_161_0_g880 = ambientOcclusion570;
			half lerpResult183_g880 = lerp( 1.0 , temp_output_161_0_g880 , _AOOccludeAll);
			half4 temp_output_182_0_g880 = ( ( ( lerpResult36_g881 + ( ( saturate( ( ( dotResult82_g881 * ( 1.0 - temp_output_40_0_g881 ) ) + temp_output_40_0_g881 ) ) + ( pow( ( max( ( 1.0 - abs( dotResult54_g881 ) ) , 0.0 ) * max( ( 0.0 - dotResult57_g881 ) , 0.0 ) ) , _RimPower ) * _RimTransmissionIntensity * temp_output_84_0_g881 ) ) * temp_output_32_0_g881 ) ) * ase_lightColor * ase_lightAtten ) * lerpResult183_g880 );
			UnityGI gi53_g880 = gi;
			float3 diffNorm53_g880 = worldNormal86_g880;
			gi53_g880 = UnityGI_Base( data, 1, diffNorm53_g880 );
			half3 indirectDiffuse53_g880 = gi53_g880.indirect.diffuse + diffNorm53_g880 * 0.0001;
			#ifdef UNITY_PASS_FORWARDBASE
				half4 staticSwitch250_g880 = ( temp_output_182_0_g880 + ( half4( indirectDiffuse53_g880 , 0.0 ) * temp_output_42_0_g880 * temp_output_161_0_g880 ) );
			#else
				half4 staticSwitch250_g880 = temp_output_182_0_g880;
			#endif
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			clip( alpha518 - _AlphaClip);
			c.rgb = ( staticSwitch250_g880 + ( SAMPLE_TEXTURE2D( _EmissionMap, sampler_EmissionMap, uv_EmissionMap ) * _EmissiveColor ) ).rgb;
			c.a = temp_output_521_0;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows nometa 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}