Shader "PyramisArts/BIRP/Human/Eyes Parallax 3D"
{
	Properties
	{
		_ScleraDiffuseMap("Sclera Diffuse Map", 2D) = "white" {}
		_ScleraScale("Sclera Scale", Range( 0.25 , 2)) = 1
		_ScleraHue("Sclera Hue", Range( 0 , 1)) = 0.5
		_ScleraSaturation("Sclera Saturation", Range( 0 , 2)) = 1
		_ScleraBrightness("Sclera Brightness", Range( 0 , 2)) = 1
		_ScleraSubsurfaceScale("Sclera Subsurface Scale", Range( 0 , 1)) = 0.5
		_SubsurfaceFalloff("Subsurface Falloff", Color) = (1,1,1,0)
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_ShadowRadius("Shadow Radius", Range( 0 , 0.5)) = 0.275
		_ShadowHardness("Shadow Hardness", Range( 0.01 , 0.99)) = 0.5
		_CornerShadowColor("Corner Shadow Color", Color) = (1,0.7333333,0.6980392,0)
		_IOR("Cornea IOR", Range( 1 , 2)) = 1.4
		_CorneaDiffuseMap("Cornea Diffuse Map", 2D) = "white" {}
		_IrisScale("Iris Scale", Range( 0 , 2)) = 1
		_IrisHue("Iris Hue", Range( 0 , 1)) = 0.5
		_IrisSaturation("Iris Saturation", Range( 0 , 2)) = 1
		_IrisBrightness("Iris Brightness", Range( 0 , 2)) = 1
		_IrisRadius("Iris Radius", Range( 0.01 , 0.2)) = 0.15
		_IrisColor("Iris Color", Color) = (0,0,0,0)
		_IrisCloudyColor("Iris Cloudy Color", Color) = (0,0,0,0)
		_IrisSubsurfaceScale("Iris Subsurface Scale", Range( 0 , 1)) = 0
		_IrisDepth("Iris Depth", Range( 0.1 , 1)) = 0.3
		_DepthRadius("Pupil Outer Radius", Range( 0 , 1)) = 0.8
		_PupilScale("Pupil Scale", Range( 0.1 , 2)) = 0.8
		_PMod("Parrallax Mod", Range( 0 , 10)) = 6.4
		_ParallaxRadius("Parallax Radius", Range( 0 , 0.16)) = 0.1175
		_LimbusWidth("Limbus Width", Range( 0.01 , 0.1)) = 0.055
		_LimbusDarkRadius("Limbus Dark Radius", Range( 0.01 , 0.2)) = 0.1
		_LimbusDarkWidth("Limbus Dark Width", Range( 0.01 , 0.2)) = 0.025
		_LimbusColor("Limbus Color", Color) = (0,0,0,0)
		_ColorBlendMap("Color Blend Map", 2D) = "white" {}
		_ColorBlendStrength("Color Blend Strength", Range( 0 , 1)) = 0.2
		_MaskMap("Mask Map", 2D) = "white" {}
		_AOStrength("Ambient Occlusion Strength", Range( 0 , 1)) = 0.2
		_ScleraSmoothness("Sclera Smoothness", Range( 0 , 1)) = 0.8
		_CorneaSmoothness("Cornea Smoothness", Range( 0 , 1)) = 1
		_ScleraNormalMap("Sclera Normal Map", 2D) = "bump" {}
		_ScleraNormalStrength("Sclera Normal Strength", Range( 0 , 1)) = 0.1
		_ScleraNormalTiling("Sclera Normal Tiling", Range( 1 , 10)) = 2
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		[Toggle]_IsLeftEye("Is Left Eye", Range( 0 , 1)) = 0
		[Toggle(BOOLEAN_ISCORNEA_ON)] BOOLEAN_ISCORNEA("IsCornea", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local BOOLEAN_ISCORNEA_ON
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
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
			half3 viewDir;
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
			half3 Translucency;
		};

		uniform half _IsLeftEye;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ScleraNormalMap);
		uniform half _ScleraNormalTiling;
		SamplerState sampler_ScleraNormalMap;
		uniform half _ScleraNormalStrength;
		uniform half _IrisRadius;
		uniform half _IrisScale;
		uniform half _LimbusWidth;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ColorBlendMap);
		uniform half4 _ColorBlendMap_ST;
		SamplerState sampler_ColorBlendMap;
		uniform half4 _LimbusColor;
		uniform half4 _IrisCloudyColor;
		uniform half _IrisHue;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CorneaDiffuseMap);
		uniform half _IrisDepth;
		uniform half _PupilScale;
		uniform half _DepthRadius;
		uniform half _IOR;
		uniform half _PMod;
		uniform half _ParallaxRadius;
		SamplerState sampler_CorneaDiffuseMap;
		uniform half4 _IrisColor;
		uniform half _IrisSaturation;
		uniform half _IrisBrightness;
		uniform half _LimbusDarkRadius;
		uniform half _LimbusDarkWidth;
		uniform half4 _CornerShadowColor;
		uniform half _ScleraHue;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ScleraDiffuseMap);
		uniform half _ScleraScale;
		SamplerState sampler_ScleraDiffuseMap;
		uniform half _ScleraSaturation;
		uniform half _ScleraBrightness;
		uniform half _ShadowHardness;
		uniform half _ShadowRadius;
		uniform half _ColorBlendStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionMap);
		uniform half4 _EmissionMap_ST;
		SamplerState sampler_EmissionMap;
		uniform half4 _EmissiveColor;
		uniform half _CorneaSmoothness;
		uniform half _ScleraSmoothness;
		uniform half _AOStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MaskMap);
		uniform half4 _MaskMap_ST;
		SamplerState sampler_MaskMap;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform half _IrisSubsurfaceScale;
		uniform half _ScleraSubsurfaceScale;
		uniform half4 _SubsurfaceFalloff;


		half3 HSVToRGB( half3 c )
		{
			half4 K = half4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			half3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		half3 RGBToHSV(half3 c)
		{
			half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			half4 p = lerp( half4( c.bg, K.wz ), half4( c.gb, K.xy ), step( c.b, c.g ) );
			half4 q = lerp( half4( p.xyw, c.r ), half4( c.r, p.yzx ), step( p.x, c.r ) );
			half d = q.x - min( q.w, q.y );
			half e = 1.0e-10;
			return half3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
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

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
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
			half2 temp_cast_0 = (_ScleraNormalTiling).xx;
			float2 uv_TexCoord294 = i.uv_texcoord * temp_cast_0;
			half scaledIrisRadius209 = ( _IrisRadius * _IrisScale );
			half irisScale208 = _IrisScale;
			half radial203 = length( ( i.uv_texcoord - float2( 0.5,0.5 ) ) );
			half smoothstepResult28 = smoothstep( ( scaledIrisRadius209 - ( irisScale208 * _LimbusWidth ) ) , scaledIrisRadius209 , radial203);
			half irisMask213 = smoothstepResult28;
			o.Normal = UnpackScaleNormal( SAMPLE_TEXTURE2D( _ScleraNormalMap, sampler_ScleraNormalMap, uv_TexCoord294 ), ( _ScleraNormalStrength * irisMask213 ) );
			float2 uv_ColorBlendMap = i.uv_texcoord * _ColorBlendMap_ST.xy + _ColorBlendMap_ST.zw;
			half irisDepth219 = _IrisDepth;
			half temp_output_1_0_g1 = ( _DepthRadius * scaledIrisRadius209 );
			half lerpResult83 = lerp( irisScale208 , ( irisScale208 * ( ( 0.333 / ( 0.333 + irisDepth219 ) ) * _PupilScale ) ) , saturate( ( ( radial203 - temp_output_1_0_g1 ) / ( 0.0 - temp_output_1_0_g1 ) ) ));
			half temp_output_88_0 = ( 1.0 / lerpResult83 );
			half2 temp_cast_1 = (temp_output_88_0).xx;
			half2 temp_cast_2 = (( ( 1.0 - temp_output_88_0 ) * 0.5 )).xx;
			float2 uv_TexCoord93 = i.uv_texcoord * temp_cast_1 + temp_cast_2;
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			half3 ase_worldTangent = WorldNormalVector( i, half3( 1, 0, 0 ) );
			half3 ase_worldBitangent = WorldNormalVector( i, half3( 0, 1, 0 ) );
			half3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			half3 normalizeResult117 = normalize( ( ( mul( ase_worldToTangent, ase_worldNormal ) * ( _IOR - 0.8 ) ) + i.viewDir ) );
			half temp_output_122_0 = ( 1.0 / ( ( _IrisDepth * _PMod ) + 0.91 ) );
			half temp_output_152_0 = ( irisScale208 * _ParallaxRadius );
			half saferPower157 = abs( saturate( ( ( temp_output_152_0 - radial203 ) / temp_output_152_0 ) ) );
			half2 lerpResult136 = lerp( uv_TexCoord93 , (( uv_TexCoord93 - ( (normalizeResult117).xy * _IrisDepth ) )*temp_output_122_0 + ( ( 1.0 - temp_output_122_0 ) * 0.5 )) , pow( saferPower157 , 0.25 ));
			half3 hsvTorgb174 = RGBToHSV( ( SAMPLE_TEXTURE2D( _CorneaDiffuseMap, sampler_CorneaDiffuseMap, lerpResult136 ) * _IrisColor ).rgb );
			half3 hsvTorgb184 = HSVToRGB( half3(( ( _IrisHue - 0.5 ) + hsvTorgb174.x ),( hsvTorgb174.y * _IrisSaturation ),( hsvTorgb174.z * _IrisBrightness )) );
			half4 blendOpSrc201 = _LimbusColor;
			half4 blendOpDest201 = ( ( _IrisCloudyColor * float4( 0.5,0.5,0.5,1 ) ) + half4( hsvTorgb184 , 0.0 ) );
			half temp_output_193_0 = ( _LimbusDarkRadius * irisScale208 );
			half smoothstepResult196 = smoothstep( temp_output_193_0 , ( temp_output_193_0 + ( irisScale208 * _LimbusDarkWidth ) ) , radial203);
			half4 lerpBlendMode201 = lerp(blendOpDest201,( blendOpSrc201 * blendOpDest201 ),smoothstepResult196);
			half temp_output_223_0 = ( 1.0 / _ScleraScale );
			half2 temp_cast_5 = (temp_output_223_0).xx;
			half2 temp_cast_6 = (( ( 1.0 - temp_output_223_0 ) * 0.5 )).xx;
			float2 uv_TexCoord228 = i.uv_texcoord * temp_cast_5 + temp_cast_6;
			half3 hsvTorgb231 = RGBToHSV( SAMPLE_TEXTURE2D( _ScleraDiffuseMap, sampler_ScleraDiffuseMap, uv_TexCoord228 ).rgb );
			half3 hsvTorgb232 = HSVToRGB( half3(( ( _ScleraHue - 0.5 ) + hsvTorgb231.x ),( hsvTorgb231.y * _ScleraSaturation ),( hsvTorgb231.z * _ScleraBrightness )) );
			half4 blendOpSrc23 = _CornerShadowColor;
			half4 blendOpDest23 = half4( hsvTorgb232 , 0.0 );
			half temp_output_247_0 = ( _ScleraScale * _ShadowRadius );
			half temp_output_1_0_g13 = ( ( _ShadowHardness * _ScleraScale ) * temp_output_247_0 );
			half4 lerpBlendMode23 = lerp(blendOpDest23,( blendOpSrc23 * blendOpDest23 ),saturate( ( ( radial203 - temp_output_1_0_g13 ) / ( temp_output_247_0 - temp_output_1_0_g13 ) ) ));
			half4 lerpResult261 = lerp( ( saturate( lerpBlendMode201 )) , ( saturate( lerpBlendMode23 )) , irisMask213);
			half4 blendOpSrc21 = SAMPLE_TEXTURE2D( _ColorBlendMap, sampler_ColorBlendMap, uv_ColorBlendMap );
			half4 blendOpDest21 = lerpResult261;
			half4 lerpBlendMode21 = lerp(blendOpDest21,( blendOpSrc21 * blendOpDest21 ),_ColorBlendStrength);
			half4 temp_output_21_0 = ( saturate( lerpBlendMode21 ));
			o.Albedo = temp_output_21_0.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( SAMPLE_TEXTURE2D( _EmissionMap, sampler_EmissionMap, uv_EmissionMap ) * _EmissiveColor ).rgb;
			half lerpResult271 = lerp( _CorneaSmoothness , _ScleraSmoothness , irisMask213);
			o.Smoothness = lerpResult271;
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			o.Occlusion = ( 1.0 - ( _AOStrength * ( 1.0 - SAMPLE_TEXTURE2D( _MaskMap, sampler_MaskMap, uv_MaskMap ).g ) ) );
			half lerpResult315 = lerp( _IrisSubsurfaceScale , _ScleraSubsurfaceScale , irisMask213);
			half4 baseColor370 = temp_output_21_0;
			o.Translucency = ( lerpResult315 * 0.5 * ( _SubsurfaceFalloff * baseColor370 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom keepalpha fullforwardshadows exclude_path:deferred 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}