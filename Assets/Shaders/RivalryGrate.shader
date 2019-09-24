Shader "Unlit/RivalryGrate"
{
	Properties
	{
		_DarkRadial ("Dark Color", Color) = (0, 0, 0, 1)
		_LightRadial ("Light Color", Color) = (1, 1, 1, 1)
		_PeriodRadial ("Period", Float) = 2
		_LengthRadial ("Length", Float) = 0.1

		_DarkHorizontal ("Dark Color", Color) = (0, 0, 0, 1)
		_LightHorizontal ("Light Color", Color) = (1, 1, 1, 1)
		_SpatialPeriodHorizontal ("Spatial Period", Float) = 0.25
		_TemporalPeriodHorizontal ("Temporal Period", Float) = 2

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

			int RenderingEye;

			float4 _DarkRadial;
			float4 _LightRadial;
			float _PeriodRadial;
			float _LengthRadial;

			float4 _DarkHorizontal;
			float4 _LightHorizontal;
			float _SpatialPeriodHorizontal;
			float _TemporalPeriodHorizontal;

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
				if (RenderingEye == 0) {
					const float PI = 3.14159;
					const float sixth = PI / 3.0;
					const float2 v2 = float2(1, 0);

					float2 v1 = i.uv.xy - float2(0.5, 0.5);
				
					// Determine which layer the coord is in
					uint layer = floor(length(v1) / _LengthRadial);
					bool layerBool = layer % 2 == 0;

					// Determine which sextant the coord is in
					float angle = acos(dot(normalize(v1), v2));
					if (cross(float3(v1, 0), float3(v2, 0)).z < 0) angle = 2 * PI - angle;
					uint sextant = floor(angle / sixth);
					bool sextantBool = sextant % 2 == 0;

					bool b = layerBool ^ sextantBool;
					float param = _Time.y % _PeriodRadial / _PeriodRadial;
					if (_Time.y % (2 * _PeriodRadial) > _PeriodRadial) param = 1 - param;
					return b ? _DarkRadial * param + _LightRadial * (1 - param) : _LightRadial * param + _DarkRadial * (1 - param);
				} else {
					const float PI = 3.14159;
					float spatialPhase = i.uv.y / _SpatialPeriodHorizontal * 2 * PI;
					float temporalPhase = _Time.y / _TemporalPeriodHorizontal * 2 * PI;
					if (_On != 1) temporalPhase = 0;
					float param = (sin(spatialPhase - temporalPhase) + 1) / 2.0f;
					float4 c = _DarkHorizontal * param + _LightHorizontal * (1 - param);
					c.w = 1;
					return c;
				}
			}
			ENDCG
		}
	}
}
