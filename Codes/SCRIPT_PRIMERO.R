###############################################################################
#######                                                                 #######
#            SECRETARÍA DE HACIENDA | TRABAJO ANDRÉS ARISTIZABAL              #
#                                                                             #
# BY:: NICOLAS GARCIA PEÑALOZA                                                #
#nicolasgp0109@gmail.com
#+ 57 312 285 3832

#
# https://datacarpentry.org/R-ecology-lesson/05-r-and-databases.html

#
getwd()

# NO USAR e+
options('scipen'=100, 'digits'=4) # Forzar a R a no usar e+


### LIMPIO LA CONSOLA
cat('/f')

rm(list=ls())

list=ls()




###
paquetes = c('tidyverse',
             'readxl',
             'timetk',
             'haven',
             "data.table",
             'lubridate',
             "multicolor",
             'janitor',
             'car',
             'reshape2',
             'fs' , 
             'hrbrthemes' , 
             'AMR' ,  
             'tidygeocoder' , 
             'sf' ,
             'rgdal')




for(N in paquetes ){
  if (length(grep(N,installed.packages()[,1])) == 0 ){ install.packages(N) ; print(paste0("Nicolas La libreria ", "'", N ,"'", " ha sido instalada."))}
  else { print(paste0("Nicolas La libreria ", "'", N ,"'", " ya esta instalada."))}
  rm(N)}


sapply(paquetes,require,character.only=T) ; rm(paquetes)## BORRO EL OBJETO CON LOS NOMBRES DE LOS PAQUETES

setwd("C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal")

GEIH_2022 = read.csv("C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Armenia/Alcaldía de Armenia/Observatorio Economico/DASHBOARD/SALUD/GEIH_2022, clases/GEIH_2022.csv") |>
 mutate( YEAR = as.character(substr( PERIODO , start = 1, stop = 4 )) )  


GEIH_2023_MAY = read.csv("C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal/GEIH_2023_mayo.csv") |>
  mutate( YEAR = as.character(substr( PERIODO , start = 1, stop = 4 )) ) 
  

GEIH = plyr::rbind.fill( GEIH_2022 , GEIH_2023_MAY ) ; rm(GEIH_2022 , GEIH_2023_MAY )

GEIH = GEIH |> mutate( RAMA2D_D_R4 = as.numeric(RAMA2D_D_R4)) 


GEIH$RAMA2D_D_R4 |> str()

## DOS DIGITOS
GEIH$RAMA2D_D_R4 |> table()
GEIH$RAMA2D_D_R4 |> str()

GEIH$RAMA2D_R4 |> table()


#### CUATRO DIGITOS
GEIH$RAMA4D_D_R4 |> table()

GEIH$RAMA4D_R4 |> table()




