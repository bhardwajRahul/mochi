*> Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:40:03 GMT+7
>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. MAIN.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 TMP PIC S9(9) VALUE 0.
01 TMP-STR PIC Z(18).

PROCEDURE DIVISION.
    IF "a" < "b"
        DISPLAY 1
    ELSE
        DISPLAY 0
    END-IF
    IF "a" <= "a"
        DISPLAY 1
    ELSE
        DISPLAY 0
    END-IF
    IF "b" > "a"
        DISPLAY 1
    ELSE
        DISPLAY 0
    END-IF
    IF "b" >= "b"
        DISPLAY 1
    ELSE
        DISPLAY 0
    END-IF
    STOP RUN.
