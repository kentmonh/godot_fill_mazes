using System;
using System.Numerics;
using System.Collections;
using System.Collections.Specialized;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CreateLevels
{

    public class Point
    {
        public int Row { get; set; }
		public int Column { get; set; }
		public Vector2 Pos { get; set; }
		public Dictionary<string, object>[] NextToPoints { get; set; }
		public bool IsVisited { get; set; }

		public Point(int rowArgument, int columnArgument)
		{
			Row = rowArgument;
			Column = columnArgument;
			Pos = new Vector2(rowArgument, columnArgument);

			Vector2[] directions = new Vector2[4];
			Vector2 right = new Vector2(0, 1);
			Vector2 down = new Vector2(-1, 0);
			Vector2 left = new Vector2(0, -1);
			Vector2 up = new Vector2(1, 0);
			directions[0] = right;
			directions[1] = down;
			directions[2] = left;
			directions[3] = up;

			NextToPoints = new Dictionary<string, object>[4];

			for (int i = 0; i < 4; i++)
            {
				NextToPoints[i] = new Dictionary<string, object>();
				NextToPoints[i].Add("direction", directions[i]);
				NextToPoints[i].Add("block", false);
			}

			IsVisited = false;
		}
	}
}
