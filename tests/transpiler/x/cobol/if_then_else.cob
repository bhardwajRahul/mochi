*> Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:40:03 GMT+7
>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 X PIC 9(2) VALUE 12.
01 MSG PIC X(100).

PROCEDURE DIVISION.
    IF X > 10
    MOVE "yes" TO MSG
ELSE
    MOVE "no" TO MSG
END-IF
    DISPLAY MSG
    STOP RUN.
