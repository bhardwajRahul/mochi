*> Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:40:02 GMT+7
>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 TMP PIC S9(9) VALUE 0.
01 TMP-STR PIC Z(18).

PROCEDURE DIVISION.
    COMPUTE TMP = 1 + 2 * 3
    MOVE TMP TO TMP-STR
    DISPLAY FUNCTION TRIM(TMP-STR)
    COMPUTE TMP = (1 + 2) * 3
    MOVE TMP TO TMP-STR
    DISPLAY FUNCTION TRIM(TMP-STR)
    COMPUTE TMP = 2 * 3 + 1
    MOVE TMP TO TMP-STR
    DISPLAY FUNCTION TRIM(TMP-STR)
    COMPUTE TMP = 2 * (3 + 1)
    MOVE TMP TO TMP-STR
    DISPLAY FUNCTION TRIM(TMP-STR)
    STOP RUN.
