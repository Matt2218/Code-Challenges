using System;

namespace pangram
{
	class MainClass
	{
		public static void Main(string[] args)
		{
			askForPangram();
		}

		public static void askForPangram()
		{
			// empty string quits the application
			Console.WriteLine("Press Enter With No Input To Quit");
			// ask user for input
			Console.Write("Enter string to test: ");
			string input = Console.ReadLine();
			if (input == "")
			{
				Environment.Exit(0);
			}
			// check pangram 
			string panItems = Pangram(input);
			Console.WriteLine(panItems);
			askForPangram();
		}

		static String Pangram(string item)
		{
			item = item.ToLower();
			bool[] used = new bool[26];
			int total = 0;
			string unused = "";

			// run through characters in input
			foreach (char letter in item)
			{
				// character is between a and z
				if (letter >= 'a' && letter <= 'z')
				{
					// true indicates the character has been used
					int index = letter - 97;
					if (!used[index])
					{
						used[index] = true;
						total++;
					}
				}
			}

			// all characters are in string
			if (total == 26)
			{
				return null;
			}
			else
			{
				// convert false indexes back to characters
				for (int i = 0; i < 26; ++i)
				{
					bool hasLetter = used[i];
					if (!hasLetter)
					{
						char character = (char) (i + 97);
						unused += character.ToString();
					}
				}
				return unused;
			}
		}
	}
}
