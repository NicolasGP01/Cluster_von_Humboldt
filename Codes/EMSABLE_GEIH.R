###############################################################################
#######                                                                 #######
#                    TRABAJO ANDRÉS | ENSAMBLAR LA GEIH                       #
#                                 2023                                        #
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


GEIH23 = "C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal/GEIH 2023/"

read_and_merge_data = function(month) {
  file_base = paste0(GEIH23, month, "/Características generales, seguridad social en salud y educación.dta")
  df = haven::read_dta(file_base)
  
  other_files = c("Ocupados", "No ocupados", "Fuerza de trabajo", "Otros ingresos e impuestos",
                  "Otras formas de trabajo", "Migración")
  
  for ( i in other_files) {
    file_path = paste0(GEIH23, month, "/", i , ".dta")
    other_df = haven::read_dta(file_path)
    df = merge( x = df, y = other_df, by = c("DIRECTORIO", "SECUENCIA_P", "ORDEN"), all.x = TRUE, suffixes = c("", paste0(".", i )))
  }
  
  return(df)
}

months = c("ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO")

data_list = lapply(months, read_and_merge_data)

GEIH = do.call(plyr::rbind.fill, data_list)

rm(data_list, GEIH22 , months , read_and_merge_data)

GEIH = GEIH |> dplyr::select(-ends_with(c( "Ocupados", "No ocupados", "Fuerza de trabajo", "Otros ingresos e impuestos",
                                           "Otras formas de trabajo", "Migración" ))) |> 
  mutate( MES = as.character(substr( PERIODO , start = 5, stop = 6)))


GEIH |> str()



setwd("C:/Users/nicol.NICOLAS_GP/OneDrive/Escritorio/Portafolio/My Work/Extra/Andrés Aristizabal")


write.csv(x = GEIH , file = "GEIH_2023_mayo.csv" , row.names = F)
