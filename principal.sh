#!/bin/bash

# ------------------------------------------------------------------------------------------------
# |							   Importações		                                                 |
# ------------------------------------------------------------------------------------------------
source "Shared/marcar.sh"
source "Shared/visualizacao.sh"
source "Shared/calculadora.sh"

# ------------------------------------------------------------------------------------------------
# |							   Variáveis Globais                                                 |
# ------------------------------------------------------------------------------------------------
dia_atual=$(date +%d)
mes_atual=$(date +%m)
ano_atual=$(date +%Y)
hora_atual=$(date +%H:%M)

opcao_selecionada="0"
marcacoes_padrao=("*" "*" "*" "*")
funcionario='Maicon Douglas Stelzer'

# ------------------------------------------------------------------------------------------------
# |							   Funções			                                                 |
# ------------------------------------------------------------------------------------------------
apresentar_menu() {
	clear
	echo
	echo '╔╦╗┌─┐┬─┐┌─┐┌─┐┌┬┐┌─┐┬─┐  ╔═╗┌─┐┌┐┌┌┬┐┌─┐'
	echo '║║║├─┤├┬┘│  ├─┤ │││ │├┬┘  ╠═╝│ ││││ │ │ │'
	echo '╩ ╩┴ ┴┴└─└─┘┴ ┴─┴┘└─┘┴└─  ╩  └─┘┘└┘ ┴ └─┘'
	echo
	echo '	  ╦╦╦╦╦╦▄▀▀▀▀▀▀▄╦╦╦╦╦╦'
	echo '	  ▒▓▒▓▒█╗░░▐░░░╔█▒▓▒▓▒'
	echo '	  ▒▓▒▓▒█║░░▐▄▄░║█▒▓▒▓▒'
	echo '	  ▒▓▒▓▒█╝░░░░░░╚█▒▓▒▓▒'
	echo '	  ╩╩╩╩╩╩▀▄▄▄▄▄▄▀╩╩╩╩╩╩'
	echo
	echo '               By ST3LZ3R'
	echo
	echo '1 - Visualização diária'
	echo '2 - Visualização mensal'
	echo '3 - Visualização anual'
	echo '4 - Marcar ponto'
	echo
	echo 'Selecione uma opção...'

	read opcao_selecionada
}

executar_opcao() {
	case $opcao_selecionada in
		1)
			visualizar_dia_atual
			;;
		2)
			visualizar_mes_atual
			;;
		3)
			visualizar_ano_atual
			;;
		4)
			marcar_ponto
			;;
		*)
			echo 'Opção inválida...'
			;;
	esac
	
	apresentar_menu
	executar_opcao
}


# ------------------------------------------------------------------------------------------------
# |							   Execução			                                                 |
# ------------------------------------------------------------------------------------------------
banco_dados="Banco/banco_dados.txt"
IFS=";" marcacoes_padrao_texto="${marcacoes_padrao[*]}"
linha_padrao="$dia_atual;$mes_atual;$ano_atual;${marcacoes_padrao_texto[@]};+00:00;"
[ ! -f "$banco_dados" ] && echo "$linha_padrao"  > "$banco_dados"

apresentar_menu
executar_opcao
