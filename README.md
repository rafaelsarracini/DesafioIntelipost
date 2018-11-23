# DesafioIntelipost
Teste Prático Desenvolvedor de Integrações

Primeiramente, gostaria de agradecer a Intelipost ao [#Desafio](https://github.com/intelipost/job-integration-developer) proposto

# Introdução

O serviço trabalhará como uma Middleware, recebendo informações do Sistema de Rastreamento e irá trabalhar a informação para que seja possível enviar para uma Plataforma de Vendas.

![Tabela 1](http://maxserver.net.br/rafael/table1.png)


# Desenvolvimento

Foi escolhido desenvolver o projeto em ADVPL, pela consonância com a vaga aplicada.

Também foi utilizado o Protheus 12 e IDE Dev Studio para a construção deste projeto.

Com um ambiente Protheus Instalado, deve-se criar um novo AppServer, de preferência, exclusivamente para serviços REST.

Após o ambiente estiver configurado para rodar normalmente (Repositório de Objetos, License, DbAccess, Portas, General)

Configureação do seu **Appserver.INI:**

Após a sessão [General] configure preencha conforme orientado abaixo:
- Criar uma Sessão [ONSTART] chamando qual JOB será iniciado.

- Configurar Porta pela qual o serviço ficará disponível
- Configurar Rotas por quais endereços o serviço poderá ser acessado. (No exemplo abaixo existem 3, Local, Link Primario  e Link Secundário)

```
;-----------------------------------------
;----------API REST DESAFIO---------------
;-----------------------------------------
[ONSTART]
JOBS=HTTPJOB
RefreshRate=6000

[HTTPJOB]
MAIN=HTTP_START
ENVIRONMENT=API
 
[HTTPV11]
Enable=1
Sockets=HTTPREST

[HTTPREST] 
Port=8094
IPsBind=
URIs=HTTPURI,HTTPURI2,HTTPURI3
Security=0

[HTTPURI]
URL=/API
CORSEnable=1
AllowOrigin=*
PrepareIn=All
Instances=1,1

[HTTPURI2]
URL=http://187.62.0.102/API
CORSEnable=1
AllowOrigin=*
PrepareIn=All
Instances=1,1

[HTTPURI3]
URL=http://187.62.0.101/API
CORSEnable=1
AllowOrigin=*
PrepareIn=All
Instances=1,1

```

## Fontes:
Foram desenvolvidos 3 Fontes para esse projeto:
![Fontes](http://maxserver.net.br/rafael/Fontes.png)

**APIDESAF.PRW**

API do Desafio - Serviço que ficará pronto para ser consumido pelo Sistema de Rastreamento, após recebimento dos dados executará a Middleware (MDWARE.prw) até o envio para plataforma de vendas.

**MDWARE.PRW**

Função que fará a tradução do layout do sistema de Rastreamento de Mercadorias para o layout do sistema de Vendas.

Após tradução irá chamar rotina que irá enviar as informações para a URL do Sistema de Vendas pre-determinada.

**DIXFUN.PRW**

Biblioteca Desafio Intelipost, contendo funções utilizadas pela API e Middleware.

Foi utilizado Notação Húngara em todos os fontes e os mesmos estão devidamente comentados e preparados para logar suas execuções.

## Includes e outras LIBs

Foram utilizadas 9 Includes e 2 Fontes disponibilizado pela comunidade TOTVS.
![Fontes 2](http://maxserver.net.br/rafael/Fontes2.png)

# Compilação

Ao compilar os Fontes, uma mensagem similar a esta deverá aparecer:

```
Iniciando compilação...


Por favor, aguarde. Montando lista de arquivos para a compilação....
Compilando arquivos para a configuração REST...
--------------------------------------------------------------------------

Compilando arquivos...
   c:\users\rafael.conceicao\documents\github\desafiointelipost\fontes\srv\apidesaf.prw...
   c:\users\rafael.conceicao\documents\github\desafiointelipost\fontes\lib\dixfun.prw...
  Warning(s):
    
    DIXFUN.PRW(93) warning W0008 Too few parameters calling HTTPGetStatus 
    DIXFUN.PRW(96) warning W0008 Too few parameters calling HTTPGetStatus 
    DIXFUN.PRW(102) warning W0008 Too few parameters calling HTTPGetStatus 
    DIXFUN.PRW(131) warning W0003 Local variable CEMPANT never used
    DIXFUN.PRW(131) warning W0003 Local variable CFILANT never used
    
   c:\users\rafael.conceicao\documents\github\desafiointelipost\fontes\middleware\mdware.prw...
Compilação finalizada - 3 arquivo(s) - 5 mensagem(s)

Tempo de duração da compilação: 16 segundos

```

# Testes

Após a configuração do Serviço e compilação de todos os fontes faça a seguinte chamada no seu browser, neste caso estamos utilizado um serviço externo, liberado na porta 8094.

```
http://187.62.210.102:8094/api/index/DESAFIOINTELIPOST
```
**Serviço disponível para testes pela Intelipost** :-) 

A Seguinte tela deverá Aparecer
![API](http://maxserver.net.br/rafael/API.png)

## Simulando o Sistema de Rastreamento

Conforme recomendado, foi utilizado o [POSTMAN](https://www.getpostman.com/) para simular o sistema de Rastreamento.

Configure o Postman para realizar um Post para o seguinte endereço:
```
http://187.62.210.102:8094/api/DESAFIOINTELIPOST
```

Conforme instruído no [Readme.md](https://github.com/intelipost/job-integration-developer/blob/master/README.md) do Desafio, existe um pequeno erro no layout, porém crucial para obtenção da informação, sem as virgulas antes das datas, não é possível Parsear o conteúdo corretamente a fim de obter todas as informações, após a correção utilize o seguinte Layout.

```
{
  	"order_id":123,
	"event":{
		"status_id":1**,**
		"date":"2018-02-02T10:45:32"
	},
	"package":{
		"package_id":1,
		"package_invoice":{
			"number":"9871236",
			"key":"01234567890123456789012345678901234567891234"**,**
			"date":"2018-02-01T10:45:32" 
		}
	}
}
```

O sistema deverá devolver o Status e a Mensagem:

```
{
    "errorCode": 400,
    "errorMessage": "ERRO NO ENVIO DO ARQUIVO PARA PLAT VENDAS"
}

```

## Simulando o Sistema de Vendas

O Sistema de vendas foi simulado com o link Resquestbin abaixo:

```
http://requestbin.fullcontact.com/1lsg0sk1
```
![RequestBin](http://maxserver.net.br/rafael/RequestBin.png)

O retorno do sistema irá devolver a seguinte mensagem:

```
{
    "message": "ENVIADO COM SUCESSO"
}
```
