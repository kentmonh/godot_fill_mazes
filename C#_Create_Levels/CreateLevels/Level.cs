using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateLevels
{
    public class Level
    {
		// Variables
		public int RowLength { get; set; }
		public int ColumnLength { get; set; }
		public int Distance { get; set; }

		public Level(int row, int column, int steps)
		{
			RowLength = row;
			ColumnLength = column;
			Distance = steps;
		}
	}
}
