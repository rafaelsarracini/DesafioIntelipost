#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE CRLF CHR(13) + CHR(10)
Static cDirRaiz := "\DESAFIO\"

/*********************************************************************************************************************/
/*/{Protheus.doc} Converte Layout JSON

@description 	Servi�o realiza a convers�o de JSON de um layout (sistema de rastreamento) para outro
				layout (sistema de vendas) viabilizando a comunica��o entre elas.

@author Rafael Sarracini

@since 20/11/2018
@version undefined

@type class
/*/
/*********************************************************************************************************************/
WSRESTFUL DesafioIntelipost DESCRIPTION " Servico que ir� viabilizar a comunica��o entre o Sistema de Rastreamento e o de Vendas"
					
	WSMETHOD POST DESCRIPTION "Viabiliza a comunica��o entre o Sistema de Rastreamento e o de Vendas" WSSYNTAX "/API/"

END WSRESTFUL

/*********************************************************************************************************************/
/*/{Protheus.doc} POST

@description 	Metodo realiza a convers�o de JSON de um layout (sistema de rastreamento) para outro
				layout (sistema de vendas) viabilizando a comunica��o entre elas.
@author Rafael Sarracini
@since 21/11/2018
@version undefined

@type function

@Used Functions
	User Function: LogExec - LOGEXEC.PRW  	- Grava��o de LOG
						@param cMsg, 		characters, Mensagem contida no LOG
						@param lDetalhe, 	characters, Se o Log ser� detalhado
	User Function: MIDDLEWR - MIDDLEWR.PRW 	- Convers�o de layouts
						@param cBody, 		characters, Conteudo JSON recebido.				
/*/
/*********************************************************************************************************************/
WSMETHOD POST WSSERVICE DesafioIntelipost
Local aArea		:= GetArea()
Local cBody		:= ""
Local cMsgRet	:= ""
Local aPost		:= {}
Local lPost		:= .F.

Private cArqLog	:= ""

//------------------------------+
// Inicializa Log de Integracao |
//------------------------------+
MakeDir(cDirRaiz)
cArqLog := cDirRaiz + "DesafioIntelipost" + cEmpAnt + cFilAnt + ".LOG"
ConOut("")	
U_LogExec(Replicate("-",80),.F.)
U_LogExec("-------  #DESAFIO INTELIPOST - By Rafael Sarracini - https://www.linkedin.com/in/rafael-sarracini-65b028134/ -------",.F.)
U_LogExec(Replicate("-",80),.F.)
U_LogExec("INICIA PROCESSAMENTO DO POST - DesafioIntelipost",.T.)

//--------------------+
// Seta o ContentType |
//--------------------+
::SetContentType("application/json") 

//--------------------+
// Captura o Conteudo |
//--------------------+
cBody := ::GetContent()

// Verifica se existe conteudo no POST

if !Empty(cBody)
	Conout('Conte�do Recebido: '+CRLF + cBody)
	
	//-----------------------------+
	// Chama Fun��o para Converter |
	//-----------------------------+
	
	aPost := U_MIDDLEWR(cBody)
	
else 
	// Loga erro de execu��o
	U_LogExec("400 - CONTENT IS MANDATORY",.T.)
	SetRestFault(400,"Insuficient Content",.T.)
 	lPost := .F.
	Conout('Nenhum conteudo foi recebido Conte�do Recebido')	
endif



if aPost[1] == 1
	// Loga Sucesso de execu��o
	U_LogExec("200 - JSON CONVERTIDO e ENVIADO COM SUCESSO",.T.)
	HTTPSetStatus(200,aPost[2])  
	lPost := .T.
Else
	// Loga erro de execu��o
	U_LogExec("400 - "+aPost[2],.T.)
	SetRestFault(400,aPost[2],.T.)	
	lPost := .F.
EndIf	

U_LogExec("FINALIZA PROCESSO DE CRIACAO DE ORCAMENTO - DesafioIntelipost",.T.)
U_LogExec(Replicate("-",80),.F.)
ConOut("")

RestArea(aArea)
Return lPost	