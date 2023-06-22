#!/bin/bash

# ------------------------------------------------------------------------------------------------
# |							   Variáveis Globais                                                 |
# ------------------------------------------------------------------------------------------------
dia_atual=$(date +%d)
mes_atual=$(date +%m)
ano_atual=$(date +%Y)

marcacoes_padrao=("09:00" "12:00" "13:00" "18:00")

banco_dados="banco_dados.txt"

[ ! -f "$banco_dados" ] && echo "$dia_atual;$mes_atual;$ano_atual;${marcacoes_padrao[@]// /;};+00:00" > "$banco_dados"

linha_cabecalho='------------------------------------------------------------'

# ------------------------------------------------------------------------------------------------
# |									 	 Funções                                                 |
# ------------------------------------------------------------------------------------------------
montar_cabecalho_geral() {
	cabecalho_geral="$linha_cabecalho"
	cabecalho_geral="$cabecalho_geral \n+++ Barra Bin LTDA X Myrp Solucoes Empresarias +++"
	cabecalho_geral="$cabecalho_geral \n\nFuncionário: Maicon Douglas Stelzer"
	cabecalho_geral="$cabecalho_geral \nTotal Geral: $1"
	cabecalho_geral="$cabecalho_geral \n$linha_cabecalho"
	
	echo -e "$cabecalho_geral"
}

montar_cabecalho_dados() {
	cabecalho_dados="Referência: $1/$2"
	cabecalho_dados="$cabecalho_dados \n $linha_cabecalho"
	cabecalho_dados="$cabecalho_dados \n Dia \t\t     Marcações \t\t\t Horas Extras"
	cabecalho_dados="$cabecalho_dados \n $linha_cabecalho"
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
		# Estrutura gravaçao DIA;ENTRADA1;SAIDA1;ENTRADA2;SAIDA2;ENTRADA(N);SAIDA(N);HORAS_EXTRAS
		
		IFS=';' read -ra dados <<< "$linha"
		
		mes_atual=${dados[1]}
		ano_atual=${dados[2]}

		if [[ $mes_controle != $mes_atual && $ano_controle != $ano_atual ]]; then
			mes_controle=$mes_atual
			ano_controle=$ano_atual
			
			texto="$texto \n $(montar_cabecalho_dados $mes_controle $ano_controle)"
		fi
		
		tamanho=$(("${#dados[@]}" - 1))
		marcacoes=("09:00" "12:00" "13:00" "18:00")
		horas_extras_array+=(${dados[$tamanho]})
		
		for ((i=3; i < $tamanho; i++)); do
			marcacoes[$i-3]=${dados[$i]}
		done
		
		
		texto="$texto \n ${dados[0]}\t\t${marcacoes[@]}\t\t${dados[$tamanho]}"
	done
	
	total_hora_extra=$(calcular_hora_extra_geral $horas_extras_array)
	cabecalho_geral=$(montar_cabecalho_geral $total_hora_extra)
	
	echo -e "$cabecalho_geral"
	echo -e "$texto"
	echo -e "$linha_cabecalho"
}

visualizar_dia_atual() {
	visualizar_dados "$dia_atual;$mes_atual;$ano_atual"
}

visualizar_mes_atual() {
	visualizar_dados "$mes_atual;$ano_atual"
}

visualizar_ano_atual() {
	visualizar_dados "$ano_atual"
}

calcular_hora_extra_geral() {
	listaHoras=$1
	horario="00:00"
	segundos_horario=$(date -d "$horario" +"%s")
	
	for hora in "${listaHoras[@]}"; do
	
		quantidade="${hora//+/}"
		quantidade="${hora//-/}"
		
		# Converter horas extras para segundos
		IFS=':' read -r -a hora_array <<< "$hora"
		total_segundos=$((hora_array[0] * 3600 + hora_array[1] * 60))
		
		
			
		if [[ "$hora" == *"+"* ]]; then
			# Somar os segundos do horário e os segundos das horas extras
			segundos_totais=$((segundos_horario + duracao_segundos))
		else
			# Subtrair os segundos do horário e os segundos das horas extras
			segundos_totais=$((segundos_horario - duracao_segundos))
		fi
		
		horario=$(date -d @"$segundos_totais" +"%H:%M")
		segundos_horario=$(date -d "$horario" +"%s")
	done
	
	IFS=':' read -r -a horario_final <<< "$horario"
	if [ ${horario_final[0]} -gt 15 ]; then
		horas_negativas=$((horario_final[0] - 24))
		minutos_negativos=$((horario_final[1] - 60))
		
		echo "-$horas_negativas:minutos_negativos"
	else
		echo "+$horario"
	fi
}

calcular_hora_extra_dia() {
	listaHoras=$1
	horario="00:00"
	segundos_horario=$(date -d "$horario" +"%s")
	
	for ((i=0; i < ${#listaHoras[@]}; i++)); do
		marcacao_padrao=${marcacoes_padrao[$i]}
		hora=${listaHoras[$i]}
		
		IFS=':' read -r -a hora_array <<< "$hora"
		IFS=':' read -r -a marcacao_padrao_array <<< "$marcacao_padrao"
		
		total_segundos_hora=$((hora_array[0] * 3600 + hora_array[1] * 60))
		total_segundos_marcacao=$((marcacao_padrao_array[0] * 3600 + marcacao_padrao_array[1] * 60))
		
		if [ $total_segundos_hora > $total_segundos_marcacao ]; then
		
			total_somar=$((total_segundos_hora - total_segundos_marcacao))
			
			# Somar os segundos de horas extras
			segundos_totais=$((segundos_horario + total_somar))
		else
			total_subtrair=$((total_segundos_marcacao - total_segundos_hora))
			
			# Subtrair os segundos de horas extras
			segundos_totais=$((segundos_horario - total_subtrair))
		fi
		
		horario=$(date -d @"$segundos_totais" +"%H:%M")
		segundos_horario=$(date -d "$horario" +"%s")	
	done
		
	IFS=':' read -r -a horario_final <<< "$horario"
	if [ ${horario_final[0]} -gt 15 ]; then
		horas=${horario_final[0]}
		minutos=${horario_final[1]}
		horas_negativas=$((horas - 24))
		minutos_negativos=$((minutos - 60))
		
		echo "-$horas_negativas:minutos_negativos"
	else
		echo "+$horario"
	fi
}

# ------------------------------------------------------------------------------------------------
# |									 	Execução                                                 |
# ------------------------------------------------------------------------------------------------