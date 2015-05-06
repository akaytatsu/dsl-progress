/* Progress Check Syntax by Gabriel Hautclocq */
/* How to use it : C:\Progress\102B\bin\_progres.exe -1 -b -pf C:\Progress\102B\startup.pf -p C:\path\to\syntax.p -param "C:\program_to_check.p" */

DEFINE VARIABLE ch_prog AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLog    AS CHARACTER NO-UNDO.
DEFINE VARIABLE ch_mess AS CHARACTER NO-UNDO.
DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

CREATE ALIAS mgadm	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgcex	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgcld	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgdis	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgind	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mginv	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgmfg	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgmnt	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgmrp	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mguni	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgven	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgtmp	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgadt	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgrac	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS mgscm	FOR DATABASE mgcad NO-ERROR.
CREATE ALIAS movadm     FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS movdis	FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS movind	FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS movmnt     FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS movmfg     FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS movrac	FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS wmovdis    FOR DATABASE mgmov NO-ERROR.
CREATE ALIAS mgmp	FOR DATABASE mgcad NO-ERROR.

CREATE ALIAS emsbas FOR DATABASE emscad NO-ERROR.
CREATE ALIAS emsfin FOR DATABASE emscad NO-ERROR.
CREATE ALIAS emsedi FOR DATABASE emscad NO-ERROR.
CREATE ALIAS emsuni FOR DATABASE emscad NO-ERROR.
CREATE ALIAS emsven FOR DATABASE emscad NO-ERROR.
CREATE ALIAS movfin FOR DATABASE emsmov NO-ERROR.

create alias ems2cad for database mgcad.
create alias ems2mov for database mgmov.

/* Extracts the parameters */
ASSIGN ch_prog = ENTRY( 1, SESSION:PARAMETER ).
/*ASSIGN cLog    = ENTRY( 2, SESSION:PARAMETER ).*/
/*IF NUM-ENTRIES(SESSION:PARAMETER) >= 2 THEN DO :
  ASSIGN PROPATH = PROPATH + ":" + ENTRY( 2, SESSION:PARAMETER ).
END.*/

/* Compile without saving */
COMPILE VALUE( ch_prog ) SAVE NO-ERROR.

/*output to value(cLog).*/

/* If there are compilation messages */
IF COMPILER:NUM-MESSAGES > 0 THEN DO:

  ASSIGN ch_mess = "".

  /* For each messages */
  DO i = 1 TO COMPILER:NUM-MESSAGES:

    /* Generate an error line */
    ASSIGN ch_mess =
      SUBSTITUTE( "&1 File:'&2' Row:&3 Col:&4 Error:&5 Message:&6",
        IF COMPILER:WARNING = TRUE THEN "WARNING" ELSE "ERROR",
        COMPILER:GET-FILE-NAME  ( i ),
        COMPILER:GET-ROW        ( i ),
        COMPILER:GET-COLUMN     ( i ),
        COMPILER:GET-NUMBER     ( i ),
        COMPILER:GET-MESSAGE    ( i )
      )
    .

    /* display the message to the standard output */
    PUT UNFORMATTED ch_mess SKIP.
  END.
END.
ELSE DO :

  /* display to the standard output */
  PUT UNFORMATTED "SUCCESS: Compile complete." SKIP.
END.

/*output close.*/
/* End of program */
QUIT.
