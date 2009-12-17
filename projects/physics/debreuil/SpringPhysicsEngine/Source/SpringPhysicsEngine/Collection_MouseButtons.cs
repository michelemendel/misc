using System;
using System.Windows.Forms;

namespace Sky
{
	public class Collection_MouseButtons
	{
		public Collection_MouseButtons()
		{
			this.array = new MouseButtons[0];
		}

		public Collection_MouseButtons(MouseButtons[] array)
		{
			this.array = array;
		}

		public MouseButtons[] array = new MouseButtons[0];
		public bool containMultiples = false;

		public void Add(MouseButtons add)
		{
			if (containMultiples) if (Contains(add)) return;

			MouseButtons[] temp = array;

			array = new MouseButtons[temp.Length + 1];

			for (int i = 0; i < temp.Length; i++)
			{
				array[i] = temp[i];
			}
			array[array.Length - 1] = add;
		}
		public void Remove(MouseButtons remove)
		{
			int removeIndex = -1;
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] == remove)
				{
					removeIndex = i;
					break;
				}
			}
			if (removeIndex == -1) return;

			MouseButtons[] temp = array;
			array = new MouseButtons[temp.Length-1];

			for (int i = 0; i < removeIndex; i++)
			{
			    array[i] = temp[i];
			}

			for (int i = removeIndex; i < array.Length; i++)
			{
			    array[i] = temp[i+1];
			}
		}
		public bool Contains(MouseButtons contain)
		{
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] == contain) return true;
			}
			return false;
		}
	}
}
