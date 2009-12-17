using System;
using System.Drawing;

namespace Sky
{
	class Constraint
	{
		public Constraint(Atom Atom_1, Atom Atom_2, float RestLength, float Stiffness, float Damping, float Break)
		{
			this.Atom_1 = Atom_1;
			this.Atom_2 = Atom_2;

			this.RestLength = RestLength;
			this.Stiffness = Stiffness;
			this.Damping = Damping;
			this.Snap = Break;
		}

		public Atom Atom_1;
		public Atom Atom_2;

		public float RestLength;
		public float Stiffness;
		public float Damping;
		public float Snap;
		public bool Activated = true;

		public float CurrentDiff = 0;
		public float MaxDiff
		{
			get
			{
				return RestLength * Snap;
			}
		}

		public void BreakCheck()
		{
			float diff = SMath.DiffBetween(Atom_1.Location, Atom_2.Location);

			if (diff > MaxDiff)
			{
				Activated = false;
			}
			else if (diff < (RestLength / Snap))
			{
				Activated = false;
			}
			CurrentDiff = diff;
		}
		//float max = 0;
		public void Update(float updateLength)
		{
			if (Activated == false) return;

			//float diff = (SMath.DiffBetween(Atom_1.Location, Atom_2.Location) - RestLength)*0.5F;

			//float angle = SMath.GetAngle(Atom_1.Location, Atom_2.Location);

			//float force = (SMath.Sqrt(diff) * Stiffness);

			//PointF affect = SMath.GetMove(angle, force);
			//Atom_1.MoveVector.Move = new PointF(
			//(Atom_1.MoveVector.Move.X - affect.X) * Damping,
			//(Atom_1.MoveVector.Move.Y - affect.Y) * Damping);

			//Atom_2.MoveVector.Move = new PointF(
			//(Atom_2.MoveVector.Move.X + affect.X) * Damping,
			//(Atom_2.MoveVector.Move.Y + affect.Y) * Damping);



			float angle = SMath.GetAngle(Atom_2.Location, Atom_1.Location);

			PointF relativePosition = new PointF
				(
					Atom_1.Location.X - Atom_2.Location.X,
					Atom_1.Location.Y - Atom_2.Location.Y
				);

			PointF relativeVelocity = new PointF(Atom_1.MoveVector.Move_X - Atom_2.MoveVector.Move_X, Atom_1.MoveVector.Move_Y - Atom_2.MoveVector.Move_Y);

			float springForce = Stiffness * (CurrentDiff - RestLength);

			float dampingForce = (Damping * (relativePosition.X * relativeVelocity.X + relativePosition.Y * relativeVelocity.Y)) / RestLength;

			float finalForce = (springForce + dampingForce) * 0.5F;

			PointF affect = SMath.GetMove(angle, finalForce);


			Atom_1.MoveVector.Move = new PointF(
			Atom_1.MoveVector.Move.X + (affect.X * updateLength),
			Atom_1.MoveVector.Move.Y + (affect.Y * updateLength));



			Atom_2.MoveVector.Move = new PointF(
			Atom_2.MoveVector.Move.X - (affect.X * updateLength),
			Atom_2.MoveVector.Move.Y - (affect.Y * updateLength));













			//float diff = SMath.DiffBetween(Atom_1.Location, Atom_2.Location);

			//diff -= RestLength;
			//diff *= 0.5F;

			//float angle = SMath.GetAngle(Atom_2.Location, Atom_1.Location);

			//float force = (float)(Math.Sqrt(Math.Abs(diff * Stiffness)) * Math.Sign(diff));

			////if (force < 0) force -= diff;
			////else force += diff;

			//force -= ((Math.Abs(Atom_1.MoveVector.Length) + Math.Abs(Atom_2.MoveVector.Length)) * (1-Damping))*Math.Sign(force);

			//PointF affect = SMath.GetMove(angle, force);

			////float vdamp = ((Math.Abs(Atom_1.MoveVector.Length) + Math.Abs(Atom_2.MoveVector.Length)) * (1-Damping))*Math.Sign(force);

			//Atom_1.MoveVector.Move_X *= Damping;
			//Atom_1.MoveVector.Move_Y *= Damping;

			//Atom_2.MoveVector.Move_X *= Damping;
			//Atom_2.MoveVector.Move_Y *= Damping;

			//Atom_1.MoveVector.Move = new PointF(
			//                                (Atom_1.MoveVector.Move.X + affect.X),
			//                                (Atom_1.MoveVector.Move.Y + affect.Y));

			//Atom_2.MoveVector.Move = new PointF(
			//                                (Atom_2.MoveVector.Move.X - affect.X),
			//                                (Atom_2.MoveVector.Move.Y - affect.Y));








			//force = (float)(Math.Exp(force * Stiffness));

			//force = 0;

			//PointF direction = new PointF((float)Math.Cos(angle*force), (float)Math.Sin(angle*force));


			//Atom_1.MoveVector.Move = new PointF(Atom_1.MoveVector.Move.X + direction.X,
			//                                Atom_1.MoveVector.Move.Y + direction.Y);

			//Atom_2.MoveVector.Move = new PointF(Atom_2.MoveVector.Move.X + -direction.X,
			//                                Atom_2.MoveVector.Move.Y + -direction.Y);


			////Atom_2.MoveVector.Add(new PointF(-direction.X,-direction.Y));

			//Atom_1.MoveVector.Angle = angle;
			//Atom_2.MoveVector.Angle = -angle;

			//if (diff > RestLength)
			//{
			//    //Atom_1.MoveVector.Angle = angle;
			//    //Atom_2.MoveVector.Angle = -angle;

			//    Atom_1.MoveVector.Length -= Stiffness;
			//    Atom_2.MoveVector.Length -= Stiffness;
			//}
			//else
			//{
			//    //Atom_1.MoveVector.Angle = -angle;
			//    //Atom_2.MoveVector.Angle = angle;

			//    Atom_1.MoveVector.Length += Stiffness;
			//    Atom_2.MoveVector.Length += Stiffness;
			//}

			//Console.WriteLine(Atom_1.MoveVector.Length.ToString());

		}
	}
}
