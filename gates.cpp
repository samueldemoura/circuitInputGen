#include <iostream>
#include <fstream>
#include <vector>
#include <math.h>

#define INPUTS 2
#define OUTPUTS 5
#define BITS 4

// Convert int to bit array
// in = original integer
// bits = how many bits to convert to
// *out = pointer to bool array;
void intToBits(int in, int bits, bool *out)
{
    for (int j = 0; j < bits; ++j)
    {
        out[bits-j-1] = (in >> j) & 1;
    }
}

// Vice-versa
int bitsToInt(bool *in, int bits)
{
    int result = 0;

    for (int i = 0; i < bits; ++i)
    {
        if (in[bits-i-1])
        {
            result += pow(2, i);
        }
    }

    return result;
}
 
int main()
{
    std::ofstream file;
    file.open("example.tv", std::ios::trunc);

    // Ex: 2 inputs, 4 bits is 2^(2*4) = 256 lines
    int totalLines = pow(2, INPUTS*BITS);

    // Inputs and Ouputs as one big bit array
    // Will be broken apart into separate ints
    bool inputBitArray[totalLines][INPUTS*BITS];
    bool outputBitArray[BITS];

    // Inputs and outputs as ints
    unsigned int input[totalLines][INPUTS];
    unsigned int output[totalLines][OUTPUTS];

    for (int i = 0; i < pow(2, INPUTS*BITS); ++i)
    {
        // Write out input as bits
        intToBits(i, INPUTS*BITS, &inputBitArray[i][0]);

        for (int j = 0; j < INPUTS*BITS; ++j)
        {
            file << inputBitArray[i][j];
            std::cout << inputBitArray[i][j];
        }

        // Separate input from output
        file << "_";
        std::cout << "_";

        // For each one of the inputs
        for (int j = 0; j < INPUTS; ++j)
        {
            // Convert it into an int
            input[i][j] = bitsToInt(&inputBitArray[i][j*BITS], BITS);
        }

        // For each one of the outputs
        for (int j = 0; j < OUTPUTS; ++j)
        {
            int result = 0;

            /// Process logic
            switch (j)
            {
                case 0: // a AND b
                    result = input[i][0] & input[i][1];
                    break;
                case 1: // a OR b
                    result = input[i][0] | input[i][1];
                    break;
                case 2: // a XOR b
                    result = input[i][0] ^ input[i][1];
                    break;
                case 3: // a NAND b
                    result = ~(input[i][0] & input[i][1]);
                    break;
                case 4: // a NOR b
                    result = ~(input[i][0] | input[i][1]);
                    break;
                default:
                    break;
            }

            output[i][j] = result;

            // Convert output to bits
            intToBits(output[i][j], BITS, &outputBitArray[0]);

            // Print the output bits
            for (int k = 0; k < BITS; ++k)
            {
                file << outputBitArray[k];
                std::cout << outputBitArray[k];
            }
        }

        file << std::endl;
        std::cout << std::endl;
    }

    file.close();
    return 0;
}

