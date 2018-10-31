﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ItemIcon Shadow_Alpha_ETC1"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_AlphaTex ("Alpha",2D) = "white" {}
		_ShadowColor("shadowColor", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1

			Blend one OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			};


			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			float  _XOffset;
			float  _YOffset;
			fixed4 _ShadowColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.uv = TRANSFORM_TEX(v.uv, _AlphaTex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex_col = tex2D(_AlphaTex, i.uv);
			    float alpha =tex_col.g*_ShadowColor.a*_ShadowColor.a;
			    return fixed4(_ShadowColor.rgb*tex_col.g*_ShadowColor.a*i.color.a,alpha*i.color.a);
			}
			ENDCG
		}

		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend One OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _MainTex_ST;
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				half4 col;
				col = tex2D(_MainTex, IN.texcoord);
				col.a = tex2D(_AlphaTex, IN.texcoord).r;
				col = col * IN.color;
				return fixed4(col.rgb*col.a,col.a);
			}
			ENDCG
		}
	}
}


//Shader "Unlit/ItemIcon Shadow_Alpha_ETC1"
//{
//	Properties
//	{
//		_MainTex ("Base (RGB)", 2D) = "black" {}
//		_AlphaTex ("Alpha",2D) = "white" {}
//		_ShadowTex("shadow",2D) = "black" {}
//		_ShadowColor("shadowColor", Color) = (1,1,1,1)
//	}
//	
//	SubShader
//	{
//		LOD 200
//
//		Tags
//		{
//			"Queue" = "Transparent"
//			"IgnoreProjector" = "True"
//			"RenderType" = "Transparent"
//		}
//		Pass
//		{
//			Cull Off
//			Lighting Off
//			ZWrite Off
//			Fog { Mode Off }
//			Offset -1, -1
//			Blend one OneMinusSrcAlpha
//
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag			
//			#include "UnityCG.cginc"
//
//			sampler2D _MainTex;
//			sampler2D _ShadowTex;
//			sampler2D _AlphaTex;
//			float4 _MainTex_ST;
//	        fixed4 _ShadowColor;
//			struct appdata_t
//			{
//				float4 vertex : POSITION;
//				float2 texcoord : TEXCOORD0;
//				fixed4 color : COLOR;
//			};
//	
//			struct v2f
//			{
//				float4 vertex : SV_POSITION;
//				half2 texcoord : TEXCOORD0;
//				fixed4 color : COLOR;
//			};
//	
//			v2f o;
//
//			v2f vert (appdata_t v)
//			{
//				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
//				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
//				o.color = v.color;
//				return o;
//			}
//				
//			fixed4 frag (v2f IN) : COLOR
//			{
//				half4 col;
//				col = tex2D(_MainTex, IN.texcoord);
//				col.a = tex2D(_AlphaTex, IN.texcoord).r;
//				col = col * IN.color;
//				fixed4 outcolor;
//			
//				fixed4 shadow_tex = tex2D(_ShadowTex,IN.texcoord);
//				fixed shadow_a = shadow_tex.r;
//
//				fixed4 backgroud = shadow_a * _ShadowColor ;
//
//				fixed3 outrgb = col.rgb*col.a +(1-col.a)*backgroud.rgb;
//				fixed outa = 1-(1-col.a )*(1-backgroud.a);
//				outcolor = fixed4(outrgb,outa);
//
//				return outcolor;
//			}
//			ENDCG
//		}
//	}
//}
