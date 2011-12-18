using System;
using System.Collections;
using umbraco;

namespace PS
{
	[XsltExtension]

	public class XSLTsearch
	{
		public XSLTsearch() { }

		public static double power(double x, double y)
		{
			return Math.Pow(x, y);
		}

		public static string uppercase(string s)
		{
			return s.ToUpper();
		}

		public static string escapeString(string data)
		{
			if (data.IndexOf("&") > -1)
			{

				Hashtable codes = new Hashtable();
				codes.Add("&amp;", (char)38);
				codes.Add("&nbsp;", (char)160);
				codes.Add("&quot;", (char)34);
				codes.Add("&lt;", (char)60);
				codes.Add("&gt;", (char)62);
				codes.Add("&pound;", (char)163);
				codes.Add("&copy;", (char)169);
				codes.Add("&middot;", (char)183);

				foreach (DictionaryEntry de in codes)
					data = data.Replace(de.Value.ToString(), de.Key.ToString());
			}
			return data;
		}

		public static string unescapeString(string data)
		{
			if (data.IndexOf("&") > -1)
			{
				Hashtable codes = new Hashtable();
				codes.Add("&amp;", (char)38);
				codes.Add("&nbsp;", (char)160);
				codes.Add("&quot;", (char)34);
				codes.Add("&lt;", (char)60);
				codes.Add("&gt;", (char)62);
				codes.Add("&pound;", (char)163);
				codes.Add("&copy;", (char)169);
				codes.Add("&middot;", (char)183);

				foreach (DictionaryEntry de in codes)
					data = data.Replace(de.Key.ToString(), de.Value.ToString());
			}
			return data;
		}

		public string escapingIntelligentSubstring(string data, int unescapedStart, int unescapedLength)
		{
			// zero-based, so reduce the length by one
			unescapedLength--;

			int unescapedPosition = 0;
			int escapedPosition = 0;
			int escapedStart = -1;

			while (escapedPosition < data.Length)
			{
				// left-trim of spaces and non-breaking-spaces
				if (escapedStart == -1 && unescapedPosition >= unescapedStart)
					if (data.Substring(escapedPosition, 6) != "&nbsp;" && data.Substring(escapedPosition, 1) != " ")
					{
						// save the "escaped" starting point, taking into account escaped characters
						escapedStart = escapedPosition;
						unescapedPosition = 0;
					}

				if (data.Substring(escapedPosition, 1) == "&" && data.IndexOf(";", escapedPosition) > -1)
				{
					// look for an escaped character
					string escapedCharacter = data.Substring(escapedPosition, data.IndexOf(";", escapedPosition) - escapedPosition + 1);
					if (System.Text.RegularExpressions.Regex.Match(escapedCharacter, "&[A-Za-z]{2,6};").Success)
						escapedPosition += escapedCharacter.Length;
					else
						escapedPosition++;
				}
				else
				{
					escapedPosition++;
				}

				if (escapedStart > -1 && unescapedPosition - unescapedStart == unescapedLength)
					break;

				unescapedPosition++;
			}

			if (escapedStart == -1)
				// in case escapedStart was never set because all text was trimmed off
				return "";

			if (escapedPosition < data.Length)
				return data.Substring(escapedStart, escapedPosition - escapedStart) + "...";
			else
				return data.Substring(escapedStart, escapedPosition - escapedStart);

		}

		public static double hitCount(string data, string find)
		{
			if (data == null || data == "" || find == null || find == "")
				return 0;

			string after = data.ToLower().Replace(find.ToLower(), "");
			return (data.Length - after.Length) / find.Length;
		}

		public static int indexOfMany(string search, string[] find)
		{
			int foundIndex = search.Length;
			bool found = false;
			foreach (string toFind in find)
			{
				int res = search.ToUpper().IndexOf(toFind.ToUpper());
				if (res != -1)
				{
					found = true;
					foundIndex = Math.Min(foundIndex, res);
				}
			}
			if (!found) return -1;
			return foundIndex;
		}
		public static string contextOfFind(string data, string find, int wordsBefore, int wordsAfter, int maxChars)
		{
			// NOTE: This only makes sense if the searchFields and previewFields are identical.
			// Otherwise, you can find a match but not see its context.

			try
			{
				if (data.Length == 0)
					return "";

				string findList = getFirstElement(find, " ");
				find = removeFirstElement(find, " ");
				while (find != "")
				{
					findList += "|" + getFirstElement(find, " ").ToUpper();
					find = removeFirstElement(find, " ");
				}
				string[] findPhrases = findList.Split('|');

				string remaining = data;
				string output = "";
				string[] after = new string[0];

				while (output.Length < maxChars && remaining != "")
				{
					int findIndex = indexOfMany(remaining, findPhrases);
					if (findIndex == -1)
						break;
					findIndex = remaining.IndexOf(" ", findIndex);

					if (findIndex == -1)
					{
						output += remaining;
						break;
					}

					string[] before = remaining.Substring(0, findIndex).Split(' ');
					if (before.Length > wordsBefore)
						output += " ... ";

					output += String.Join(" ", before, Math.Max(0, before.Length - wordsBefore), Math.Min(before.Length, wordsBefore));
					remaining = remaining.Substring(findIndex);
					after = remaining.Split(' ');
					string afterText = String.Join(" ", after, 0, Math.Min(after.Length, wordsAfter));
					int nextFindIndex = indexOfMany(afterText, findPhrases);
					if (nextFindIndex > -1)
						nextFindIndex = afterText.IndexOf(" ", nextFindIndex);

					while (nextFindIndex > -1)
					{
						output += afterText.Substring(0, nextFindIndex);
						remaining = remaining.Substring(nextFindIndex);
						after = remaining.Split(' ');
						afterText = String.Join(" ", after, 0, Math.Min(after.Length, wordsAfter));
						nextFindIndex = indexOfMany(afterText, findPhrases);
						if (nextFindIndex > -1)
							nextFindIndex = afterText.IndexOf(" ", nextFindIndex);
					}

					output += afterText;
					remaining = remaining.Substring(afterText.Length);

				}

				maxChars = (after.Length > wordsAfter) ? maxChars - 3 : maxChars;
				output = output.Trim();

				while (output.Length > maxChars && output.LastIndexOf(" ") > 0)
					output = output.Substring(0, output.LastIndexOf(" "));

				if (after.Length > wordsAfter)
					output += " ...";

				return output;
			}

			catch
			{
				return "";
			}
		}

