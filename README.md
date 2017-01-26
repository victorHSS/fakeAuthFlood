# fakeAuthFlood

Esse é um script para realização de DoS em redes WEP OPN ou WEP SKA.
Basicamente o script realiza uma quantidade especificada de falsas associações. Isso faz com que a tabela de clientes
do Access Point fique cheia impedindo clientes legítimos da rede de se associarem ao AP.

Uso: ./fakeAuthFlood.sh COMANDO ...

Onde:
  COMANDO ARGS			DESCRIÇAO

  generate	NUM	-->	escreve no stdout NUM MACs

  fakeauth_opn	NUM ESSID	-->	realiza NUM falsas autenticacoes na rede ESSID

  fakeauth_ska	NUM ESSID XOR	--> realiza NUM falsas autenticacoes na rede ESSID usando keystream do arquivo XOR
