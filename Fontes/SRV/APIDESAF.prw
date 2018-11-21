#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE CRLF CHR(13) + CHR(10)
Static cDirRaiz := "\DESAFIO\"

/*********************************************************************************************************************/
/*/{Protheus.doc} Cria Orçamento

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
/*/
/*********************************************************************************************************************/
WSMETHOD POST WSSERVICE DesafioIntelipost
Local aArea		:= GetArea()

Local cBody		:= ""
Local cMsgRet	:= ""

Local lPost		:= .T.

Private cArqLog	:= ""
Private cMsgOrc	:= ""

//------------------------------+
// Inicializa Log de Integracao |
//------------------------------+
MakeDir(cDirRaiz)
cArqLog := cDirRaiz + "DesafioIntelipost" + cEmpAnt + cFilAnt + ".LOG"
ConOut("")	

//--------------------+
// Seta o ContentType |
//--------------------+
::SetContentType("application/json") 

//--------------------+
// Captura o Conteudo |
//--------------------+
cBody := ::GetContent()

if !Empty(cBody)
	CoNout('Conteúdo Recebido: '+CRLF + cBody)
	
	//-----------------------------+
	// Chama Função para Converter |
	//-----------------------------+
	
	APIDES01()
	
else 
	SetRestFault(400,"Insuficient Content",.T.)
 	lPost := .F.
	CoNout('Nenhum conteudo foi recebido Conteúdo Recebido')	
endif



if lPost
	cMsgRet := ""
	HTTPSetStatus(200,cMsgRet)  
Else
	SetRestFault(400,cMsgOrc,.T.)	
EndIf	

ConOut("")

RestArea(aArea)
Return lPost	

