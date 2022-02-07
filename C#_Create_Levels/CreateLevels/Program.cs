using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace CreateLevels
{
    public class Program
    {
        // Variables for all level
        private static String FilePath { get; set; }
        private static Level Level { get; set; }
        private static List<Point[]> AllPaths { get; set; }

        // Variables for each new start point
        private static Stack<Point> PathStack { get; set; }
        private static bool[][] MatrixVisited { get; set; }
        private static List<Stack<Point>> PathsInStart { get; set; }
        private static List<int> DuplicatedPositions { get; set; }


        // Init level
        private static void InitLevel()
        {
            // For all the level (many paths in levels)
            Level = new Level(5, 5, 24);
            FilePath = "5_5_24.txt";
            AllPaths = new List<Point[]>();
        }

        // Check a move is valid or not
        private static bool ValidMove(Point nextPoint)
        {
            if (nextPoint.Row >= 0 && nextPoint.Row < Level.RowLength
                && nextPoint.Column >= 0 && nextPoint.Column < Level.ColumnLength
                && MatrixVisited[nextPoint.Row][nextPoint.Column] == false)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        // Check 2 path stack have same content or not
        private static bool CheckSameStack(Point[] stackArray1, Point[] stackArray2)
        {
            foreach (Point point1 in stackArray1)
            {
                for (int i = 0; i < stackArray2.Length; i++)
                {
                    if (point1.Pos == stackArray2[i].Pos)
                    {
                        break;
                    }
                    else
                    {
                        if (i == stackArray2.Length - 1)
                        {
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        // Init matrix for each different start point
        private static bool[][] InitMatrix()
        {
            bool[][] matrix = new bool[Level.RowLength][];
            for (int i = 0; i < Level.RowLength; i++)
            {
                matrix[i] = new bool[Level.ColumnLength];
                for (int j = 0; j < Level.ColumnLength; j++)
                {
                    matrix[i][j] = false;
                }
            }
            return matrix;
        }

        // New start in next point
        private static void Start(int row, int column)
        {
            // Set start point
            MatrixVisited = InitMatrix();
            PathStack = new Stack<Point>();
            PathsInStart = new List<Stack<Point>>();
            DuplicatedPositions = new List<int>();

            Point start = new Point(row, column);
            PathStack.Push(start);
            MatrixVisited[row][column] = true;
            SAW(row, column);
        }

        private static void SAW(int row, int column)
        {
            Random rand = new Random();
            // Find paths
            while (PathStack.Count > 0)
            {
                if (PathStack.Count < Level.Distance)
                {
                    Move();
                }
                else if (PathStack.Count == Level.Distance)
                {
                    FoundPath(row, column);
                    Backtracking();
                }
            }

            // Delete paths which there are more than 1 way to finish
            DuplicatedPositions.Sort();
            for (int i = DuplicatedPositions.Count - 1; i >= 0; i--)
            {
                PathsInStart.RemoveAt(DuplicatedPositions[i]);
            }

            #region BeforeMoveToNextStartPoint
            foreach (Stack<Point> singlePathsInStart in PathsInStart)
            {
                // Check duplicated
                bool isDuplicated = false;
                Point[] singlePathsInStartArray = singlePathsInStart.ToArray();
                
                if (Level.RowLength == Level.ColumnLength)
                {
                    foreach (Point[] singleAllPaths in AllPaths)
                    {
                        if (CheckSameStack(singlePathsInStartArray, singleAllPaths) == true)
                        {
                            isDuplicated = true;
                            break;
                        }
                        else
                        {
                            Point[] singlePathsInStartArray90 = Rotate90(singlePathsInStartArray);
                            if (CheckSameStack(singlePathsInStartArray90, singleAllPaths) == true)
                            {
                                isDuplicated = true;
                                break;
                            }
                            else
                            {
                                Point[] singlePathsInStartArray180 = Rotate180(singlePathsInStartArray);
                                if (CheckSameStack(singlePathsInStartArray180, singleAllPaths) == true)
                                {
                                    isDuplicated = true;
                                    break;
                                }
                                else
                                {
                                    Point[] singlePathsInStartArray270 = Rotate270(singlePathsInStartArray);
                                    if (CheckSameStack(singlePathsInStartArray270, singleAllPaths) == true)
                                    {
                                        isDuplicated = true;
                                        break;
                                    }
                                    else
                                    {
                                        Point[] singlePathsInStartArrayFlip = Flip(singlePathsInStartArray);
                                        if (CheckSameStack(singlePathsInStartArrayFlip, singleAllPaths) == true)
                                        {
                                            isDuplicated = true;
                                            break;
                                        }
                                        else
                                        {
                                            Point[] singlePathsInStartArray90Flip = Flip(singlePathsInStartArray90);
                                            if (CheckSameStack(singlePathsInStartArray90Flip, singleAllPaths) == true)
                                            {
                                                isDuplicated = true;
                                                break;
                                            }
                                            else
                                            {
                                                Point[] singlePathsInStartArray180Flip = Flip(singlePathsInStartArray180);
                                                if (CheckSameStack(singlePathsInStartArray180Flip, singleAllPaths) == true)
                                                {
                                                    isDuplicated = true;
                                                    break;
                                                }
                                                else
                                                {
                                                    Point[] singlePathsInStartArray270Flip = Flip(singlePathsInStartArray270);
                                                    if (CheckSameStack(singlePathsInStartArray270Flip, singleAllPaths) == true)
                                                    {
                                                        isDuplicated = true;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (isDuplicated == false)
                    {
                        AllPaths.Add(singlePathsInStartArray);
                        int randomRotate = rand.Next(8);
                        switch (randomRotate)
                        {
                            case 0:
                                break;
                            case 1:
                                singlePathsInStartArray = Rotate90(singlePathsInStartArray);
                                break;
                            case 2:
                                singlePathsInStartArray = Rotate180(singlePathsInStartArray);
                                break;
                            case 3:
                                singlePathsInStartArray = Rotate270(singlePathsInStartArray);
                                break;
                            case 4:
                                singlePathsInStartArray = Flip(singlePathsInStartArray);
                                break;
                            case 5:
                                singlePathsInStartArray = Flip(Rotate90(singlePathsInStartArray));
                                break;
                            case 6:
                                singlePathsInStartArray = Flip(Rotate180(singlePathsInStartArray));
                                break;
                            case 7:
                                singlePathsInStartArray = Flip(Rotate270(singlePathsInStartArray));
                                break;
                        }
                        foreach (Point point in singlePathsInStartArray)
                        {
                            FileWrite(FilePath, point.Pos.ToString());
                        }
                        FileWriteLine(FilePath);
                    }
                }

                else
                {
                    foreach (Point[] singleAllPaths in AllPaths)
                    {
                        if (CheckSameStack(singlePathsInStartArray, singleAllPaths) == true)
                        {
                            isDuplicated = true;
                            break;
                        }
                        else
                        {
                            Point[] singlePathsInStartArray180 = Rotate180(singlePathsInStartArray);
                            if (CheckSameStack(singlePathsInStartArray180, singleAllPaths) == true)
                            {
                                isDuplicated = true;
                                break;
                            }
                            else
                            {
                                Point[] singlePathsInStartArrayFlip = Flip(singlePathsInStartArray);
                                if (CheckSameStack(singlePathsInStartArrayFlip, singleAllPaths) == true)
                                {
                                    isDuplicated = true;
                                    break;
                                }
                                else
                                {
                                    Point[] singlePathsInStartArray180Flip = Flip(singlePathsInStartArray180);
                                    if (CheckSameStack(singlePathsInStartArray180Flip, singleAllPaths) == true)
                                    {
                                        isDuplicated = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    if (isDuplicated == false)
                    {
                        AllPaths.Add(singlePathsInStartArray);
                        int randomRotate = rand.Next(4);
                        switch (randomRotate)
                        {
                            case 0:
                                break;
                            case 1:
                                singlePathsInStartArray = Rotate180(singlePathsInStartArray);
                                break;
                            case 2:
                                singlePathsInStartArray = Flip(singlePathsInStartArray);
                                break;
                            case 3:
                                singlePathsInStartArray = Flip(Rotate180(singlePathsInStartArray));
                                break;
                        }
                        foreach (Point point in singlePathsInStartArray)
                        {
                            FileWrite(FilePath, point.Pos.ToString());
                        }
                        FileWriteLine(FilePath);
                    }
                }    
            }
            #endregion

            //for (int i = 0; i < PathsInStart.Count; i++)
            //{
            //    foreach (Point point in PathsInStart[i])
            //    {
            //        Console.Write(point.Pos);
            //    }
            //    Console.WriteLine();
            //}
        }

        private static void Move()
        {
            int directionChecked = 0;
            // Last point of stack
            Point point = PathStack.Peek();

            // Check neibours points
            foreach (Dictionary<string, object> direction in point.NextToPoints)
            {
                if ((bool)direction["block"] == false)
                {
                    Vector2 newPosition = point.Pos + (Vector2)direction["direction"];
                    Point nextPoint = new Point(Convert.ToInt32(newPosition.X), Convert.ToInt32(newPosition.Y));

                    if (ValidMove(nextPoint) == true)
                    {
                        PathStack.Push(nextPoint);
                        MatrixVisited[nextPoint.Row][nextPoint.Column] = true;
                        break;
                    }
                    else
                    {
                        directionChecked += 1;
                    }
                }
                else
                {
                    directionChecked += 1;
                }
            }

            // No more way and do not finish yet, comeback
            if (directionChecked == 4)
            {
                Backtracking();
            }
        }

        private static void FoundPath(int row, int column)
        {
            // Check duplicated
            bool isDuplicated = false;

            Point[] cloneArray = PathStack.ToArray();
            for (int i = 0; i < PathsInStart.Count; i++)
            {
                Point[] cloneArrayInUniquePaths = PathsInStart[i].ToArray();
                if (CheckSameStack(cloneArray, cloneArrayInUniquePaths) == true)
                {
                    isDuplicated = true;
                    if (DuplicatedPositions.Contains(i) == false)
                    {
                        DuplicatedPositions.Add(i);
                    }
                    break;
                }
            }

            if (isDuplicated == false)
            {
                Stack<Point> clonePathStack = new Stack<Point>(PathStack);
                PathsInStart.Add(clonePathStack);
                Console.WriteLine("{0}-{1}  -  {2}", row, column, PathsInStart.Count);
            }
        }

        private static void Backtracking()
        {
            // Pop the last point
            Point popPoint = PathStack.Pop();
            MatrixVisited[popPoint.Row][popPoint.Column] = false;

            if (PathStack.Count > 0)
            {
                // Block the direction to popPoint
                Point lastPoint = PathStack.Peek();
                Vector2 blockDirection = popPoint.Pos - lastPoint.Pos;
                foreach (Dictionary<string, object> direction in lastPoint.NextToPoints)
                {
                    if ((Vector2)direction["direction"] == blockDirection)
                    {
                        direction["block"] = true;
                        break;
                    }
                }

                // Unblock all directions of pop point
                foreach (Dictionary<string, object> direction in popPoint.NextToPoints)
                {
                    direction["block"] = false;
                }
            }
        }

        #region Rotate
        private static Point[] Rotate90(Point[] originalArray)
        {
            if (Level.RowLength == Level.ColumnLength)
            {
                Point[] rotatedArray = new Point[originalArray.Length];
                for (int i = 0; i < rotatedArray.Length; i++)
                {
                    rotatedArray[i] = new Point(originalArray[i].Column, Level.RowLength - 1 - originalArray[i].Row);
                }
                return rotatedArray;
            }
            else
            {
                throw new Exception("Level.RowLength != Level.ColumnLength. Can't Rotate 90.");
            }
        }

        private static Point[] Rotate270(Point[] originalArray)
        {
            if (Level.RowLength == Level.ColumnLength)
            {
                Point[] rotatedArray = new Point[originalArray.Length];
                for (int i = 0; i < rotatedArray.Length; i++)
                {
                    rotatedArray[i] = new Point(Level.RowLength - 1 - originalArray[i].Column, originalArray[i].Row);
                }
                return rotatedArray;
            }
            else
            {
                throw new Exception("Level.RowLength != Level.ColumnLength. Can't Rotate 270.");
            }
        }

        private static Point[] Rotate180(Point[] originalArray)
        {
            Point[] rotatedArray = new Point[originalArray.Length];
            for (int i = 0; i < rotatedArray.Length; i++)
            {
                rotatedArray[i] = new Point(Level.RowLength - 1 - originalArray[i].Row, Level.ColumnLength - 1 - originalArray[i].Column);
            }
            return rotatedArray;
        }
        #endregion

        // Flip horizontal axis
        #region Flip
        private static Point[] Flip(Point[] originalArray)
        {
            Point[] rotatedArray = new Point[originalArray.Length];
            for (int i = 0; i < rotatedArray.Length; i++)
            {
                rotatedArray[i] = new Point(originalArray[i].Row, Level.ColumnLength - 1 - originalArray[i].Column);
            }
            return rotatedArray;
        }
        #endregion


        public static void Main(string[] args)
        {
            InitLevel();

            int rowCheck = (Level.RowLength - 1) / 2 + 1;
            int columnCheck = (Level.ColumnLength - 1) / 2 + 1;

            for (int i = 0; i < rowCheck; i++)
            {
                for (int j = 0; j < columnCheck; j++)
                {
                    Start(i, j);
                }
            }

            Console.WriteLine("Done. All paths is {0}", AllPaths.Count);

            #region CreateArrayToTest
            //Point[] originalArray = new Point[] { new Point(0, 0), new Point(1, 0), new Point(2, 0), new Point(3, 0),
            //    new Point(0, 1), new Point(1, 1), new Point(2, 1), new Point(3, 1),
            //    new Point(0, 2), new Point(1, 2), new Point(2, 2), new Point(3, 2),
            //    new Point(0, 3), new Point(1, 3), new Point(2, 3), new Point(3, 3),
            //    new Point(0, 4), new Point(1, 4), new Point(2, 4), new Point(3, 4)};

            //Console.WriteLine("Rotate90");
            //Point[] rotated90Array = Rotate90(originalArray);
            //foreach (Point point in rotated90Array)
            //{
            //    Console.WriteLine(point.Pos);
            //}
            //Console.WriteLine("Rotate270");
            //Point[] rotated270Array = Rotate270(originalArray);
            //foreach (Point point in rotated270Array)
            //{
            //    Console.WriteLine(point.Pos);
            //}
            //Console.WriteLine("Rotate180");
            //Point[] rotated180Array = Rotate180(originalArray);
            //foreach (Point point in rotated180Array)
            //{
            //    Console.WriteLine(point.Pos);
            //}
            //Console.WriteLine("Flip");
            //Point[] flipArray = Flip(originalArray);
            //foreach (Point point in flipArray)
            //{
            //    Console.WriteLine(point.Pos);
            //}
            #endregion

            Console.ReadLine();
        }

        private static void FileWrite(string filePath, string messaage)
        {
            using (StreamWriter writer = new StreamWriter(filePath, append: true))
            {
                writer.Write(messaage);
            }
        }

        private static void FileWriteLine(string filePath)
        {
            using (StreamWriter writer = new StreamWriter(filePath, append: true))
            {
                writer.WriteLine();
            }
        }
    }
}
