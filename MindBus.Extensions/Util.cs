using System.Linq;

namespace MindBus.Extensions
{
    public class Util
    {
        public static string Coalesce(params string[] values)
        {
            return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value));
        }

        public static int CalculateNumberOfPages(int totalNumberOfItems, int pageSize)
        {
            var result = totalNumberOfItems % pageSize;
            if (result == 0)
                return totalNumberOfItems / pageSize;
            return totalNumberOfItems / pageSize + 1;
        }
    }
}