GEIH = GEIH |> mutate(CIIU = case_when(
  RAMA2D_R4 == 0 ~ "No informa" ,
  RAMA2D_R4 %in% seq( from = 1, to = 3 , by = 1 ) ~ "Agricultura, ganadería, caza, silvicultura y pesca" , 
  RAMA2D_R4 %in% seq( from = 5, to = 9 , by = 1 ) ~ "Explotación de minas y canteras" ,
  RAMA2D_R4 %in% seq( from = 10 , to = 33 , by = 1 ) ~ "Industrias manufactureras" ,
  RAMA2D_R4 %in% seq( from = 35 , to = 39 , by = 1 ) ~ "Suministro de electricidad gas, agua y gestión de desechos" ,
  RAMA2D_R4 %in% seq( from = 41 , to = 43 , by = 1 ) ~ "Construcción" ,
  RAMA2D_R4 %in% seq( from = 45 , to = 47 , by = 1 ) ~ "Comercio y reparación de vehículos" ,
  RAMA2D_R4 %in% seq( from = 49 , to = 53 , by = 1 ) ~ "Transporte y almacenamiento" ,
  RAMA2D_R4 %in% c(  51 , 54 , 55 , 56  ) ~ "Alojamiento y servicios de comida" ,
  RAMA2D_R4 %in% seq( from = 58 , to = 63 , by = 1 ) ~ "Información y comunicaciones" ,
  RAMA2D_R4 %in% seq( from = 64 , to = 66 , by = 1 ) ~ "Actividades financieras y de seguros" ,
  RAMA2D_R4 == 68 ~ "Actividades inmobiliarias" ,
  RAMA2D_R4 %in% seq( from = 69 , to = 82 , by = 1 ) ~ "Actividades profesionales, científicas, técnicas y servicios administrativos" ,
  RAMA2D_R4 %in% seq( from = 84 , to = 88, by = 1 ) ~ "Administración pública y defensa, educación y atención de la salud humana" ,
  RAMA2D_R4 %in% seq( from = 90 , to = 99  , by = 1 ) ~ "Actividades artísticas, entretenimiento recreación y otras actividades de servicios" ,
  TRUE ~ "NN"
)
) |>   mutate(Divisiones_CIIU = case_when(
   RAMA2D_R4 == 0 ~ "No informa" ,
   RAMA2D_R4 %in% seq( from = 1 , to = 3  , by = 1 ) ~ "Agricultura, ganadería, caza, silvicultura y pesca" , 
   RAMA2D_R4 %in% seq( from = 5 , to = 9  , by = 1 ) ~ "Explotación de minas y canteras" ,
   RAMA2D_R4 %in% seq( from = 10 , to = 33 , by = 1 ) ~ "Industrias manufactureras" ,
   RAMA2D_R4 == 35 ~ "Suministro de electricidad, gas, vapor, y aire acondicionado" ,
   RAMA2D_R4 %in% seq( from = 36 , to = 39 , by = 1 ) ~ "Distribución de agua; evacuación y tratamiento de aguas residuales, gestión de desechos y actividades de saneamiento ambiental" ,
   RAMA2D_R4 %in% seq( from = 41 , to = 43  , by = 1 ) ~ "Construcción" ,
   RAMA2D_R4 %in% seq( from = 45 , to = 47  , by = 1 ) ~ "Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas" ,
   RAMA2D_R4 %in% seq( from = 49 , to = 53  , by = 1 ) ~ "Transporte y almacenamiento" ,
   RAMA2D_R4 %in%  c(  51 , 54 , 55 , 56  ) ~ "Alojamiento y servicios de comida" ,
   RAMA2D_R4 %in% seq( from = 58 , to = 63  , by = 1 ) ~ "Información y comunicaciones" ,
   RAMA2D_R4 %in% seq( from = 64 , to = 66  , by = 1 ) ~ "Actividades financieras y de seguros" ,
   RAMA2D_R4 == 68 ~ "Actividades inmobiliarias" ,
   RAMA2D_R4 %in% seq( from = 69 , to = 75  , by = 1 ) ~ "Actividades profesionales, científicas y técnicas" ,
   RAMA2D_R4 %in% seq( from = 77 , to = 82  , by = 1 ) ~ "Actividades de servicios administrativos y de poyo" ,
   RAMA2D_R4  == 84 ~ "Administración pública y defensa; planes de seguridad social de afiliación obligatoria" ,
   RAMA2D_R4  == 85 ~ "Educación" ,
   RAMA2D_R4 %in% seq( from = 86 , to = 88  , by = 1 ) ~ "Actividades de atención de la salud humana y de asistencia social" ,
   RAMA2D_R4 %in% seq( from = 90 , to = 93  , by = 1 ) ~ "Actividades artísticas, de entretenimiento y recreación" ,
   RAMA2D_R4 %in% seq( from = 94 , to = 96  , by = 1 ) ~ "Otras actividades de servicios" ,
   RAMA2D_R4 %in% seq( from = 97 , to = 98  , by = 1 ) ~ "Actividades de los hogares en calidad de empleadores; actividades no diferenciadas de los hogares individuales como productores de bienes y servicios para uso propio" ,
   RAMA2D_R4  == 99 ~ "Actividades de organizaciones y entidades extraterritoriales" ,
    TRUE ~ "NN"
  )
  )
  

GEIH$CIIU |> table()

GEIH$Divisiones_CIIU |> table()

GEIH$PER |> str()


GEIH$P6430 |> str()

GEIH$P6430 |> table()


?str()

GEIH$P3044S2 |> str()


