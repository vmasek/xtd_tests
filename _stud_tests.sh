#!/usr/bin/env bash

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# IPP - xtd - !!! UPRAVENE !!! doplňkové testy - 2014/2015
# 		by xmasek15 + extedned tests xholub31
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Činnost: 
# - vytvoří výstupy studentovy úlohy v daném interpretu na základě sady testů
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Popis (README):  
# 
# Zautomatizovane spustanie a testovanie jednotlivych situacii, doplnenych par 
# detailov tykajucich sa caseinsensitivity. DDL a XML vystupy su testovane pomocou
# 3rd party tools - apgdiff  -> DDL diff tool
#                 - jexamxml -> xml diff tool
# Oba su icludnute v ./tools/ ale vyzaduju nainstalovanu javu
# V pripade nejasnosti alebo uprav kludne kontaktujte.
# 
# 
# 
# (Readme ponechane z minulej testovacej sady)
#
# Struktura skriptu _stud_tests.sh (v kódování UTF-8):
# Každý test zahrnuje až 4 soubory (vstupní soubor, případný druhý vstupní 
# soubor, výstupní soubor, soubor logující chybové výstupy *.err vypisované na 
# standardní chybový výstup (pro ilustraci) a soubor logující návratový kód 
# skriptu *.!!!). Pro spuštění testů je nutné do stejného adresáře zkopírovat i 
# váš skript. V komentářích u jednotlivých testů jsou uvedeny dodatečné 
# informace jako očekávaný návratový kód. 
#
# Proměnné ve skriptu _stud_tests.sh pro konfiguraci testů:
#  INTERPRETER - využívaný interpret 
#  EXTENSION - přípona souboru s vaším skriptem (jméno skriptu je dáno úlohou) 
#  LOCAL_IN_PATH/LOCAL_OUT_PATH - testování různých cest ke vstupním/výstupním
#    souborům
#  
# Další soubory archivu s doplňujícími testy:
# V adresáři ref-out najdete referenční soubory pro výstup (*.out nebo *.xml), 
# referenční soubory s návratovým kódem (*.!!!) a pro ukázku i soubory s 
# logovaným výstupem ze standardního chybového výstupu (*.err). Pokud některé 
# testy nevypisují nic na standardní výstup nebo na standardní chybový výstup, 
# tak může odpovídající soubor v adresáři chybět nebo mít nulovou velikost.
# V adresáři s tímto souborem se vyskytuje i soubor xtd_options 
# pro nástroj JExamXML, který doporučujeme používat na porovnávání XML souborů. 
# Další tipy a informace o porovnávání souborů XML najdete na Wiki IPP (stránka 
# https://wis.fit.vutbr.cz/FIT/st/cwk.php?title=IPP:ProjectNotes&id=9999#XML_a_jeho_porovnávání).
#
# Doporučení a poznámky k testování:
# Tento skript neobsahuje mechanismy pro automatické porovnávání výsledků vašeho 
# skriptu a výsledků referenčních (viz adresář ref-out). Pokud byste rádi 
# využili tohoto skriptu jako základ pro váš testovací rámec, tak doporučujeme 
# tento mechanismus doplnit.
# Dále doporučujeme testovat různé varianty relativních a absolutních cest 
# vstupních a výstupních souborů, k čemuž poslouží proměnné začínající 
# LOCAL_IN_PATH a LOCAL_OUT_PATH (neomezujte se pouze na zde uvedené triviální 
# varianty). 
# Výstupní soubory mohou při spouštění vašeho skriptu již existovat a pokud není 
# u zadání specifikováno jinak, tak se bez milosti přepíší!           
# Výstupní soubory nemusí existovat a pak je třeba je vytvořit!
# Pokud běh skriptu skončí s návratovou hodnotou různou od nuly, tak není 
# vytvoření souboru zadaného parametrem --output nutné, protože jeho obsah 
# stejně nelze považovat za validní.
# V testech se jako pokaždé určitě najdou nějaké chyby nebo nepřesnosti, takže 
# pokud nějakou chybu najdete, tak na ni prosím upozorněte ve fóru příslušné 
# úlohy (konstruktivní kritika bude pozitivně ohodnocena). Vyhrazujeme si také 
# právo testy měnit, opravovat a případně rozšiřovat, na což samozřejmě 
# upozorníme na fóru dané úlohy.
#
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# EDIT to correct path and scriptname !!!
PATH_TO_XTD=$(pwd) # or any other path to your script
TASK=xtd # name of script

PATH_TO_TESTS=$(pwd)
PATH_TO_apgdiff="$PATH_TO_TESTS/tools/apgdiff-2.4/"
PATH_TO_jexamxml="$PATH_TO_TESTS/tools/jexamxml/"


INTERPRETER="php -d open_basedir=\"\""
EXTENSION=php