		public static string surround(string data, string find, string before, string after)
		{
			// searches for find within data, then surrounds it with before and after tags
			// note: replace with the actual text found, to preserve the case

			string beforeSpecial = "\x0001";
			string afterSpecial = "\x0002";

			string nextWord = getFirstElement(find, " ");
			string remainingWords = find;
			while (nextWord != "")
			{
				int index = data.ToLower().IndexOf(nextWord.ToLower());
				while (index > -1)
				{
					string replacement = beforeSpecial + data.Substring(index, nextWord.Length) + afterSpecial;
					data = data.Substring(0, index) + replacement + data.Substring(index + nextWord.Length);
					index = data.ToLower().IndexOf(nextWord.ToLower(), index + replacement.Length);
				}
				remainingWords = removeFirstElement(remainingWords, " ");
				nextWord = getFirstElement(remainingWords, " ");
			}
			data = data.Replace(beforeSpecial, before).Replace(afterSpecial, after);
			return data;
		}

		public static long getTime()
		{
			// get current time
			return DateTime.Now.Ticks;
		}

		public static double getTimeSpan(long startTime, long stopTime)
		{
			// return time span in milliseconds
			return TimeSpan.FromTicks(stopTime - startTime).TotalMilliseconds;
		}

		public static string getFirstElement(string delimitedList, string delimiter)
		{
			// strip all leading delimiters
			while (delimitedList.IndexOf(delimiter) == 0)
				delimitedList = delimitedList.Remove(0, delimiter.Length).Trim();

			if (delimitedList.Length == 0)
				return "";

			// searching on a phrase
			if (delimiter == " " && delimitedList.Substring(0, 1) == "'" && delimitedList.IndexOf("'", 1) > -1)
				return delimitedList.Substring(1, delimitedList.IndexOf("'", 1) - 1);

			if (delimiter == " " && delimitedList.Substring(0, 1) == "\"" && delimitedList.IndexOf("\"", 1) > -1)
				return delimitedList.Substring(1, delimitedList.IndexOf("\"", 1) - 1);

			// only one element
			if (delimitedList.IndexOf(delimiter) == -1)
				return delimitedList.Trim();

			// return first element
			return delimitedList.Split(delimiter.ToCharArray()[0])[0].Trim();
		}

		public static string removeFirstElement(string delimitedList, string delimiter)
		{
			string firstElement = getFirstElement(delimitedList, delimiter);

			// handle phrase delimiters
			if (delimiter == " " && delimitedList.Substring(0, 1) == "'" && delimitedList.IndexOf("'", 1) > -1)
				return delimitedList.Remove(0, firstElement.Length + 2).Trim();

			if (delimiter == " " && delimitedList.Substring(0, 1) == "\"" && delimitedList.IndexOf("\"", 1) > -1)
				return delimitedList.Remove(0, firstElement.Length + 2).Trim();

			while (delimitedList.IndexOf(delimiter) == 0)
				delimitedList = delimitedList.Remove(0, delimiter.Length).Trim();

			return delimitedList.Remove(0, firstElement.Length).Trim();
		}

		public static string getDictionaryParameter(string value, string defaultValue)
		{
			if (value == "")
				return defaultValue;
			else
				return value;
		}

		public static string getParameter(string value, string defaultValue)
		{
			if (value == "")
				return defaultValue;
			else
				return value.Replace(" ", "");
		}

		public static string getListParameter(string value, string defaultValue)
		{
			// remove all spaces
			value = value.Replace(" ", "");
			defaultValue = defaultValue.Replace(" ", "");

			if (value == "")
				return "," + defaultValue + ",";
			else
				return "," + value + ",";
		}
	}
}
