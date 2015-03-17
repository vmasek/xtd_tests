# xtd_tests
Test for IPP XTD project by xmasek15 ( extended tests created by xholub31)

 
Zautomatizovane spustanie a testovanie jednotlivych situacii, doplnenych par 
detailov tykajucich sa caseinsensitivity. DDL a XML vystupy su testovane pomocou
3rd party tools - apgdiff  -> DDL diff tool
                - jexamxml -> xml diff tool
Oba su icludnute v ./tools/ ale vyzaduju nainstalovanu javu
V pripade nejasnosti alebo uprav kludne kontaktujte.

priadny `--hide` prepinac pre skript ktory "schova" OK testy a bude zobrazovat iba Errorove

Testy upravene a doplnene, par testov opravenych, pokial niekto najdete chybne alebo zavadzajuce vystupy prosim oznamit smile emoticon opravim, ak niekomu pada hned prvy test tak upozornujem ze v pripade --help ocakavam spravanie err.code=0 ak iba --help, ak su aj dalsie prarametre okrem neho zadane tak ocakavam chybu.



(Readme ponechane z minulej testovacej sady)

Struktura skriptu _stud_tests.sh (v kódování UTF-8):
Každý test zahrnuje až 4 soubory (vstupní soubor, případný druhý vstupní 
soubor, výstupní soubor, soubor logující chybové výstupy *.err vypisované na 
standardní chybový výstup (pro ilustraci) a soubor logující návratový kód 
skriptu *.!!!). Pro spuštění testů je nutné do stejného adresáře zkopírovat i 
váš skript. V komentářích u jednotlivých testů jsou uvedeny dodatečné 
informace jako očekávaný návratový kód. 

Proměnné ve skriptu _stud_tests.sh pro konfiguraci testů:
 INTERPRETER - využívaný interpret 
 EXTENSION - přípona souboru s vaším skriptem (jméno skriptu je dáno úlohou) 
 LOCAL_IN_PATH/LOCAL_OUT_PATH - testování různých cest ke vstupním/výstupním
   souborům
 
Další soubory archivu s doplňujícími testy:
V adresáři ref-out najdete referenční soubory pro výstup (*.out nebo *.xml), 
referenční soubory s návratovým kódem (*.!!!) a pro ukázku i soubory s 
logovaným výstupem ze standardního chybového výstupu (*.err). Pokud některé 
testy nevypisují nic na standardní výstup nebo na standardní chybový výstup, 
tak může odpovídající soubor v adresáři chybět nebo mít nulovou velikost.
V adresáři s tímto souborem se vyskytuje i soubor xtd_options 
pro nástroj JExamXML, který doporučujeme používat na porovnávání XML souborů. 
Další tipy a informace o porovnávání souborů XML najdete na Wiki IPP (stránka 
https://wis.fit.vutbr.cz/FIT/st/cwk.php?title=IPP:ProjectNotes&id=9999#XML_a_jeho_porovnávání).

Doporučení a poznámky k testování:
Tento skript neobsahuje mechanismy pro automatické porovnávání výsledků vašeho 
skriptu a výsledků referenčních (viz adresář ref-out). Pokud byste rádi 
využili tohoto skriptu jako základ pro váš testovací rámec, tak doporučujeme 
tento mechanismus doplnit.
Dále doporučujeme testovat různé varianty relativních a absolutních cest 
vstupních a výstupních souborů, k čemuž poslouží proměnné začínající 
LOCAL_IN_PATH a LOCAL_OUT_PATH (neomezujte se pouze na zde uvedené triviální 
varianty). 
Výstupní soubory mohou při spouštění vašeho skriptu již existovat a pokud není 
u zadání specifikováno jinak, tak se bez milosti přepíší!           
Výstupní soubory nemusí existovat a pak je třeba je vytvořit!
Pokud běh skriptu skončí s návratovou hodnotou různou od nuly, tak není 
vytvoření souboru zadaného parametrem --output nutné, protože jeho obsah 
stejně nelze považovat za validní.
V testech se jako pokaždé určitě najdou nějaké chyby nebo nepřesnosti, takže 
pokud nějakou chybu najdete, tak na ni prosím upozorněte ve fóru příslušné 
úlohy (konstruktivní kritika bude pozitivně ohodnocena). Vyhrazujeme si také 
právo testy měnit, opravovat a případně rozšiřovat, na což samozřejmě 
 upozorníme na fóru dané úlohy.
