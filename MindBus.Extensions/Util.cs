using System.Linq;

namespace MindBus.Extensions
{
    public class Util
    {
        public static string Coalesce(params string[] values)
        {
            return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value));
        }
    }
}