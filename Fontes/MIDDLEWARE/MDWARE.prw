#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "SHASH.ch"
#INCLUDE "JSON.ch"
#INCLUDE "AARRAY.CH"
#DEFINE CRLF CHR(13) + CHR(10)

/*************************************************************************************/
/*/{Protheus.doc} MIDDLEWR

@description MIDDLEWARE - Faz a Leitura e Interpretação do conteudo recebido.

@author Rafael Sarracini
@since 21/11/2018
@version undefined

@param cBody, characters, Conteudo JSON recebido.

@type function

@Return aRet[1] - Código do Retorno
		aRet[2] = Descrição do retorno		
/*/
/*************************************************************************************/
User Function MIDDLEWR(cBody)
Local aRet := {}

//Objetos para fazer a Leitura do REST
Local oRest	 	:= Array(#)
Local oEvent 	:= Array(#)

//Variaveis para caputrar informações do REST
Local cOrderId	:= ""
Local cStatusId	:= ""
Local cDate		:= ""

//pre-determina pelo posicionamento status_id x status 
Local aStatus 	:= {"in_transit","to_be_delivered","delivered"}
Local cStatus 	:= ""
//Se Parametro existir, busca URL, se não utiliza URL pre-determinada no SX6
Local cUrlPV	:= GetMv("IT_URLPV",.F.,"http://requestbin.fullcontact.com/1lsg0sk1")

//Info para Plataforma de Vendas
Local cRestPV 	:= ""
//Retorno da Plat. Vendas
Local aRetPV  	:= {}
Local lContinua := .T.

Default cBody 	:= ""

//--------------------------------------+
// Realiza a deserialização via HASH    |
//--------------------------------------+
oRest := xFromJson(cBody)
IF valtype(oRest) == "O"
	U_LogExec("[MIDDLEWR] - Arquivo REST do sistema de rastreamento deserealizado ",.T.)
	//Captura evento
	oEvent 		:= oRest[#"event"]

	//-----------------------------------------------------------------+
	// Recupera as informações necessárias para a Plataforma de Vendas |
	//-----------------------------------------------------------------+
	cOrderId 	:= cValToChar(oRest[#"order_id"])
	cStatusId 	:= cValToChar(oEvent[#"status_id"])
	cDate 		:= oEvent[#"date"]

	//--------------------------------------------------------+
	// Faz a conversão pelo posicionamento status_id x status |
	//--------------------------------------------------------+
	cStatus := aStatus[val(cStatusId)]
	lContinua := .T.
else
	lContinua := .F.
	U_LogExec("[MIDDLEWR] - Falha na Deserealização do Arquivo REST do sistema de rastreamento - Favor Rever se Layout está correto",.T.)
	aRet := {"400","Falha na Deserealização do Arquivo REST do sistema de rastreamento"}
endif

if lContinua
	//--------------------------------------------------------+
	// Constroi Arquivo para retorno pra Plataforma de Vendas |
	//--------------------------------------------------------+
	cRestPV := u_MDWARQPV(cOrderId,cStatus,cDate)
	
	if !Empty(cRestPV)
		lContinua := .T.
		U_LogExec("[MIDDLEWR] - Arquivo REST do sistema de rastreamento foi traduzido e está pronto para ser enviado para Plataforma de Vendas ",.T.)
		U_LogExec(Replicate("*",80),.F.)
		U_LogExec("[MIDDLEWR] - Conteudo do Arquivo a ser enviado: "+CRLF+cRestPV,.F.)
		U_LogExec(Replicate("*",80),.F.)
	else
		lContinua := .F.
		U_LogExec("[MIDDLEWR] - FALHA na tradução do arquivo de Rastreamento para Plataforma de Vendas ",.T.)	
		aRet := {"400","Falha na traducao do Arquivo de Rastreamento para Plat. Vendas"}	
	endif
endif

if lContinua
	//-----------------------------------------------------+
	// Envia Conteudo Traduzido para Plataforma de Vendas  |
	//-----------------------------------------------------+
	aRetPV := aClone(u_MDWPOST(cRestPV,cUrlPV))
	
	if aRetPV[1] == 200
		U_LogExec("[MIDDLEWR] - Arquivo Traduzido foi Enviado para plataforma de Vendas com sucesso",.T.)	
		//---------------------------+
		// Prepara Retorno para API  |
		//---------------------------+
		aRet := aClone(aRetPV)
	else
		aRet := {"400","Falha no envio do Arquivo traduzido para Plat. Vendas"}	
		U_LogExec("[MIDDLEWR] - Falha no envio do Arquivo traduzido para Plataforma de Vendas",.T.)
	endif
endif
Return aRet