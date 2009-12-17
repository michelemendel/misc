using System;
using System.Drawing;

namespace Sky
{
	public class Vector
	{
		public Vector()
		{
			move = new PointF(0, 0);
		}
		public Vector(float angle, float length)
		{
			this.Length = length;
			this.Angle = angle;
		}

		float angle = 0;
		float length = 0;

		PointF move;

		public float Move_X
		{
			get
			{
				return move.X;
			}
			set
			{
				Move = new PointF(value, move.Y);
			}
		}
		public float Move_Y
		{
			get
			{
				return move.Y;
			}
			set
			{
				Move = new PointF(move.X, value);
			}
		}

		public PointF Move
		{
			get
			{
				return move;
			}
			set
			{
				move = value;
				CalcuateAngle();
			}
		}

		public float Angle
		{
			get
			{
				return angle;
			}
			set
			{
				angle = value;

				if (angle >= SMath.PI2) angle %= SMath.PI2;
				else
				{
				    if (angle < 0)
				    {
						angle /= SMath.PI2;
						angle -= (float)Math.Floor(angle);
						angle *= SMath.PI2;
				    }
				}

				CalcuateMove();
			}
		}
		public float Length
		{
			get
			{
				return length;
			}
			set
			{
				CalcuateMove_Speed(value);
				length = value;
			}
		}

		private void CalcuateMove()
		{
			move = SMath.GetMove(angle, length);
		}
		private void CalcuateMove_Speed(float setSpeed)
		{
			float change = length / setSpeed;

			if (setSpeed == 0)
			{
				move = new PointF(0, 0);
			}
			else if(length == 0)
			{
				CalcuateMove();

				change = setSpeed;
			}
			else
			{
				move = new PointF
				(
					move.X * change,
					move.Y * change
				);
			}
		}
		private void CalcuateAngle()
		{
			this.angle = SMath.GetAngle(new PointF(0,0), move);
		}
	}
}
