Shader "Unlit/Checkerboard"
{
	Properties
	{
		_Length("Length", Float) = 0.1
		_Black("Black", Color) = (0, 0, 0, 1)
		_White("White", Color) = (1, 1, 1, 1)
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

			float _Length;
			float4 _Black;
			float4 _White;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				int x = floor(i.uv.x / _Length);
				int y = floor(i.uv.y / _Length);
				bool b = x % 2 == 0 ^ y % 2 == 0;
				return b ? _Black : _White;
			}
			ENDCG
		}
	}
}
