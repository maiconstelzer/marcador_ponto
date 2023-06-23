#!/bin/bash

linha_cabecalho='------------------------------------------------------------'

montar_cabecalho_geral() {
	cabecalho_geral="$linha_cabecalho"
	cabecalho_geral="$cabecalho_geral \n+++ Barra Bin LTDA X Myrp Solucoes Empresarias +++"
	cabecalho_geral="$cabecalho_geral \n\nFuncionário: $funcionario"
	cabecalho_geral="$cabecalho_geral \nTotal Geral: $1"
	cabecalho_geral="$cabecalho_geral \n$linha_cabecalho"
	
	echo -e "$cabecalho_geral"
}

montar_cabecalho_dados() {
	cabecalho_dados="Referência: $1/$2"
	cabecalho_dados="$cabecalho_dados\n$linha_cabecalho"
	cabecalho_dados="$cabecalho_dados\nDia\t\tMarcações\t\t\tHoras Extras"
	cabecalho_dados="$cabecalho_dados\n$linha_cabecalho"
	echo -e "$cabecalho_dados"
}

visualizar_dados() {
	filtro=$1
	linhasArquivo=$(cat "$banco_dados" | grep $filtro)
	texto=""
	mes_controle=""
	ano_controle=""
	horas_extras_array=()
	
	for linha in "${linhasArquivo[@]}"; do
		IFS=';' read -ra dados <<< "$linha"
		
		mes_atual=${dados[1]}
		ano_atual=${dados[2]}

		if [[ $mes_controle != $mes_atual && $ano_controle != $ano_atual ]]; then
			mes_controle=$mes_atual
			ano_controle=$ano_atual
			
			texto="$texto \n $(montar_cabecalho_dados $mes_controle $ano_controle)"
		fi
		
		tamanho=$(("${#dados[@]}" - 1))
		marcacoes=()
		horas_extras_array+=(${dados[$tamanho]})
		
		for ((i=3; i < $tamanho; i++)); do
			marcacoes[$i-3]=${dados[$i]}
		done
		
		clear
		texto="$texto\n${dados[0]}\t\t${marcacoes[@]}\t\t\t\t${dados[$tamanho]}"
	done
	
	total_hora_extra=$(calcular_hora_extra_geral $horas_extras_array)
	cabecalho_geral=$(montar_cabecalho_geral $total_hora_extra)
	
	echo -e "$cabecalho_geral"
	echo -e "$texto"
	echo -e "$linha_cabecalho"
}

visualizar_dia_atual() {
	visualizar_dados "$dia_atual;$mes_atual;$ano_atual"
	read
}

visualizar_mes_atual() {
	visualizar_dados "$mes_atual;$ano_atual"
	read
}

visualizar_ano_atual() {
	visualizar_dados "$ano_atual"
	read
}
