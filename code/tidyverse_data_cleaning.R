# Temas de limpieza de datos con Tidyverse

# Preliminares ------------------------------------------------------------

# Cargar librerías

library(tidyverse)
library(readxl)

# Cargar datos de autos

used_cars <- 
  read_csv("data/used_cars_ecuador.csv") %>% 
  janitor::clean_names()

# cargar datos del SRI

sri_ventas_2023 <-
  read_delim("data/sri_ventas_2023.csv", 
             delim = "|", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
             trim_ws = TRUE) %>% 
  janitor::clean_names()

sri_ventas_2022 <-
  read_delim("data/sri_ventas_2022.csv", 
             delim = "|", escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), 
             trim_ws = TRUE) %>% 
  janitor::clean_names()

# cargar Excel del DPA (division politico administrativa del ecuador)

dpa_2024 <- read_excel("data/CODIFICACIÓN_2024.xlsx")

# Visualizar problemas en la carga de datos

problems(used_cars)

# nada que implique limpieza de datos en especifico para solucionar los problemas identificados.

used_cars %>% glimpse()

# Case When ---------------------------------------------------------------

# Case when sirve para condiciones logicas en la creacion de nuevas variables.
# Especialmente en el caso en el que tengo VaRIAS condiciones logicas que aplicar.

# crear una variable categorica en base al año: viejo, intermedio o nuevo.
# tres condiciones a definirse a partir del año del auto.
# 2020 o mas reciente como carro "nuevo"
# intermedio entre 2015 y 2019. 
# viejo todo lo mas antiguo que 2014 (inclusive)

# if_else sirve para evaluar condiciones logicas simples: solo dos categorias, por ejemplo

# case when puede superar a if_else en el caso de condiciones multiples.


used_cars_limpio <-
  used_cars %>%
  mutate(categoria_tiempo = case_when(
    ano >= 2020 ~ "Nuevo", # ~ se llama "tilde"
    ano >= 2015 & ano <= 2019 ~ "Intermedio",
    ano <= 2014 ~ "Antiguo",
    TRUE ~ NA # para que todo lo que no cumple estas condiciones (es decir, NAs en el año) sea NA también en categoria_tiempo
  ))

# me da lo mismo hacer lo siguiente:

used_cars_limpio <-
  used_cars %>%
  mutate(categoria_tiempo = case_when(
    ano >= 2020 ~ "Nuevo", # ~ se llama "tilde"
    ano %>% between(2015,2019) ~ "Intermedio",
    ano <= 2014 ~ "Antiguo",
    TRUE ~ NA # para que todo lo que no cumple estas condiciones (es decir, NAs en el año) sea NA también en categoria_tiempo
  ))

used_cars_limpio %>% 
  group_by(categoria_tiempo) %>% 
  summarise(n())

# operador between es inclusivo

# para condiciones "textuales" 
# viejo de quito
# viejo de guayaquil
# todo lo demas (lo que no se evalua como verdadero en las anteriores dos condiciones)

used_cars_limpio <-
  used_cars_limpio %>%
  filter(!is.na(ano), !is.na(lugar)) %>% # sacar NAs
  mutate(categoria_tiempo_provincia = case_when(
    ano <= 2014 & lugar == "Quito" ~ "Viejo de Quito",
    ano <= 2014 & lugar == "Guayaquil" ~ "Viejo de Guayaquil",
    TRUE ~ "Todo lo demás"
  ))

used_cars_limpio %>%  # count es equivalente al workflow de group_by anterior
  count(categoria_tiempo_provincia)

# Joins -------------------------------------------------------------------

# poner el codigo de provincia en la base de datos del SRI, para luego ayudarnos con otros joins de otras bases del gobierno.

# 1. crear un "catalogo" de provincias, con cada una en base a su nombre y su codigo correspondiente.

catalogo <-
  dpa_2024 %>% 
  distinct(DPA_PROVIN, DPA_DESPRO) %>% 
  rename(codigo = DPA_PROVIN,
         provincia = DPA_DESPRO)

# 2. hacer el join, inner join (primer tipo de join)

sri_con_codigo <-
  sri_ventas_2023 %>% 
  inner_join(catalogo, by = c("provincia" = "provincia")) # en casos donde la columna se llama igual, puedo usar by = "provincia"


# 3. left_join, me quedo con TODAS las columnas de la izquierda

sri_con_codigo_left <-
  sri_ventas_2023 %>% 
  left_join(catalogo, by = "provincia")

# se generan NAs en filas sin coincidencia

sri_con_codigo_left %>% 
  filter(codigo %>% is.na())

# 4. full_join: mantengo todas las filas en comun asi como las que NO tienen coincidencia.

sri_con_codigo_full <-
  sri_ventas_2023 %>% 
  full_join(catalogo, by = "provincia")

# arreglemos el catalogo para que me devuelva codigos para TODAS las provincias como se las escribio en SRI ventas 2023.

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

catalogo_corregido <-
  catalogo %>% cbind(provinces_no_tilde)

# cbind "junta" columnas forzando el orden, no utiliza identificadores (no es un "lookup" o busqueda de coincidencias)

# hacer un left join mediante el catalogo corregido
  
sri_con_codigo_corregido <-
  sri_ventas_2023 %>%
  mutate(provincia = if_else(provincia == "ND", "NO DELIMITADO", provincia)) %>% # corregir la provincia "ND" cambiandola a "NO DELIMITADO"
  left_join(catalogo_corregido, by = c("provincia" = "provinces_no_tilde")) # mantener el orden izquierda-derecha en el identificador. 

# ahora TODOS los records de sri_ventas tienen un codigo de provincia de acuerdo al DPA del INEC.

sri_con_codigo_corregido %>% 
  filter(is.na(codigo))

# Uniones (bind_rows) -----------------------------------------------------

sri_2022_2023 <-
  sri_ventas_2022 %>% 
  bind_rows(sri_ventas_2023)

# verificar

sri_2022_2023 %>% 
  count(ano)

# bind_rows reconoce nombres de columnas
# columna "desconocida" que solo esta en una de las tablas
# bind_rows igual importa la columna, pone NAs en la tabla que NO contiene dicha columna

sri_con_columna_especial <-
  sri_ventas_2022 %>% 
  mutate(base = "del 2022") %>% 
  bind_rows(sri_ventas_2023)