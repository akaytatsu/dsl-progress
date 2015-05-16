/* Progress Check Syntax by Gabriel Hautclocq */
/* How to use it : C:\Progress\102B\bin\_progres.exe -1 -b -pf C:\Progress\102B\startup.pf -p C:\path\to\syntax.p -param "C:\program_to_check.p" */

DEFINE VARIABLE ch_prog AS CHARACTER NO-UNDO.

/* Extracts the parameters */
ASSIGN ch_prog = ENTRY( 1, SESSION:PARAMETER ).
IF NUM-ENTRIES(SESSION:PARAMETER) >= 2 THEN DO :
  ASSIGN PROPATH = PROPATH + ":" + ENTRY( 2, SESSION:PARAMETER ).
END.

/* Compile without saving */
run VALUE( ch_prog ).

quit.
