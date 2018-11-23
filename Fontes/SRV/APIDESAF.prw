#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE CRLF CHR(13) + CHR(10)


/*********************************************************************************************************************/
/*/{Protheus.doc} Converte Layout JSON

@description 	Serviço realiza a conversão de JSON de um layout (sistema de rastreamento) para outro
				layout (sistema de vendas) viabilizando a comunicação entre elas.

@author Rafael Sarracini

@since 20/11/2018
@version undefined

@type class
/*/
/*********************************************************************************************************************/
WSRESTFUL DesafioIntelipost DESCRIPTION " Servico que irá viabilizar a comunicação entre o Sistema de Rastreamento e o de Vendas"
					
	WSMETHOD POST DESCRIPTION "Viabiliza a comunicação entre o Sistema de Rastreamento e o de Vendas" WSSYNTAX "/API/"

END WSRESTFUL

/*********************************************************************************************************************/
/*/{Protheus.doc} POST

@description 	Metodo realiza a conversão de JSON de um layout (sistema de rastreamento) para outro
				layout (sistema de vendas) viabilizando a comunicação entre elas.
@author Rafael Sarracini
@since 21/11/2018
@version undefined

@type function

@Used Functions
	User Function: LogExec - LOGEXEC.PRW  	- Gravação de LOG
						@param cMsg, 		characters, Mensagem contida no LOG
						@param lDetalhe, 	characters, Se o Log será detalhado
	User Function: MIDDLEWR - MIDDLEWR.PRW 	- Conversão de layouts
						@param cBody, 		characters, Conteudo JSON recebido.				
/*/
/*********************************************************************************************************************/
WSMETHOD POST WSSERVICE DesafioIntelipost
Local aArea		:= GetArea()
Local cBody		:= ""
Local cMsgRet	:= ""
Local aPost		:= {}
Local lPost		:= .F.


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
	U_LogExec(Replicate("*",80),.F.)
	U_LogExec("Conteúdo Recebido do sistema de Rastreamento: "+CRLF+cBody,.F.)
	U_LogExec(Replicate("*",80),.F.)	
	
	//-----------------------------+
	// Chama Função para Converter |
	//-----------------------------+
	U_LogExec("Inicia MiddleWare",.T.)
	aPost := U_MIDDLEWR(cBody)
	U_LogExec("MiddleWare Finalizada",.T.)
	
else 
	// Loga erro de execução
	U_LogExec("400 - CONTENT IS MANDATORY",.T.)
	SetRestFault(400,"Insuficient Content",.T.)
 	lPost := .F.
	U_LogExec('Nenhum conteudo foi recebido Conteúdo Recebido',.F.)	
endif

if len(aPost) == 2
	if aPost[1] == 200
		// Loga Sucesso de execução
		U_LogExec("200 - JSON CONVERTIDO e ENVIADO COM SUCESSO",.T.)
		HTTPSetStatus(200,aPost[2])  
		lPost := .T.
	Else
		// Loga erro de execução
		U_LogExec(cValToChar(aPost[1])+" - "+aPost[2],.T.)
		SetRestFault(aPost[1],aPost[2],.T.)	
		lPost := .F.
	EndIf	

endif	

U_LogExec("FINALIZA PROCESSAMENTO DO POST  - DesafioIntelipost",.T.)
U_LogExec(Replicate("-",80),.F.)
ConOut("")

RestArea(aArea)
Return lPost	