#!/bin/bash

marcar_ponto() {
	dados=$(cat "$banco_dados" | grep "$dia_atual;$mes_atual;$ano_atual")
	linha_atual="${dados[0]}"

	if [ -z "$linha_atual" ]; then
		echo "$dia_atual;$mes_atual;$ano_atual;${marcacoes_padrao[@]};+00:00" >> $banco_dados
	fi
	
	echo "Confirmar marcação Dia: $dia_atual Horário: $hora_atual? (s/n)"
	read confirmar

	if [ "$confirmar" == "s" ]; then
		IFS=';' read -ra dados <<< "$linha_atual"
		
		tamanho=$(("${#dados[@]}" - 1))
		marcacoes=()

		for ((i=3; i < $tamanho; i++)); do
			indice_marcacao=$(($i - 3))
			marcacoes[$indice_marcacao]=${dados[$i]}
		done

		for ((i=0; i < "${#marcacoes[@]}"; i++)); do
		
			# Substituir na sequencia ENTRADA;SAIDA;ENTRADA;SAIDA			
			if [ "${marcacoes[$i]}" == "*" ]; then
				marcacoes[$i]=$hora_atual
				IFS=";" marcacoes_texto="${marcacoes[*]}"
				nova_linha="$dia_atual;$mes_atual;$ano_atual;$marcacoes_texto;+00:00;"
				
				echo "De: ${linha_atual} Por: ${nova_linha}"
				read
				
				sed -i "s/${linha_atual}/${nova_linha}/d" "$banco_dados"

				break
			fi

			# Última saída
			if [ "${marcacoes[$i]}" == "*" ] && [ $i -eq 4  ]; then
				marcacoes[$i]=$hora_atual
				nova_linha="$dia_atual;$mes_atual;$ano_atual;${marcacoes[@]};+00:00"
				horas_extra_dia=$(calcular_hora_extra_dia "${marcacoes[@]}")
				nova_linha="$dia_atual;$mes_atual;$ano_atual;${marcacoes[@]};$horas_extra_dia"
				
				sed -i "s/$linha_atual/$nova_linha/" $banco_dados
				break
			fi
		done

		visualizar_dia_atual
		read
	fi
}
