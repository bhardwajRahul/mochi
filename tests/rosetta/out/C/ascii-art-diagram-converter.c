// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:30Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:30Z
#include <stdio.h>
#include <stdlib.h>

int mochi_main() {
  printf("Diagram after trimming whitespace and removal of blank lines:\n\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|                      ID                       |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|                    QDCOUNT                    |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|                    ANCOUNT                    |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|                    NSCOUNT                    |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("|                    ARCOUNT                    |\n");
  printf("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n");
  printf("\nDecoded:\n\n");
  printf("Name     Bits  Start  End\n");
  printf("=======  ====  =====  ===\n");
  printf("ID        16      0    15\n");
  printf("QR         1     16    16\n");
  printf("Opcode     4     17    20\n");
  printf("AA         1     21    21\n");
  printf("TC         1     22    22\n");
  printf("RD         1     23    23\n");
  printf("RA         1     24    24\n");
  printf("Z          3     25    27\n");
  printf("RCODE      4     28    31\n");
  printf("QDCOUNT   16     32    47\n");
  printf("ANCOUNT   16     48    63\n");
  printf("NSCOUNT   16     64    79\n");
  printf("ARCOUNT   16     80    95\n");
  printf("\nTest string in hex:\n");
  printf("78477bbf5496e12e1bf169a4\n");
  printf("\nTest string in binary:\n");
  printf("011110000100011101111011101111110101010010010110111000010010111000011"
         "011111100010110100110100100\n");
  printf("\nUnpacked:\n\n");
  printf("Name     Size  Bit pattern\n");
  printf("=======  ====  ================\n");
  printf("ID        16   0111100001000111\n");
  printf("QR         1   0\n");
  printf("Opcode     4   1111\n");
  printf("AA         1   0\n");
  printf("TC         1   1\n");
  printf("RD         1   1\n");
  printf("RA         1   1\n");
  printf("Z          3   011\n");
  printf("RCODE      4   1111\n");
  printf("QDCOUNT   16   0101010010010110\n");
  printf("ANCOUNT   16   1110000100101110\n");
  printf("NSCOUNT   16   0001101111110001\n");
  printf("ARCOUNT   16   0110100110100100\n");
}

int _mochi_main() {
  mochi_main();
  return 0;
}
int main() { return _mochi_main(); }
