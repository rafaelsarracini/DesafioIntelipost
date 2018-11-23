#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "SHASH.ch"
#INCLUDE "JSON.ch"
#INCLUDE "AARRAY.CH"
#DEFINE CRLF CHR(13) + CHR(10)
Static cDirRaiz := "\DESAFIO\"
/*************************************************************************************/
/*																					 */
/*					Biblioteca de Funções  #Desafio Intelipost						 */
/*																				  	 */
/*************************************************************************************/

/*************************************************************************************/
/*/{Protheus.doc} MDWARQPV

@description Monta Arquivo que será enviado para Plataforma de Vendas

@author Rafael Sarracini
@since 22/11/2018
@version undefined

@param cOrderId	, characters, Id do Pedido de Venda
@param cStatus	, characters, Status do pedido já traduzido.
@param cDate	, characters, Data do evento - Formato: AAAA-MM-DDTHH:MM:SS 
													Ex: 2018-02-02T10:45:32

@type function

@Return cRet - Conteudo REST pronto para ser enviado		
/*/
/*************************************************************************************/
User Function MDWARQPV(cOrderId,cStatus,cDate)
Local cRet 		:= ""
Local oJson		:= Array(#)

oJson[#"orderId"]	:= Val(cOrderId)
oJson[#"status"]	:= cStatus
oJson[#"date"]		:= cDate

//---------------------------+
// Transforma Objeto em JSON |
//---------------------------+
cRet := xToJson(oJson)

//-------------------+
// Encoda em UTF-8   |
//-------------------+
EncodeUtf8(@cRet)

Return cRet 

/*************************************************************************************/
/*/{Protheus.doc} MDWPOST

@description Envia Conteudo JSON para URL pre-determinada

@author Rafael Sarracini
@since 22/11/2018
@version undefined

@param cRest	, characters, Conteudo Rest a ser Enviado
@param cUrl	, characters, URL para onde será enviado.


@type function

@Return aRet[1] - Código do Retorno
		aRet[2] = Descrição do retorno
		Esperado: 200 - "SUCESSO"
/*/
/*************************************************************************************/
User Function  MDWPOST(cRest,cUrl)
Local aRet := {}
Local aArea		:= GetArea()

Local nTimeOut		:= 240

Local aHeadOut  	:= {}
Local cXmlHead 	 	:= ""     
Local cRetPost  	:= ""

aAdd(aHeadOut,"Content-Type: text/plain" )
       
u_LogExec("Enviando para '"+cUrl+"' .......",.F.)
	   
cRetPost := HttpPost(cUrl ,"",cRest,nTimeOut,aHeadOut,@cXmlHead) 
//valida se retorno foi diferente de Nulo.
if Valtype(cRetPost) == "U"
	cRetPost := ""
endif

If HTTPGetStatus() == 200
	//Preenche retorno
	aRet := {200,"ENVIADO COM SUCESSO"}	
	u_LogExec("ENVIADO COM SUCESSO| HTTPGetStatus():" + cValToChar(HTTPGetStatus()) + " | Mensagem: " + cRetPost)
Else
	//Preenche retorno
	aRet := {400,"ERRO NO ENVIO DO ARQUIVO PARA PLAT VENDAS"}

	u_LogExec("ERRO NO ENVIO | HTTPGetStatus():" + cValToChar(HTTPGetStatus()) + " | Mensagem: " + cRetPost)
EndIf

RestArea(aArea) 
Return aRet

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
Private cArqLog	:= ""
Default lDetalhe := .T.

//------------------------------+
// Inicializa Log de Integracao |
//------------------------------+
FwMakeDir(cDirRaiz)
cArqLog := cDirRaiz + "DesafioIntelipost" + cEmpAnt + cFilAnt + ".LOG"

If lDetalhe
	cMsg := "TID:[" + cValToChar(ThreadId()) + "] - Prog: " + ProcName(1) + ":Lin(" + Alltrim(Str(ProcLine())) + ") - DATA/HORA: " + dToc( Date() ) + " AS " + Time() + " " + cMsg
EndIf
CONOUT(cMsg)	
LjWriteLog(cArqLog,cMsg)
Return .T.