# or for python
#INTERPRETER=python3
#EXTENSION=py


# cesty ke vstupním a výstupním souborům
LOCAL_IN_PATH="./" # (simple relative path) 
LOCAL_IN_PATH2="" #Alternative 1 (primitive relative path)
LOCAL_IN_PATH3="$PATH_TO_TESTS/" #Alternative 2 (absolute path)
LOCAL_OUT_PATH="./out/" # (simple relative path)
LOCAL_OUT_PATH2="out/" #Alternative 1 (primitive relative path)
LOCAL_OUT_PATH3="$PATH_TO_TESTS/out/" #Alternative 2 (absolute path)
# cesta pro ukládání chybového výstupu studentského skriptu
LOG_PATH="./out/"


TESTS_OPTIONS=(	
					"--help > ${LOCAL_OUT_PATH}test01.out 2> ${LOG_PATH}test01.err"
					"--output=${LOCAL_OUT_PATH}test02.out < ${LOCAL_IN_PATH}test02.in 2> ${LOG_PATH}test02.err"
					"--input=${LOCAL_IN_PATH}test03.in > ${LOCAL_OUT_PATH}test03.out 2> ${LOG_PATH}test03.err"
					"--input=${LOCAL_IN_PATH2}test04.in --output=${LOCAL_OUT_PATH2}test04.out --etc=2 2> ${LOG_PATH}test04.err"
					"--etc=0 < ${LOCAL_IN_PATH}test05.in > ${LOCAL_OUT_PATH}test05.out 2> ${LOG_PATH}test05.err"
					"--output=${LOCAL_OUT_PATH3}test06.out -a < ${LOCAL_IN_PATH}test06.in 2> ${LOG_PATH}test06.err"
					"--input=${LOCAL_IN_PATH2}test07.in -b > ${LOCAL_OUT_PATH3}test07.out 2> ${LOG_PATH}test07.err"
					"--input=${LOCAL_IN_PATH3}test08.in --output=${LOCAL_OUT_PATH}test08.out --etc=2 --header='Takto pak vypadá hlavička výstupního souboru' 2> ${LOG_PATH}test08.err"
					"--input=${LOCAL_IN_PATH}test09.in --output=${LOCAL_OUT_PATH}test09.out --etc=2 -b 2> ${LOG_PATH}test09.err"
					"--input=${LOCAL_IN_PATH}test10.in --output=${LOCAL_OUT_PATH}test10.out --etc=2 2> ${LOG_PATH}test10.err"
					"--output=${LOCAL_OUT_PATH}test11.out -g < ${LOCAL_IN_PATH}test11.in 2> ${LOG_PATH}test11.err"
					"--input=${LOCAL_IN_PATH2}test12.in --etc=2 -g --output=${LOCAL_OUT_PATH}test12.out 2> ${LOG_PATH}test12.err"
					"--input=${LOCAL_IN_PATH}test13.in --output=${LOCAL_OUT_PATH}test13.out --etc=2 2> ${LOG_PATH}test13.err"
					"--input=${LOCAL_IN_PATH2}test14.in -b > ${LOCAL_OUT_PATH3}test14.out 2> ${LOG_PATH}test14.err"
					"--inpput=${LOCAL_IN_PATH2}test03.in 2> ${LOG_PATH}testA01.err"														#not my tests
					"--input=${LOCAL_IN_PATH2}test03.in --help -g 2> ${LOG_PATH}testA02.err"
					"--input=${LOCAL_IN_PATH2}test03.in --etc=2 -b 2> ${LOG_PATH}testA03.err"
					"--input=${LOCAL_IN_PATH2}test03.in --input=${LOCAL_IN_PATH2}testA04.in --etc=2 -b 2> ${LOG_PATH}testA04.err"
					"< ${LOCAL_IN_PATH}testA05.in > ${LOCAL_OUT_PATH}testA05.out 2> ${LOG_PATH}testA05.err"
					"--input=./asdasdadadasdadasdadddewetest666.in 2> ${LOG_PATH}testB01.err"
					"--input=./asdasdadadasdadasdadddewetest666.in -g --help 2> ${LOG_PATH}testB02.err"
					"--input=./asdasdadadasdadasdadddewetest666.in --etc=2 -b 2> ${LOG_PATH}testB03.err"
					"--input=./testB04.in 2> ${LOG_PATH}testB04.err"
					"--input=./test03.in --output=./read_only/testB05.out 2> ${LOG_PATH}testB05.err"
					"--input=./testC01.in > ${LOCAL_OUT_PATH}testC01.out 2> ${LOG_PATH}testC01.err"
					"--input=./testC02.in > ${LOCAL_OUT_PATH}testC02.out 2> ${LOG_PATH}testC02.err"
					"--input=./testC03.in > ${LOCAL_OUT_PATH}testC03A.out 2> ${LOG_PATH}testC03A.err"
					"--input=./testC03.in -a > ${LOCAL_OUT_PATH}testC03B.out 2> ${LOG_PATH}testC03B.err"
					"--input=./testC04.in > ${LOCAL_OUT_PATH}testC04.out 2> ${LOG_PATH}testC04.err"
					"--input=./testC05.in > ${LOCAL_OUT_PATH}testC05.out 2> ${LOG_PATH}testC05.err"
					"--input=./testC06.in > ${LOCAL_OUT_PATH}testC06.out 2> ${LOG_PATH}testC06.err"
					"--input=./testC07.in --etc=10 > ${LOCAL_OUT_PATH}testC07A.out 2> ${LOG_PATH}testC07A.err"
					"--input=./testC07.in --etc=2 > ${LOCAL_OUT_PATH}testC07B.out 2> ${LOG_PATH}testC07B.err"
					"--input=./testC07.in --etc=1 > ${LOCAL_OUT_PATH}testC07C.out 2> ${LOG_PATH}testC07C.err"
					"--input=./testC07.in --etc=0 > ${LOCAL_OUT_PATH}testC07D.out 2> ${LOG_PATH}testC07D.err"
					"--input=./testC07.in -b > ${LOCAL_OUT_PATH}testC07E.out 2> ${LOG_PATH}testC07E.err"
					"--input=./testC07.in -b -a > ${LOCAL_OUT_PATH}testC07F.out 2> ${LOG_PATH}testC07F.err"
					"--input=./testC08.in --output=${LOCAL_OUT_PATH}testC08.out 2> ${LOG_PATH}testC08.err"
					"--input=./testC09.in --output=${LOCAL_OUT_PATH}testC09.out 2> ${LOG_PATH}testC09.err"
					"--input=./testC10.in --output=${LOCAL_OUT_PATH}testC10.out 2> ${LOG_PATH}testC10.err"
					"--input=./testC11.in --output=${LOCAL_OUT_PATH}testC11.out 2> ${LOG_PATH}testC11.err"
					"--input=./testC12.in --output=${LOCAL_OUT_PATH}testC12.out 2> ${LOG_PATH}testC12.err"
					"--input=./testF01.in --output=${LOCAL_OUT_PATH}testF01.out 2> ${LOG_PATH}testF01.err"
					"--input=./testG01.in -g --output=${LOCAL_OUT_PATH}testG01.out 2> ${LOG_PATH}testG01.err"
					"--input=./testG02.in -g --output=${LOCAL_OUT_PATH}testG02.out 2> ${LOG_PATH}testG02.err"
					"--input=./testG03.in -g --output=${LOCAL_OUT_PATH}testG03.out 2> ${LOG_PATH}testG03.err"
					"--input=./testG04.in -g --output=${LOCAL_OUT_PATH}testG04.out 2> ${LOG_PATH}testG04.err"
					"--input=./testG05.in -g --output=${LOCAL_OUT_PATH}testG05.out 2> ${LOG_PATH}testG05.err"
					"--input=./testG06.in -g --output=${LOCAL_OUT_PATH}testG06.out 2> ${LOG_PATH}testG06.err"
					"--input=./testG07.in -g --output=${LOCAL_OUT_PATH}testG07.out 2> ${LOG_PATH}testG07.err"
					"--input=./testC07.in -g --etc=2 --output=${LOCAL_OUT_PATH}testG09A.out 2> ${LOG_PATH}testG09A.err"
					"--input=./testC07.in -g --etc=0 --output=${LOCAL_OUT_PATH}testG09B.out 2> ${LOG_PATH}testG09B.err"
					"--input=./testC07.in -g -a -b --output=${LOCAL_OUT_PATH}testG09C.out 2> ${LOG_PATH}testG09C.err"
					"--input=./testG20.in -g --output=${LOCAL_OUT_PATH}testG20.out 2> ${LOG_PATH}testG20.err"

					"--input=./test03.in --isvalid=./testH01.in --output=${LOCAL_OUT_PATH}testH01.out 2> ${LOG_PATH}testH01.err"
					"--input=./test03.in --isvalid=./testH02.in --output=${LOCAL_OUT_PATH}testH02.out 2> ${LOG_PATH}testH02.err"
					"--input=./test03.in --isvalid=./testH03.in --output=${LOCAL_OUT_PATH}testH03A.out 2> ${LOG_PATH}testH03A.err"
					"--input=./test03.in --isvalid=./testH03.in -a --output=${LOCAL_OUT_PATH}testH03B.out 2> ${LOG_PATH}testH03B.err"
					"--input=./test03.in --isvalid=./testH04.in --output=${LOCAL_OUT_PATH}testH04.out 2> ${LOG_PATH}testH04.err"
					"--input=./test03.in --isvalid=./testH05.in --output=${LOCAL_OUT_PATH}testH05A.out 2> ${LOG_PATH}testH05A.err"
					"--input=./test03.in --isvalid=./testH05.in -b --output=${LOCAL_OUT_PATH}testH05B.out 2> ${LOG_PATH}testH05B.err"
					"--input=./test03.in --isvalid=./testH06.in --output=${LOCAL_OUT_PATH}testH06.out 2> ${LOG_PATH}testH06.err"
			

			)



