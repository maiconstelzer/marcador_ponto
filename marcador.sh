#!/bin/bash

configurar() {
	local_config=~/.config/marcador_ponto
	config="$local_config/marcador.conf"
	banco="$config/banco.txt"
	funcionario=''

	if [ ! -d $local_config ]; then
		mkdir $local_config
	fi
	
	if [ ! -f $banco ]; then
		touch $banco
	fi

	if [ -f $config ]; then
		. $config
	else
		echo "Inicializando configuração nova em $config"
		echo $funcionario >> $config
	fi
}

marcar() {
	local data=$(date +%d/%m/%Y)
	local horario=$(date +%H:%M:%S)

	echo "Marcação -> $data $horario"
	read -p "Marcar? (s = sim) " opcao

	if [ "$opcao" == "s" ]; then
		echo "$data $horario" >> $banco
	fi

	echo 'Marcações de hoje:'
	filtrar_banco $data
	read -p 'Pressione uma tecla para continuar...'
}

filtrar_banco() {
	echo "$(grep '$1' $banco)"
}

visualizar() {
	echo '1 - Dia atual'
	echo '2 - Mês atual'
	echo '3 - Ano atual'
	echo

	read -p 'Selecione uma opção: ' opcao

	case $opcao in
		1)
		filtrar_banco $(date +%d/%m/%Y)
		;;

		2)
		filtrar_banco $(date +/%m/%Y)
		;;

		3)
		filtrar_banco $(date +/%Y)
		;;

		*)
		read -p 'Opção inválida...'
		return
		;;
	esac

	read -p 'Pressione uma tecla para continuar...'
}

obter_dados() {
	readarray -t dados <<< "$(filtrar_banco $1)"
}

exportar() {
	echo '1 - Dia atual'
	echo '2 - Mês atual'
	echo '3 - Ano atual'
	echo

	read -p 'Selecione uma opção: ' opcao

	case $opcao in
		1)
		obter_dados $(date +%d/%m/%Y)
		;;

		2)
		obter_dados $(date +/%m/%Y)
		;;

		3)
		obter_dados $(date +/%Y)
		;;

		*)
		read -p 'Opção inválida...'
		return
		;;
	esac

	echo 'Dados obtidos:'
	for dado in ${dados[@]}; do
		echo $dado
	done

	read -p 'Continuar? (s = sim) '
}

menu() {
	echo 'By ST3LZ3R'
	echo
	echo '1 - Marcar'
	echo '2 - Visualizar'
	echo '3 - Exportar'
	echo
	read -p 'Selecione uma opção: ' opcao

	case $opcao in
		1)
		marcar
		menu
		;;

		2)
		visualizar
		menu
		;;

		3)
		exportar
		menu
		;;
		
		*)
		menu
		;;
	esac
}

configurar
menu

