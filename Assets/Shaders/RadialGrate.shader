Shader "Unlit/RadialGrate"
{
	Properties
	{
		_Dark ("Dark Color", Color) = (0, 0, 0, 1)
		_Light ("Light Color", Color) = (1, 1, 1, 1)
		_Period ("Period", Float) = 2
		_Length ("Length", Float) = 0.1
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
			float _Period;
			float _Length;
			
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
				const float sixth = PI / 3.0;
				const float2 v2 = float2(1, 0);

				float2 v1 = i.uv.xy - float2(0.5, 0.5);
				
				// Determine which layer the coord is in
				uint layer = floor(length(v1) / _Length);
				bool layerBool = layer % 2 == 0;

				// Determine which sextant the coord is in
				float angle = acos(dot(normalize(v1), v2));
				if (cross(float3(v1, 0), float3(v2, 0)).z < 0) angle = 2 * PI - angle;
				uint sextant = floor(angle / sixth);
				bool sextantBool = sextant % 2 == 0;

				bool b = layerBool ^ sextantBool;
				float param = _Time.y % _Period / _Period;
				if (_Time.y % (2 * _Period) > _Period) param = 1 - param;
				return b ? _Dark * param + _Light * (1 - param) : _Light * param + _Dark * (1 - param);
			}
			ENDCG
		}
	}
}