TESTS_RET_CODES=(	
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"1"
					"90"
					"0"
					"0"
					"90"
					"0"
					"1"  #not my err.codes
					"1"
					"1"
					"1"
					"0"
					"2"
					"1"
					"1"
					"2"
					"3"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"90"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"
					"0"

					"0"
					"91"
					"91"
					"0"
					"91"
					"91"
					"0"
					"0"

				)

TESTS=(
		"test01"
		"test02"
		"test03"
		"test04"
		"test05"
		"test06"
		"test07"
		"test08"
		"test09"
		"test10"
		"test11"
		"test12"
		"test13"
		"test14"
		"testA01"
		"testA02"
		"testA03"
		"testA04"
		"testA05"
		"testB01"
		"testB02"
		"testB03"
		"testB04"
		"testB05"
		"testC01"
		"testC02"
		"testC03A"
		"testC03B"
		"testC04"
		"testC05"
		"testC06"
		"testC07A"
		"testC07B"
		"testC07C"
		"testC07D"
		"testC07E"
		"testC07F"
		"testC08"
		"testC09"
		"testC10"
		"testC11"
		"testC12"
		"testF01"
		"testG01"
		"testG02"
		"testG03"
		"testG04"
		"testG05"
		"testG06"
		"testG07"
		"testG09A"
		"testG09B"
		"testG09C"
		"testG20"

		"testH01"
		"testH02"
		"testH03A"
		"testH03B"
		"testH04"
		"testH05A"
		"testH05B"
		"testH06"
	)


