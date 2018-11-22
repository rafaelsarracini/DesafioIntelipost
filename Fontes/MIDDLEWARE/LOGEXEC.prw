#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE CRLF CHR(13) + CHR(10)
/*************************************************************************************/
/*/{Protheus.doc} LogExec

@description Grava log de integração

@author Rafael Sarracini
@since 21/11/2018
@version undefined

@param cMsg, 		characters, Mensagem contida no LOG
@param lDetalhe, 	characters, Se o Log será detalhado

@type function
/*/
/*************************************************************************************/
User Function LogExec(cMsg,lDetalhe)
Default lDetalhe := .T.

If lDetalhe
	cMsg := "TID:[" + cValToChar(ThreadId()) + "] - Prog: " + ProcName(1) + ":Lin(" + Alltrim(Str(ProcLine())) + ") - DATA/HORA: " + dToc( Date() ) + " AS " + Time() + " " + cMsg
EndIf
CONOUT(cMsg)	
LjWriteLog(cArqLog,cMsg)
Return .T.