Shader "PyramisArts/BIRP/Human/Skin 3D Hidden"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,0)
		_MaskMap("Mask Map", 2D) = "gray" {}
		_AOStrength("AO Strength", Range( 0 , 1)) = 0
		_SmoothnessPower("SmoothnessPower", Range( 0.1 , 2)) = 0.1
		_SmoothnessMin("SmoothnessMin", Range( 0 , 1)) = 0
		_SmoothnessMax("SmoothnessMax", Range( 0 , 1)) = 0
		[Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_OpacityMask("Opacity Mask", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( 0 , 2)) = 1
		[Normal]_MicroNormalMap("Micro Normal Map", 2D) = "bump" {}
		_MicroNormalStrength("Micro Normal Strength", Range( 0 , 1)) = 0.5
		_MicroNormalTiling("Micro Normal Tiling", Range( 0 , 50)) = 25
		_SSSMap("Subsurface Map", 2D) = "white" {}
		_SubsurfaceScale("Subsurface Scale", Range( 0 , 1)) = 1
		_SubsurfaceFalloff("Subsurface Falloff", Color) = (1,0.3686275,0.2980392,0)
		_SubsurfaceNormalSoften("Subsurface Normal Soften", Range( 0 , 1)) = 0.4
		_ThicknessMap("Thickness Map", 2D) = "black" {}
		_ThicknessScale("ThicknessScale", Range( 0 , 1)) = 1
		_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		_RGBAMask("RGBAMask", 2D) = "black" {}
		_MicroSmoothnessMod("Micro Smoothness Mod", Range( -1.5 , 1.5)) = 0
		_RSmoothnessMod("R/Chest", Range( -1.5 , 1.5)) = 0
		_GSmoothnessMod("G/Abdomen", Range( -1.5 , 1.5)) = 0
		_BSmoothnessMod("B/Buttocks", Range( -1.5 , 1.5)) = 0
		_UnmaskedSmoothnessMod("Unmasked Smoothness Mod", Range( -1.5 , 1.5)) = 0
		[Toggle(BOOLEAN_IS_HEAD_ON)] BOOLEAN_IS_HEAD("Is Head", Float) = 1
		_ColorBlendMap("Color Blend Map (Head)", 2D) = "gray" {}
		_ColorBlendStrength("Color Blend Strength", Range( 0 , 1)) = 0
		[Normal]_NormalBlendMap("Normal Blend Map (Head)", 2D) = "bump" {}
		_NormalBlendStrength("Normal Blend Strength (Head)", Range( 0 , 2)) = 0
		_MNAOMap("Cavity AO Map", 2D) = "white" {}
		_MouthCavityAO("Mouth Cavity AO", Range( 0 , 5)) = 2.5
		_NostrilCavityAO("Nostril Cavity AO", Range( 0 , 5)) = 2.5
		_LipsCavityAO("Lips Cavity AO", Range( 0 , 5)) = 2.5
		_CFULCMask("CFULCMask", 2D) = "black" {}
		_EarNeckMask("EarNeckMask", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local BOOLEAN_IS_HEAD_ON
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
			half3 Translucency;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalStrength;
		uniform sampler2D _NormalBlendMap;
		uniform float4 _NormalBlendMap_ST;
		uniform sampler2D _SSSMap;
		uniform float4 _SSSMap_ST;
		uniform float _SubsurfaceScale;
		uniform sampler2D _RGBAMask;
		uniform float4 _RGBAMask_ST;
		uniform float _RSmoothnessMod;
		uniform float _GSmoothnessMod;
		uniform float _BSmoothnessMod;
		uniform float _UnmaskedSmoothnessMod;
		uniform sampler2D _CFULCMask;
		uniform float4 _CFULCMask_ST;
		uniform sampler2D _EarNeckMask;
		uniform float4 _EarNeckMask_ST;
		uniform float _SubsurfaceNormalSoften;
		uniform float _NormalBlendStrength;
		uniform sampler2D _MicroNormalMap;
		uniform float _MicroNormalTiling;
		uniform float _MicroNormalStrength;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;
		uniform float4 _DiffuseColor;
		uniform sampler2D _DiffuseMap;
		uniform float4 _DiffuseMap_ST;
		uniform sampler2D _ColorBlendMap;
		uniform float4 _ColorBlendMap_ST;
		uniform float _ColorBlendStrength;
		uniform sampler2D _MNAOMap;
		uniform float4 _MNAOMap_ST;
		uniform float _MouthCavityAO;
		uniform float _NostrilCavityAO;
		uniform float _LipsCavityAO;
		uniform float4 _EmissiveColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _SmoothnessMin;
		uniform float _SmoothnessMax;
		uniform float _SmoothnessPower;
		uniform float _MicroSmoothnessMod;
		uniform float _AOStrength;
		uniform sampler2D _ThicknessMap;
		uniform float4 _ThicknessMap_ST;
		uniform float _ThicknessScale;
		uniform float4 _SubsurfaceFalloff;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform sampler2D _OpacityMask;
		uniform float4 _OpacityMask_ST;
		uniform float _Cutoff = 0.5;


		void SkinMask179( float4 In1, float4 Mod1, float4 Scatter1, float UMMS, float UMSS, out float SmoothnessMod, out float ScatterMask )
		{
			float mask = saturate(In1.r + In1.g + In1.b + In1.a);
			float unmask = 1.0 - mask;
			SmoothnessMod = dot(In1, Mod1) + (UMMS * unmask);
			ScatterMask = dot(In1, Scatter1) + (UMSS * unmask);
			return;
		}


		void HeadMask156( float4 In1, float4 In2, float4 In3, float4 Mod1, float4 Mod2, float4 Mod3, float4 Scatter1, float4 Scatter2, float4 Scatter3, float UMMS, float UMSS, out float SmoothnessMod, out float ScatterMask )
		{
			In3.zw = 0;
			float4 m = In1 + In2 + In3;
			float mask = saturate(m.x + m.y + m.z + m.w);
			float unmask = 1.0 - mask;
			SmoothnessMod = dot(In1, Mod1) + dot(In2, Mod2) + dot(In3, Mod3) + (UMMS * unmask);
			ScatterMask = dot(In1, Scatter1) + dot(In2, Scatter2) + dot(In3, Scatter3) + (UMSS * unmask);
			return;
		}


		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !defined(DIRECTIONAL)
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float2 uv_NormalBlendMap = i.uv_texcoord * _NormalBlendMap_ST.xy + _NormalBlendMap_ST.zw;
			float2 uv_SSSMap = i.uv_texcoord * _SSSMap_ST.xy + _SSSMap_ST.zw;
			float localSkinMask179 = ( 0.0 );
			float2 uv_RGBAMask = i.uv_texcoord * _RGBAMask_ST.xy + _RGBAMask_ST.zw;
			float4 tex2DNode123 = tex2D( _RGBAMask, uv_RGBAMask );
			float4 In1179 = tex2DNode123;
			float4 appendResult150 = (float4(_RSmoothnessMod , _GSmoothnessMod , _BSmoothnessMod , 0.0));
			float4 Mod1179 = appendResult150;
			float4 Scatter1179 = float4( 0,0,0,0 );
			float UMMS179 = _UnmaskedSmoothnessMod;
			float UMSS179 = 0.0;
			float SmoothnessMod179 = 0.0;
			float ScatterMask179 = 0.0;
			SkinMask179( In1179 , Mod1179 , Scatter1179 , UMMS179 , UMSS179 , SmoothnessMod179 , ScatterMask179 );
			float localHeadMask156 = ( 0.0 );
			float4 In1156 = tex2DNode123;
			float2 uv_CFULCMask = i.uv_texcoord * _CFULCMask_ST.xy + _CFULCMask_ST.zw;
			float4 In2156 = tex2D( _CFULCMask, uv_CFULCMask );
			float2 uv_EarNeckMask = i.uv_texcoord * _EarNeckMask_ST.xy + _EarNeckMask_ST.zw;
			float4 In3156 = tex2D( _EarNeckMask, uv_EarNeckMask );
			float4 Mod1156 = appendResult150;
			float4 Mod2156 = float4( 0,0,0,0 );
			float4 Mod3156 = float4( 0,0,0,0 );
			float4 Scatter1156 = float4( 0,0,0,0 );
			float4 Scatter2156 = float4( 0,0,0,0 );
			float4 Scatter3156 = float4( 0,0,0,0 );
			float UMMS156 = _UnmaskedSmoothnessMod;
			float UMSS156 = 0.0;
			float SmoothnessMod156 = 0.0;
			float ScatterMask156 = 0.0;
			HeadMask156( In1156 , In2156 , In3156 , Mod1156 , Mod2156 , Mod3156 , Scatter1156 , Scatter2156 , Scatter3156 , UMMS156 , UMSS156 , SmoothnessMod156 , ScatterMask156 );
			#ifdef BOOLEAN_IS_HEAD_ON
				float staticSwitch169 = ScatterMask156;
			#else
				float staticSwitch169 = ScatterMask179;
			#endif
			float microScatteringMultiplier277 = ( _SubsurfaceScale * staticSwitch169 );
			float temp_output_336_0 = saturate( ( tex2D( _SSSMap, uv_SSSMap ).g * microScatteringMultiplier277 ) );
			float subsurfaceFlattenNormals274 = saturate( ( 1.0 - ( temp_output_336_0 * temp_output_336_0 * _SubsurfaceNormalSoften ) ) );
			float2 temp_cast_4 = (_MicroNormalTiling).xx;
			float2 uv_TexCoord308 = i.uv_texcoord * temp_cast_4;
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			float4 tex2DNode32 = tex2D( _MaskMap, uv_MaskMap );
			float microNormalMask287 = tex2DNode32.b;
			o.Normal = BlendNormals( BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), _NormalStrength ) , UnpackScaleNormal( tex2D( _NormalBlendMap, uv_NormalBlendMap ), ( subsurfaceFlattenNormals274 * _NormalBlendStrength ) ) ) , UnpackScaleNormal( tex2D( _MicroNormalMap, uv_TexCoord308 ), ( _MicroNormalStrength * microNormalMask287 * subsurfaceFlattenNormals274 ) ) );
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			float4 temp_output_339_0 = ( _DiffuseColor * tex2D( _DiffuseMap, uv_DiffuseMap ) );
			float2 uv_ColorBlendMap = i.uv_texcoord * _ColorBlendMap_ST.xy + _ColorBlendMap_ST.zw;
			float4 blendOpSrc13 = tex2D( _ColorBlendMap, uv_ColorBlendMap );
			float4 blendOpDest13 = temp_output_339_0;
			float4 lerpBlendMode13 = lerp(blendOpDest13,(( blendOpDest13 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest13 ) * ( 1.0 - blendOpSrc13 ) ) : ( 2.0 * blendOpDest13 * blendOpSrc13 ) ),_ColorBlendStrength);
			float2 uv_MNAOMap = i.uv_texcoord * _MNAOMap_ST.xy + _MNAOMap_ST.zw;
			float4 tex2DNode196 = tex2D( _MNAOMap, uv_MNAOMap );
			float saferPower201 = abs( tex2DNode196.g );
			float saferPower202 = abs( tex2DNode196.b );
			float saferPower203 = abs( tex2DNode196.a );
			float cavityAO280 = ( pow( saferPower201 , _MouthCavityAO ) * pow( saferPower202 , _NostrilCavityAO ) * pow( saferPower203 , _LipsCavityAO ) );
			#ifdef BOOLEAN_IS_HEAD_ON
				float4 staticSwitch72 = ( ( saturate( lerpBlendMode13 )) * cavityAO280 );
			#else
				float4 staticSwitch72 = temp_output_339_0;
			#endif
			float4 baseColor266 = staticSwitch72;
			o.Albedo = baseColor266.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( _EmissiveColor * tex2D( _EmissionMap, uv_EmissionMap ) ).rgb;
			float metallicMap285 = tex2DNode32.r;
			o.Metallic = metallicMap285;
			float cavityMask295 = tex2DNode196.r;
			float saferPower39 = abs( ( 0.0 * cavityMask295 ) );
			float lerpResult41 = lerp( _SmoothnessMin , _SmoothnessMax , pow( saferPower39 , _SmoothnessPower ));
			#ifdef BOOLEAN_IS_HEAD_ON
				float staticSwitch170 = SmoothnessMod156;
			#else
				float staticSwitch170 = SmoothnessMod179;
			#endif
			float microSmoothnessMod276 = ( staticSwitch170 + _MicroSmoothnessMod );
			o.Smoothness = ( lerpResult41 + microSmoothnessMod276 );
			float ambientOcclusionMap286 = tex2DNode32.g;
			o.Occlusion = ( 1.0 - ( ( 1.0 - ambientOcclusionMap286 ) * _AOStrength ) );
			float2 uv_ThicknessMap = i.uv_texcoord * _ThicknessMap_ST.xy + _ThicknessMap_ST.zw;
			float4 temp_output_307_0 = ( baseColor266 * _SubsurfaceFalloff );
			o.Transmission = ( tex2D( _ThicknessMap, uv_ThicknessMap ).g * _ThicknessScale * temp_output_307_0 ).rgb;
			o.Translucency = ( temp_output_307_0 * ( temp_output_336_0 * 0.2 ) ).rgb;
			o.Alpha = 1;
			float2 uv_OpacityMask = i.uv_texcoord * _OpacityMask_ST.xy + _OpacityMask_ST.zw;
			float4 OpacityMask424 = tex2D( _OpacityMask, uv_OpacityMask );
			clip( OpacityMask424.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}