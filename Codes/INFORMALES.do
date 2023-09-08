*****

clear all
set dp comma

import delimited "C:\Users\nicol.NICOLAS_GP\OneDrive\Escritorio\Portafolio\My Work\Extra\Andrés Aristizabal\GEIH_2023_mayo.csv"

d

** https://www.statalist.org/forums/forum/general-stata-discussion/general/1159629-rename-all-variables-with-lowercase
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}

gen ANIOS=PER-1
gen OFICIO_C8_2D="."
replace OFICIO_C8_2D = substr(OFICIO_C8, 1, 2) 
*destring OFICIO_C8_2D, replace


destring OFICIO_C8_2D P6430 P3045S1 P3046 P3069 P6765 P3065 P3066 OFICIO_C8_2D P3067S2 P3067 P3067S1 P6775 P3068 P6110 P6100 P6450 P6920 P6930 P6940,force replace

*destring P6930 ,force replace


*destring P6016-OFICIO_C8_2D, replace force


*
*drop FORMAL

gen FORMAL=. if P6430==3
replace FORMAL=0 if P6430==6
replace FORMAL=1 if (RAMA2D_R4 == "84" |   RAMA2D_R4 == "99" )
replace FORMAL=0 if P6430==8 


*ASALARIADOS

replace FORMAL=1 if P6430 ==2
replace FORMAL=1 if (P6430 ==1 |  P6430 ==7) & (P3045S1==1)
replace FORMAL=1 if (P6430 ==1 |  P6430 ==7) & ((P3045S1==2  | P3045S1==9 ) & P3046 == 1)
replace FORMAL=0 if (P6430 ==1  | P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 2)
replace FORMAL=1 if (P6430 ==1 |  P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 9) & (P3069>= 4)
replace FORMAL=0 if (P6430 ==1  | P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 9) & (P3069 <= 3)

*INDEPENDIENTES/
*SIN NEGOCIO/

replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & P3065==1
replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 | P3065==9) & P3066==1
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 |  P3065==9) & P3066==2
replace FORMAL=1 if (P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 | P3065==9) & P3066==9 & P3069 >= 4
replace FORMAL=0 if (P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & P3069 <= 3
replace FORMAL=1 if (P6430 ==4) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20)
replace FORMAL=0 if (P6430 ==4) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & (OFICIO_C8_2D >=21)

*CON NEGOCIO/
*CON REGISTRO MERCANTIL/

replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==1 & P3067S2 >= ANIOS
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==1 & P3067S2 < ANIOS
replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==1
replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==3 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20)
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==3 & (OFICIO_C8_2D >=21)
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==2
replace FORMAL=1 if (P6430 ==4 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20)
replace FORMAL=0 if (P6430 ==4 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & (OFICIO_C8_2D >=21)
replace FORMAL=1 if (P6430 ==5 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & P3069 >= 4 
replace FORMAL=0 if (P6430 ==5 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & P3069 <= 3 


*SIN REGISTRO MERCANTIL/

replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==1 & P3068==1
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==1 & P3068==2
replace FORMAL=1 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==3 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20)
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==3 & (OFICIO_C8_2D >=21)
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==1 & P3068==9
replace FORMAL=0 if (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==2
replace FORMAL=1 if (P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==9 & P3069 >= 4
replace FORMAL=0 if (P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==9 & P3069 <= 3
replace FORMAL=1 if (P6430 ==4) & (P6765 == 7) & P3067==2 & P6775==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20)
replace FORMAL=0 if (P6430 ==4) & (P6765 == 7) & P3067==2 & P6775==9 & (OFICIO_C8_2D >=21)


*SALUD/

gen SALUD=0
replace SALUD=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & (P6100 ==1 |P6100 ==2) & (P6110 ==1 | P6110 ==2 | P6110 ==4)
replace SALUD=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & (P6100==9) & (P6450==2)
replace SALUD=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & (P6110==9) & (P6450==2)


*PENSIÓN/

destring P6940, force replace

gen PENSION=0
replace PENSION=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & P6920==3
replace PENSION=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & P6920==1 & (P6930 ==1 |P6930 ==2 |P6930 ==3) & (P6940 ==1 | P6920 ==3)


*OCUPACIÓN INFORMAL/
*drop EI

gen EI=0 
replace EI=FORMAL if (P6430 ==4 | P6430 ==5) 
replace EI=1 if (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & SALUD==1 & PENSION==1
replace EI=1 if P6430==4 & (RAMA2D_R4=="84" | RAMA2D_R4=="99")

*keep if YEAR == 2023

*keep if OCI == "1"

*keep if AREA== "63"

destring DPTO, replace

destring AREA, ignore(`NA') force replace

table DPTO EI [iw= FEX_C18 /3] if (MES == 1 | MES == 2 | MES == 3 ) & YEAR == 2022 & OCI == "1"


table AREA EI [iw= FEX_C18 /3] if (MES == 1 | MES == 2 | MES == 3 ) & YEAR == 2022 & OCI == "1"

gen INFORMAL = EI if OCI == "1"

table AREA INFORMAL [iw= FEX_C18 /3] if (MES == 1 | MES == 2 | MES == 3 ) & YEAR == 2022 & OCI == "1"


keep DIRECTORIO SECUENCIA_P ORDEN YEAR MES DPTO  INFORMAL 

cd "C:\Users\nicol.NICOLAS_GP\OneDrive\Escritorio\Portafolio\My Work\Extra\Andrés Aristizabal"

save INFORMALES


*& OCI == "1"



