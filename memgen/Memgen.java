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
			System.out.println("Error. Incorrect amount of parameters specified.");
			System.out.println("Usage: java Memgen [amount of addressable lines]");
			return;
		}

		char[] values = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

		System.out.println("@0");

		Random rand = new Random();

	
		for(int i = 0; i < Integer.parseInt(args[0]); i++)
		{
			System.out.print(values[rand.nextInt(16)]);
			System.out.print(values[rand.nextInt(16)]);
			System.out.print(values[rand.nextInt(16)]);
			System.out.print(values[rand.nextInt(16)]);
			System.out.print("\n");
		}
	}
}