### GENERO VARIABLE INFORMALES
GEIH = GEIH |> mutate(PER = as.numeric(PER) )  |> 
  mutate( ANIOS = PER - 1 , 
          OFICIO_C8_2D =
            as.numeric(substr( OFICIO_C8 , start = 1 , stop = 2 )), 
          FORMAL = case_when(
            P6430 == 3 ~ NA)) |> 
  mutate( FORMAL = 
            case_when(
              P6430 == 6 | P6430 == 8 ~ 0 ,
              RAMA2D_R4 == 84 | RAMA2D_R4 == 99 ~ 1 ,
              
              ## ASALARIADOS
              P6430 == 2 ~ 1 , 
              (P6430 == 1 | P6430 ==7 ) & P3045S1 == 1 ~ 1,
              (P6430 == 1 |  P6430 ==7) & ((P3045S1 == 2  | P3045S1 == 9 ) & P3046 == 1) ~ 1,
              (P6430 ==1  | P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 2) ~ 0 , 
              (P6430 ==1 |  P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 9) & (P3069>= 4) ~ 1,
             (P6430 ==1  | P6430 ==7) & ((P3045S1==2 | P3045S1==9 ) & P3046 == 9) & (P3069 <= 3) ~ 0,
              
          ## INDEPENDIENTES SIN NEGOCIO
          (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & P3065==1 ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 | P3065==9) & P3066==1 ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 |  P3065==9) & P3066==2 ~ 0 ,
          (P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2 | P3065==9) & P3066==9 & P3069 >= 4 ~ 1 ,
          (P6430 ==5) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & P3069 <= 3 ~ 0 ,
          (P6430 ==4) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20) ~ 1 ,
          (P6430 ==4) & (P6765 ==1 |P6765 ==2 |P6765 ==3 |P6765 ==4 |P6765 ==5 |P6765 ==6 |P6765 ==8) & (P3065==2  | P3065==9) & P3066==9 & (OFICIO_C8_2D >=21) ~ 0 ,
          
          ## CON NEGOCIO CON REGISTRO MERCANTIL
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==1 & P3067S2 >= ANIOS ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==1 & P3067S2 < ANIOS ~ 0 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==1 ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==3 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20) ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==3 & (OFICIO_C8_2D >=21) ~ 0 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==2 ~ 0 , 
          (P6430 ==4 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20) ~ 1 ,
          (P6430 ==4 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & (OFICIO_C8_2D >=21) ~ 0 ,
          (P6430 ==5 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & P3069 >= 4  ~ 1 ,
          (P6430 ==5 ) & (P6765 == 7) & P3067==1 & P3067S1==2 & P6775==9 & P3069 <= 3 ~ 0 ,
          
          
          ##SIN REGISTRO MERCANTIL
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==1 & P3068==1 ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==1 & P3068==2 ~ 0 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==3 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20) ~ 1 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775 ==3 & (OFICIO_C8_2D >=21) ~ 0 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==1 & (P3068==9 |P3068==3) ~ 0 ,
          (P6430 ==4 | P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==2 ~ 0 ,
          (P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==9 & P3069 >= 4 ~ 1 ,
          (P6430 ==5) & (P6765 == 7) & P3067==2 & P6775==9 & P3069 <= 3 ~ 0 ,
          (P6430 ==4) & (P6765 == 7) & P3067==2 & P6775==9 & (OFICIO_C8_2D >=00 &  OFICIO_C8_2D <=20) ~ 1 ,
          (P6430 ==4) & (P6765 == 7) & P3067==2 & P6775==9 & (OFICIO_C8_2D >=21) ~ 0 ,
           TRUE ~ as.numeric(FORMAL)),
          SALUD = 0) |> 
  mutate( SALUD = 
      case_when(
        (P6430 ==1 | P6430 ==3 | P6430 ==7 ) & (P6100 ==1 |P6100 ==2) & (P6110 ==1 | P6110 ==2 | P6110 ==4) ~ 1 ,
        (P6430 ==1 | P6430 ==3 | P6430 ==7 ) & (P6100==9) & (P6450==2) ~ 1 ,
        (P6430 ==1 | P6430 ==3 | P6430 ==7 ) & (P6110==9) & (P6450==2) ~ 1,
        TRUE ~ as.numeric(FORMAL)),
      PENSION = 0 ) |> 
  mutate(
    PENSION = 
      case_when(
        (P6430 ==1 | P6430 ==3 | P6430 ==7 ) & P6920==3 ~ 1,
        (P6430 ==1 | P6430 ==3 | P6430 ==7 ) & P6920==1 & (P6930 ==1 |P6930 ==2 |P6930 ==3) & (P6940 ==1 | P6940 ==3) ~ 1 ,
        TRUE ~ as.numeric(FORMAL)),
     EI = 0) |> 
  mutate(
    EI =
      case_when(
        P6430 == 2 ~ 1 ,
        (P6430 ==4 | P6430 ==5) ~ FORMAL,
        (P6430 ==1 | P6430 ==2 | P6430 ==3 | P6430 ==7 ) & SALUD==1 & PENSION==1 ~ 1 ,
        P6430==4 & (RAMA2D_R4== 84  | RAMA2D_R4 == 99 ) ~ 1 ,
        TRUE ~ as.numeric(EI)
        ))


y |> str()


GEIH = merge( x = GEIH ,  y = haven::read_dta( file = "C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal/INFORMALES.dta" ) , 
       by = c("DIRECTORIO" , "SECUENCIA_P" , "ORDEN" , "MES" , "DPTO" , "YEAR") , 
       all.x = T ,
       suffixes = c("", ".2"))


GEIH$INFORMAL

GEIH$P6920 |> str()

GEIH$P6430 |> str()

GEIH$RAMA2D_R4 |>str()

GEIH$RAMA2D_R4 |> table( useNA = "always" )

GEIH$FORMAL |> table( useNA = "always" )



GEIH$OCI |> str()




GEIH_AR = GEIH |> dplyr::filter( AREA == "63" & OCI == 1) 

xtabs( FEX_C18 ~  MES + YEAR + INFORMAL , data= GEIH_AR )

xtabs( FEX_C18 ~ YEAR + MES + OCI , data= GEIH_AR )

setwd("C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal")

write.csv(x = GEIH , file = "GEIH_2023_mayo.csv" , row.names = F)




