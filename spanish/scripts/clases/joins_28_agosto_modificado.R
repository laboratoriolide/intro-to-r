# Joins

# Preliminares ------------------------------------------------------------

# Cargar librerias

library(readxl) # Cargar archivos de Excel
library(janitor) # para la funcion clean_names (hace validos a los nombres)
library(dplyr) # limpieza de datos y pipe operator.
library(lubridate) # limpia fechas
library(openxlsx) # para exportar archivos de excel.

# Cargar datos de SUPERCIAS

supercias <- read_excel("data/directorio_companias.xlsx",
                        skip = 4) %>%
             clean_names() # tabla izquierda preliminar

# Fecha de actualizacion de la BDD de SUPERCIAS: 27/08/2024 00:31:59
# path es la ruta del archivo, relativo a donde esta el proyecto en la computadora
# no es necesario escribir C:\\users\usuario\documentos... solamente data/directorio_compañias.xlsx

# R considera como invalidos nombres de columnas que empiezan con numeros y/o que tienen espacios
# Se puede "escapar" nombres invalidos con los apostrofes. ``

# Cargar clasificacion de provincias

provincias <- read_excel("data/CODIFICACIÓN_2024.xlsx",
                         sheet = "PROVINCIAS") # tabla derecha

# Analisis ----------------------------------------------------------------

supercias %>% glimpse() # Explorar la base

# Fecha está en tipo de dato caracter (texto), no fecha
# Para que R considere una fecha automaticamente, debe estar en formato YYYY-MM-DD (formato ISO)

# Agrupacion a nivel provincias del Ecuador, numero de empresas en 2024

supercias_limpio <- 
  supercias %>% 
  mutate(fecha_constitucion_limpia = dmy(fecha_constitucion)) # dmy es DD-MM-YYYY (formato latinoamericano)

supercias_limpio %>% glimpse()

# Para la agrupacion, filtrar para empresas constituidas solamente en 2024.

supercias_2024 <-
  supercias_limpio %>% 
  filter(fecha_constitucion_limpia >= as.Date("2024-01-01")) # as.Date necesita formato ISO

# Agrupo

supercias_agrupado <-
  supercias_2024 %>% 
  group_by(provincia) %>% 
  summarise(numero_empresas = n()) # numero de empresas = cuenta de filas para cada provincia.

# Join --------------------------------------------------------------------

supercias_inner_join <-
  inner_join(supercias_agrupado, provincias, by = c("provincia" = "DPA_DESPRO"))

supercias_left_join <-
  left_join(supercias_agrupado, provincias, by = c("provincia" = "DPA_DESPRO"))

supercias_right_join <-
  right_join(supercias_agrupado, provincias, by = c("provincia" = "DPA_DESPRO"))

supercias_full_join <-
  full_join(supercias_agrupado, provincias, by = c("provincia" = "DPA_DESPRO"))

# Arreglo manual ----------------------------------------------------------

provinces_no_tilde <- c(
  'AZUAY',                         
  'BOLIVAR',                       
  'CAÑAR',                         
  'CARCHI',                      
  'COTOPAXI',                      
  'CHIMBORAZO',                    
  'EL ORO',                        
  'ESMERALDAS',                    
  'GUAYAS',                   
  'IMBABURA',                     
  'LOJA',                          
  'LOS RIOS',                      
  'MANABI',                        
  'MORONA SANTIAGO',               
  'NAPO',              
  'PASTAZA',                       
  'PICHINCHA',                    
  'TUNGURAHUA',                   
  'ZAMORA CHINCHIPE',              
  'GALAPAGOS',                     
  'SUCUMBIOS',                    
  'ORELLANA',                      
  'SANTO DOMINGO DE LOS TSACHILAS',
  'SANTA ELENA',
  "NO DELIMITADO"
)

provinces_some_tildes <- c(
  'AZUAY',                         
  'BOLIVAR',                       
  'CAÑAR',                         
  'CARCHI',                      
  'COTOPAXI',                      
  'CHIMBORAZO',                    
  'EL ORO',                        
  'ESMERALDAS',                    
  'GUAYAS',                   
  'IMBABURA',                     
  'LOJA',                          
  'LOS RIOS',                      
  'MANABI',                        
  'MORONA SANTIAGO',               
  'NAPO',              
  'PASTAZA',                       
  'PICHINCHA',                    
  'TUNGURAHUA',                   
  'ZAMORA CHINCHIPE',              
  'GALÁPAGOS',                     
  'SUCUMBIOS',                    
  'ORELLANA',                      
  'SANTO DOMINGO DE LOS TSÁCHILAS',
  'SANTA ELENA',
  "NO DELIMITADO"
)

provincias_catalogo <-
  provincias %>%
  mutate(provincia_sin_tilde = provinces_no_tilde,
         provincia_algunas_tildes = provinces_some_tildes)

# Exportar datos ----------------------------------------------------------

write.xlsx(provincias_catalogo, "data/Catalogo de Provincias.xlsx")

write.xlsx(supercias_agrupado, "data/SUPERCIAS empresas.xlsx")
  
