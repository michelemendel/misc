using System;
using System.Windows.Forms;
using System.Drawing;

namespace Sky
{
	class MainForm : Form
	{
		private Atom[] atoms;
		private Constraint[] constraints;
		private Timer UpdateTimer;
		private Point MouseLocation = new Point(0, 0);

		private Collection_MouseButtons mouseButtons = new Collection_MouseButtons();
		private int AffectAtom = 0;

		private float gravity = 0.5F;
		private bool paused = false;

		private const int slices = 4;

		public MainForm()
		{
			CreateForm();
			CreateTimer();
			Restart();
		}
		private void Restart()
		{
			CreateWorld();
		}
		private void CreateWorld()
		{
			//int numberOfAtoms = 50;

			//float restLength = 10;
			//float stiffness = 1;
			//float damping = 0.9F;
			//float snap = 16;

			////Atoms
			//atoms = new Atom[numberOfAtoms];

			//for (int i = 0; i < numberOfAtoms; i++)
			//{
			//    atoms[i] = new Atom(new PointF(restLength * (i + 1), this.ClientSize.Height * 0.2F), new Vector(0, 0));
			//}

			////Constraints
			//constraints = new Constraint[numberOfAtoms - 1];

			//for (int i = 0; i < numberOfAtoms - 1; i++)
			//{
			//    constraints[i] = new Constraint(atoms[i], atoms[i + 1], restLength, stiffness, damping, snap);
			//}







			#region Box
			Point inset = new Point(150, 100);

			const int size = 5;
			const int spacing = 55;

			atoms = new Atom[size * size];

			for (int w = 0; w < size; w++)
			{
				for (int h = 0; h < size; h++)
				{
					atoms[(w * size) + h] =
						new Atom(new PointF
						(
							(w * spacing) + inset.X, (h * spacing) + inset.Y
						),
						new Vector(0, 0));
				}
			}

			const float stiffness = 2F;
			const float damping = 1.4F;
			const float breaking = 2.5F;

			float d_restlength = SMath.DiffBetween(new PointF(0, 0), new PointF(spacing, spacing));

			constraints = new Constraint[
				((size * size) - size) +
				((size * size) - size)
				+ ((size * size) - size - size) + 1
				+ ((size * size) - size - size) + 1];

			int indexInset = 0;

			//Vertical
			for (int w = 0; w < size; w++)
			{
				for (int h = 0; h < size - 1; h++)
				{
					constraints[((w * (size - 1)) + h)] =
							new Constraint
							(
								atoms[(w * size) + h],
								atoms[(w * size) + h + 1],
								spacing, stiffness, damping, breaking
							);
				}
			}

			indexInset += ((size * size) - size);
			//Horizontal

			for (int h = 0; h < size; h++)
			{
				for (int w = 0; w < size - 1; w++)
				{
					constraints[((h * (size - 1)) + w) + indexInset] =
							new Constraint
							(
								atoms[(h * (size - 1)) + w],
								atoms[((h * (size - 1)) + w) + size],
								spacing, stiffness, damping, breaking
							);
				}
			}

			indexInset += ((size * size) - size);

			//Diagional ->
			for (int w = 0; w < size - 1; w++)
			{
				for (int h = 0; h < size - 1; h++)
				{
					int index = (w * (size - 1)) + h + indexInset;
					constraints[index] =
							new Constraint
							(
								atoms[(w * (size)) + h],
								atoms[(w * (size)) + h + 1 + size],
								d_restlength, stiffness, damping, breaking
							);
				}
			}
			indexInset += ((size * size) - size - size);

			//Diagional <-
			for (int w = 0; w < size - 1; w++)
			{
				for (int h = 0; h < size - 1; h++)
				{
					int index = (w * (size - 1)) + h + indexInset;
					constraints[index] =
							new Constraint
							(
								atoms[(w * (size)) + h + 1],
								atoms[(w * (size)) + h + size],
								d_restlength, stiffness, damping, breaking
							);
				}
			}
			constraints[constraints.Length - 1] = new Constraint(
				atoms[(atoms.Length - 1) - size - 1],
				atoms[atoms.Length - 1],
				d_restlength, stiffness, damping, breaking);

			indexInset += ((size * size) - size - size);
			#endregion
		}
		private void CreateForm()
		{
			this.SetStyle(
				ControlStyles.AllPaintingInWmPaint |
				ControlStyles.UserPaint |
				ControlStyles.DoubleBuffer, true);

			this.BackColor = Color.FromArgb(200, 220, 240);
			this.FormBorderStyle = FormBorderStyle.None;
			this.Size = new Size(600, 600);
		}
		private void CreateTimer()
		{
			UpdateTimer = new Timer();
			UpdateTimer.Interval = 15;
			UpdateTimer.Tick += new EventHandler(UpdateTimer_Tick);
			UpdateTimer.Enabled = true;
		}
		private void UpdateTimer_Tick(object sender, EventArgs e)
		{
			UpdateWorld();
		}
		private void UpdateWorld()
		{
			const float updateLength = 1F / slices;

			for (int s = 0; s < slices; s++)
			{
				UpdateSlice_Input(updateLength);
				for (int i = 0; i < constraints.Length; i++) constraints[i].BreakCheck();
				
				if (!paused)
				{
					for (int i = 0; i < atoms.Length; i++)  atoms[i].Update(updateLength, gravity*updateLength);
					for (int i = 0; i < constraints.Length; i++) constraints[i].Update(updateLength);
				}
				CollisionDetection();
			}
			Invalidate();
		}
		private void UpdateSlice_Input(float updateLength)
		{
			if (mouseButtons.Contains(MouseButtons.Right))
			{
				if (!paused)
				{
					float angle = SMath.GetAngle(MouseLocation, atoms[AffectAtom].Location);
					float force = SMath.Sqrt(SMath.DiffBetween(MouseLocation, atoms[AffectAtom].Location)) * updateLength;
					PointF affect = SMath.GetMove(angle, force);
					atoms[AffectAtom].MoveVector.Move = new PointF
					(
						atoms[AffectAtom].MoveVector.Move.X + affect.X,
						atoms[AffectAtom].MoveVector.Move.Y + affect.Y

					);
				}
			}
			if (mouseButtons.Contains(MouseButtons.Left))
			{
				if (atoms.Length > AffectAtom)
				{
					atoms[AffectAtom].Location = MouseLocation;
					atoms[AffectAtom].MoveVector.Length = 0;
				}
			}
			if (mouseButtons.Contains(MouseButtons.Middle)) DeleteNearestAtom();
		}
		private void CollisionDetection()
		{
			float bounce_EnergyLoss = 0.85F;
			float slide_EnergyLoss = 0.9F;

			for (int i = 0; i < atoms.Length; i++)
			{
				if (atoms[i] == null) continue;

				const float pRadius = 0;
				float screenHeight = this.ClientRectangle.Height - pRadius;
				float screenWidth = this.ClientRectangle.Width - pRadius;
				const float screenX = pRadius;
				const float screenY = pRadius;

				if (atoms[i].MoveVector.Move_Y >= 0)
				{
					if (atoms[i].Location.Y > screenHeight)
					{
						atoms[i].MoveVector.Move_Y = -(atoms[i].MoveVector.Move_Y * bounce_EnergyLoss);
						atoms[i].MoveVector.Move_X *= slide_EnergyLoss;

						atoms[i].Location.Y = screenHeight;
					}
				}
				if (atoms[i].MoveVector.Move_Y <= 0)
				{
					if (atoms[i].Location.Y < screenY)
					{
						atoms[i].MoveVector.Move_Y = -(atoms[i].MoveVector.Move_Y * bounce_EnergyLoss);
						atoms[i].MoveVector.Move_X *= slide_EnergyLoss;

						atoms[i].Location.Y = screenY;
					}
				}

				if (atoms[i].MoveVector.Move_X >= 0)
				{
					if (atoms[i].Location.X > screenWidth)
					{
						atoms[i].MoveVector.Move_X = -(atoms[i].MoveVector.Move_X * bounce_EnergyLoss);
						atoms[i].MoveVector.Move_Y *= slide_EnergyLoss;

						atoms[i].Location.X = screenWidth;
					}
				}
				if (atoms[i].MoveVector.Move_X <= 0)
				{
					if (atoms[i].Location.X < screenX)
					{
						atoms[i].MoveVector.Move_X = -(atoms[i].MoveVector.Move_X * bounce_EnergyLoss);
						atoms[i].MoveVector.Move_Y *= slide_EnergyLoss;

						atoms[i].Location.X = screenX;
					}
				}
			}
		}
		private void DeleteNearestAtom()
		{
			for (int i = 0; i < constraints.Length; i++)
			{
				if (constraints[i].Atom_1 == atoms[AffectAtom]) constraints[i].Activated = false;
				else if (constraints[i].Atom_2 == atoms[AffectAtom]) constraints[i].Activated = false;
			}
		}
		private int GetNearestAtom(Point check)
		{
			Atom affect_Check = null;
			float indexDiff = float.PositiveInfinity;

			for (int i = 0; i < constraints.Length; i++)
			{
				if (!constraints[i].Activated) continue;

				//Atom 1
				Atom checkAtom = constraints[i].Atom_1;
				float diff = SMath.DiffBetween(checkAtom.Location, check);

				if (diff < indexDiff)
				{
					affect_Check = checkAtom;
					indexDiff = diff;
				}

				//Atom 2
				checkAtom = constraints[i].Atom_2;
				diff = SMath.DiffBetween(checkAtom.Location, check);

				if (diff < indexDiff)
				{
					affect_Check = checkAtom;
					indexDiff = diff;
				}
				
			}

			if (affect_Check != null)
			{
				for (int i = 0; i < atoms.Length; i++)
				{
					if (affect_Check == atoms[i])
					{
						return i;
					}
				}
			}
			else
			{
				int index = -1;
				indexDiff = float.PositiveInfinity;

				for (int i = 0; i < atoms.Length; i++)
				{
					float diff = SMath.DiffBetween(atoms[i].Location, check);

					if (diff < indexDiff)
					{
						index = i;
						indexDiff = diff;
					}
				}

				return index;
			}
			return -1;
		}
		protected override void OnPaint(PaintEventArgs e)
		{
			base.OnPaint(e);
			e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

			//Nearest Atom
			Pen nearestAtomPen = new Pen(Color.FromArgb(130, 160, 180), 4);
			nearestAtomPen.EndCap = System.Drawing.Drawing2D.LineCap.Round;
			nearestAtomPen.StartCap = System.Drawing.Drawing2D.LineCap.Round;

			e.Graphics.DrawLine(nearestAtomPen, MouseLocation,
			atoms[GetNearestAtom(MouseLocation)].Location);
			//End Nearest Atom

			Pen constraintPen = new Pen(Color.FromArgb(100, 130, 150), 2);

			for (int i = 0; i < constraints.Length; i++)
			{
				if (constraints[i].Activated)
				{
					float percentage = (constraints[i].CurrentDiff-constraints[i].RestLength) / constraints[i].MaxDiff;

					if (percentage < 0)
					{
						percentage = Math.Abs(constraints[i].CurrentDiff / constraints[i].RestLength);
						percentage = 1 - percentage;
					}

					float lineWidth = 1.4F + ((1 - percentage) * 0.6F);

					Color color = Color.FromArgb
						(
							(int)(percentage * 255),
							0,
							0
						);
					e.Graphics.DrawLine(
						new Pen(color, lineWidth),
						constraints[i].Atom_1.Location,
						constraints[i].Atom_2.Location);
				}
			}

			//Mouse Spring
			if (mouseButtons.Contains(MouseButtons.Right))
			{
				e.Graphics.DrawLine(
					new Pen(Color.FromArgb(200, 200, 0), 1F),
					MouseLocation,
					atoms[AffectAtom].Location);
			}

			//Atoms
			const float radius = 2;
			for (int i = 0; i < atoms.Length; i++)
			{
				e.Graphics.FillEllipse(Brushes.Yellow,
					atoms[i].Location.X - radius,
					atoms[i].Location.Y - radius,
					radius * 2,
					radius * 2);

				e.Graphics.DrawEllipse(
					new Pen(Color.Black, 1),
					atoms[i].Location.X - radius,
					atoms[i].Location.Y - radius,
					radius * 2,
					radius * 2);
			}
		}
		protected override void OnKeyDown(KeyEventArgs e)
		{
			base.OnKeyDown(e);

			if (e.KeyCode == Keys.P)
			{
				if (paused) paused = false;
				else paused = true;
			}
			if (e.KeyCode == Keys.O)
			{
				paused = false;
				UpdateWorld();
				paused = true;
			}
			if (e.KeyCode == Keys.F5) Restart();
			if (e.KeyCode == Keys.Escape) this.Close();
		}
		protected override void OnMouseMove(MouseEventArgs e)
		{
			base.OnMouseMove(e);

			MouseLocation = e.Location;
		}
		protected override void OnMouseDown(MouseEventArgs e)
		{
			base.OnMouseDown(e);

			AffectAtom = GetNearestAtom(e.Location);

			mouseButtons.Add(e.Button);
		}

		protected override void OnMouseWheel(MouseEventArgs e)
		{
			base.OnMouseWheel(e);

			AffectAtom = GetNearestAtom(e.Location);
			DeleteNearestAtom();
		}
		protected override void OnMouseUp(MouseEventArgs e)
		{
			base.OnMouseDown(e);

			mouseButtons.Remove(e.Button);
		}
		public static void Main()
		{
			MainForm mainForm = new MainForm();
			Application.Run(mainForm);
		}
	}
}
