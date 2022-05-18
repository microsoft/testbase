using System;

namespace HeightGained
{
    class Program
    {
        static int Main(string[] args)
        {
            if (args.Length < 3)
            {
                Console.WriteLine("Usage: HeightGained.exe gradeinPercent distance useMetricUnits");
                Console.WriteLine("Usage: gradeinPercent should be numeric");
                Console.WriteLine("Usage: useMetricUnits should be 1 for using meters instead of miles and feet");
                return 1;
            }
            bool metricSystem = args[2] == "1";

            double grade, distance;
            if (!Double.TryParse(args[1], out distance))
            {
                return 1;
            }
            if (!Double.TryParse(args[0], out grade))
            {
                return 1;
            }

            double rise;
            string resultToDisplay;
            if (!metricSystem)
            {
                rise = (grade / 100.0) * (distance * 5280.0);
                resultToDisplay = "Height gained (in feet): ";
            }
            else
            {
                rise = (grade / 100.0) * (distance);
                resultToDisplay = "Height gained (in meters): ";
            }
            resultToDisplay += string.Format("{0:0.00}", rise);
            Console.WriteLine(resultToDisplay);
            return 0;
        }
    }
}
