import java.util.Random;

/**
 * Memgen
 * -
 * A class for generating test memory images for the ECE 552 project.
 *
 * @author wchen329
 */
class Memgen
{
	/**
	 * Main routine
	 */
	public static void main(String args[])
	{
		if(args.length != 1)
		{
			System.err.println("Error. Incorrect amount of parameters specified.");
			System.err.println("Usage: java Memgen [amount of addressable lines]");
			return;
		}

		char[] values = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

		try
		{
			int lines = Integer.parseInt(args[0]);	// Raise exception if needed
			System.out.println("@0");

			Random rand = new Random();

	
			for(int i = 0; i < lines; i++)
			{
				System.out.print(values[rand.nextInt(16)]);
				System.out.print(values[rand.nextInt(16)]);
				System.out.print(values[rand.nextInt(16)]);
				System.out.print(values[rand.nextInt(16)]);
				System.out.print("\n");
			}
		}

		catch(NumberFormatException e)
		{
			System.err.println("Error. The specified paramter must be an integer value.");
		}
	}
}
