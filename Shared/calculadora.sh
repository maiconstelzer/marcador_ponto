#!/bin/bash
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
