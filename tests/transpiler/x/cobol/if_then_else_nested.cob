*> Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:40:03 GMT+7
>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 X PIC 9 VALUE 8.
01 MSG PIC X(100).

PROCEDURE DIVISION.
    IF X > 10
    MOVE "big" TO MSG
ELSE
    IF X > 5
    MOVE "medium" TO MSG
ELSE
    MOVE "small" TO MSG
END-IF
END-IF
    DISPLAY MSG
    STOP RUN.
