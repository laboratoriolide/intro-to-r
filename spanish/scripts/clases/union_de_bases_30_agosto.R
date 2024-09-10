# Union de bases 

# Preliminares ------------------------------------------------------------

# Carga de librerias

library(dplyr)
library(readr)
library(janitor)
library(tidyr)

# Carga de datos

sri_ventas_2024 <- read_delim("data/sri_ventas_2024.csv", delim = "|", 
                              escape_double = FALSE, 
                              locale = locale(decimal_mark = ",",encoding = "WINDOWS-1252"), 
                              trim_ws = TRUE) %>%
                  clean_names()

sri_ventas_2023 <- read_delim("data/sri_ventas_2023.csv", delim = "|", 
                              escape_double = FALSE, 
                              locale = locale(decimal_mark = ",",encoding = "WINDOWS-1252"), 
                              trim_ws = TRUE) %>%
  clean_names()

# Union (bind_rows) -------------------------------------------------------

# Utilizar bind_rows para juntar sri_ventas 2023 y 2024 (mismas bdd para diferentes años)

sri_ventas_consolidado <-
  bind_rows(sri_ventas_2023, sri_ventas_2024)

# Utilizar la funcion unique() para rapidamente ver los valores unicos en una columna

sri_ventas_consolidado$ano %>% unique()

# Analisis ----------------------------------------------------------------

# Agrupar en base a mes y fecha/provincia para calcular ventas de establecimientos. 
# Solo para 2024

ventas_por_mes_y_provincia <-
  sri_ventas_consolidado %>% 
  filter(ano == 2024) %>% 
  group_by(provincia, mes) %>% 
  summarise(total_ventas_agregado = sum(total_ventas)) %>%
  mutate(mes_nombre = case_when(mes == 1 ~ "Enero",
                                mes == 2 ~ "Febrero",
                                mes == 3 ~ "Marzo",
                                mes == 4 ~ "Abril",
                                mes == 5 ~ "Mayo"))

# Utilizar la funcion case_when para considerar diferentes "casos".
# Quiero escribir nombres de meses en español. 
# Caso 1: Enero
# Caso 2: Febrero
# ...

# Case when funcion con operadores logicos
# No igual a (!=)
# Menor a (<) y mayor a (>)
# >=, <=
# between()
# condiciones complejas con & (AND) o y. 

# Reconfiguraciones a lo ancho (Pivots/Reshapes) -------------------------------------

# Quiero poner las ventas de cada mes en diferentes columnas de la tabla arriba. 
# Utilizar las funciones de reconfiguracion gather/spread
# El paquete "estrella" de reconfiguraciones es el paquete tidyr. 

# Spread va de largo a ancho (crear nuevas columnas a partir de una columna larga)

ventas_formato_ancho <-
  ventas_por_mes_y_provincia %>%
  select(-mes) %>% 
  spread(key = "mes_nombre", value = "total_ventas_agregado")

# Eliminar columnas redudantes para una reconfiguracion exitosa

# Pivot wider 

ventas_formato_ancho <-
  ventas_por_mes_y_provincia %>% 
  select(-mes) %>%
  pivot_wider(names_from = mes_nombre, values_from = total_ventas_agregado, names_prefix = "ventas_")

# Reconfigurar a lo largo -------------------------------------------------

# Deshacer lo hecho anteriormente con pivot_longer()

ventas_formato_largo <-
  ventas_formato_ancho %>% 
  pivot_longer(ventas_Enero:ventas_Mayo, names_to = "mes_nombre", values_to = "ventas", names_prefix = "ventas_")

# Exportar a csv ----------------------------------------------------------

write_csv(ventas_formato_ancho, "data/ventas_formato_ancho.csv")

ventas_formato_ancho %>% 
  select(provincia, ventas_Enero) %>% 
  write_csv("data/ventas_Enero.csv")




