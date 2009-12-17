using System;
using System.Drawing;

namespace Sky
{
	static class SMath
	{
		public static float DiffBetween(PointF Point1, PointF Point2)
		{
			PointF diff = new PointF
					(
						Point1.X - Point2.X,
						Point1.Y - Point2.Y
					);
			return (float)(System.Math.Sqrt((diff.X * diff.X) + (diff.Y * diff.Y)));
		}

		public static float GetAngle(PointF Point1, PointF Point2)
		{
			PointF diff = new PointF
					(
						Point1.X - Point2.X,
						Point1.Y - Point2.Y
					);

			return (float)Math.Atan2(diff.Y, diff.X);
		}

		public static float Sqrt(float calcuate)
		{
			return (float)( Math.Sqrt(Math.Abs(calcuate)) * Math.Sign(calcuate) );
		}

		public static PointF GetMove(float angle)
		{
			return GetMove(angle, 1);
		}

		public static PointF GetMove(float angle, float multiply)
		{
			return new PointF((float)Math.Cos(angle) * multiply,
								(float)Math.Sin(angle) * multiply);
		}

		
		public const float PI2 = (float)(Math.PI * 2);
		public const float PI = (float)(Math.PI);
	}
}
