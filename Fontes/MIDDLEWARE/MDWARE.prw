#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#DEFINE CRLF CHR(13) + CHR(10)
Static cDirRaiz := "\DESAFIO\"

/*************************************************************************************/
/*/{Protheus.doc} MIDDLEWR

@description Faz a Leitura e Interpretação do conteudo recebido.

@author Rafael Sarracini
@since 21/11/2018
@version undefined

@param cBody, characters, Conteudo JSON recebido.

@type function

@Return aRet[1] - Código do Retorno
		aRet[2] = Descrição do retorno
		
		0 - Falha no processamento
		1 - Processado com Sucesso
		2 - Falha no layout do Arquivo
		3 - Falha de Conexão com o Sistema de Vendas
		
/*/
/*************************************************************************************/
Static Function MIDDLEWR(cBody)
Local aRet := {0,"Falha no processamento"}
Local oJson		:= Array(#)

Local cOrderId	:= ""
Local cStatusId	:= ""
Local cStatus	:= ""

Local cDate		:= ""

Default cBody := ""

//Deserializar arquivo.

//Capturar informações

//Fazer a Tradução das Informações

//Serializar novo JSON para envio

//Enviar Informações conforme Layout Proposto (Nova User Function)

//Tratar Retorno de Envio


Return aRet