red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m' # No Color

if [[ $1 == "--hide" ]]; then
	hide_ok=true
else
	hide_ok=false
fi


rm ./out/* 2>/dev/null

counter=0

for options in "${TESTS_OPTIONS[@]}"
do

	eval $INTERPRETER "$PATH_TO_XTD/$TASK.$EXTENSION" ${options}
	code=$?

	if [[ $code -ne "${TESTS_RET_CODES[$counter]}" ]]; then
		echo
		echo "-------------------test ${TESTS[$counter]} -------------------------------------"

		echo -e "${red}ERROR${NC} failed with exit code $code"
		#exit 1
	else

		# correct error tests
		if [[ ${TESTS_RET_CODES[$counter]} != "0" || ${TESTS[$counter]} == "test01" ]]; then

			if [[ $hide_ok == false ]]; then
				echo
				echo "-------------------test ${TESTS[$counter]} -------------------------------------"
				echo -e "${green}TEST OK${NC}"
			fi
			
		 	((++counter))
			continue
		fi

		#running diff tools
		if [[ ${TESTS[$counter]} == "test11" || ${TESTS[$counter]} == "test12" || ${TESTS[$counter]} == *G* ]]; then

			java -jar "$PATH_TO_jexamxml"jexamxml.jar ./out/${TESTS[$counter]}.out ./ref-out/${TESTS[$counter]}.out delta.xml xtd_options &> ./out/${TESTS[$counter]}_diff.ddl

			if [[ $(cat ./out/${TESTS[$counter]}_diff.ddl) =~ "Two files are identical" ]]; then
				rm out/${TESTS[$counter]}_diff.ddl 2>/dev/null
			fi

		else
			java -jar "$PATH_TO_apgdiff"apgdiff-2.4.jar ./out/${TESTS[$counter]}.out ./ref-out/${TESTS[$counter]}.out &> ./out/${TESTS[$counter]}_diff.ddl
		fi

		if [[ $? -ne 0 || -s out/${TESTS[$counter]}_diff.ddl ]]; then
			echo
			echo "-------------------test ${TESTS[$counter]} -------------------------------------"
			echo -e "${red}diff error ?! you sholuld probably check it${NC}"
			echo -e "${red}ERROR${NC}"
		else
			if [[ $hide_ok == false ]]; then
				echo
				echo "-------------------test ${TESTS[$counter]} -------------------------------------"
				echo -e "${green}TEST OK${NC}"
			fi
			rm out/${TESTS[$counter]}_diff.ddl 2>/dev/null
		fi

	fi

	#delete empty .err
	if [[ ! -s out/${TESTS[$counter]}.err ]]; then
		rm out/${TESTS[$counter]}.err 2>/dev/null
	fi

	((++counter))
done


echo
echo

