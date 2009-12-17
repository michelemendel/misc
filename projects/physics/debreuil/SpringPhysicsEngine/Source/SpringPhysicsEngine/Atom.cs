using System;
using System.Drawing;

namespace Sky
{
	class Atom : Mobile
	{
		public Atom(PointF Location, Vector MoveVector)
		{
			this.Location = Location;
			this.MoveVector = MoveVector;
		}

		public PointF Location;

		//public Constraint[] AttachedConstraints = new Constraint[0];

		////public int[] AttachedConstraints = new int[0];

		//public void AddConstraint(Constraint add)
		//{
		//    Constraint[] temp = AttachedConstraints;

		//    AttachedConstraints = new Constraint[AttachedConstraints.Length + 1];

		//    for (int i = 0; i < temp.Length; i++)
		//    {
		//        AttachedConstraints[i] = temp[i];
		//    }

		//    AttachedConstraints[AttachedConstraints.Length - 1] = add;
		//}

		//public void Remove(int remove)
		//{
		//    int index = -1;

		//    for (int i = 0; i < AttachedConstraints.Length; i++)
		//    {
		//        if (AttachedConstraints[i] == remove)
		//        {
		//            index = i;
		//            break;
		//        }
		//    }

		//    int[] temp = new int[AttachedConstraints.Length - 1];

		//    for (int i = 0; i < index; i++)
		//    {
		//        temp[i] = AttachedConstraints[i];
		//    }

		//    for (int i = 0; i < AttachedConstraints.Length-index-1; i++)
		//    {
		//        temp[index + i] = AttachedConstraints[index+i+1];
		//    }
		//}

		public void Update(float updateLength, float gravity)
		{
			MoveVector.Move_Y += gravity;
			Location.X += MoveVector.Move.X * updateLength;
			Location.Y += MoveVector.Move.Y * updateLength;
		}
	}
}
