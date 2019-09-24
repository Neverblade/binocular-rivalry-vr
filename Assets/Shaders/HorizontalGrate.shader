Shader "Unlit/HorizontalGrate"
{
	Properties
	{
		_Dark ("Dark Color", Color) = (0, 0, 0, 1)
		_Light ("Light Color", Color) = (1, 1, 1, 1)
		_SpatialPeriod ("Spatial Period", Float) = 0.25
		_TemporalPeriod ("Temporal Period", Float) = 2
		_On ("On", Int) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
						
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float4 _Dark;
			float4 _Light;
			float _SpatialPeriod;
			float _TemporalPeriod;
			uint _On;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				const float PI = 3.14159;
				float spatialPhase = i.uv.y / _SpatialPeriod * 2 * PI;
				float temporalPhase = _Time.y / _TemporalPeriod * 2 * PI;
				if (_On != 1) temporalPhase = 0;
				float param = (sin(spatialPhase - temporalPhase) + 1) / 2.0f;
				float4 c = _Dark * param + _Light * (1 - param);
				c.w = 1;
				return c;
			}
			ENDCG
		}
	}
}
