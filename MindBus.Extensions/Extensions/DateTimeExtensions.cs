using System;

namespace MindBus.Extensions.Extensions
{
    public static class DateTimeExtensions
    {
        public static string FormatToLongFormatWithCommas(this DateTime dateTime)
        {
            return String.Format("{0:dddd, MMMM d, yyyy}", dateTime);
        }

        public static string FormatDateAndTime(this DateTime dateTime)
        {
            return String.Format("{0:dd MMMM yyyy 'OM' HH':'mm}", dateTime);
        }

        public static string FormatHour(this DateTime dateTime)
        {
            return String.Format("{0:HH':'mm}", dateTime);
        }

        public static string FormatMonth(this DateTime dateTime)
        {
            return String.Format("{0:MMM}", dateTime);
        }

        public static string FormatDay(this DateTime dateTime)
        {
            return String.Format("{0:dd}", dateTime);
        }
    }
}