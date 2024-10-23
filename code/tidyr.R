# Tidyr

# Preliminares ------------------------------------------------------------

library(tidyverse) # tidyr incluido en el tidyverse
library(readxl)

# Cargar datos

used_cars <- 
  read_csv("data/used_cars_ecuador.csv") %>% 
  janitor::clean_names()

supercias_raw <-
  read_excel("data/directorio_companias_supercias.xlsx", skip = 4) %>% 
  janitor::clean_names() %>% 
  mutate(capital_suscrito = parse_number(capital_suscrito, locale = locale(grouping_mark = ".", decimal_mark = ",")))

# Cargar carros en formato wide

wide <- 
  used_cars %>% 
  filter(ano %>% between(2020,2024)) %>% 
  count(lugar, ano) %>%
  ungroup() %>% 
  pivot_wider(names_from = ano, values_from = n)

# Pivot longer ------------------------------------------------------------

# enviar datos de formato ancho (varias observaciones de una variable por columna y no hay repetidos) a 
# formato largo (varias observaciones de un elemento, hay repetidos, una sola columna x variable)

long <-
  wide %>% 
  pivot_longer(`2020`:`2024`, names_to = "year", values_to = "values") 

# columnas a pivotear, nueva columna que refleja los nombres de las columnas en la base ancha
# values_to pone nombre a la columna de valores numericos

# Pivot wider -------------------------------------------------------------

wide_2 <-
  long %>% 
  pivot_wider(names_from = year, values_from = values, names_prefix = "anio_")

# Uso de complete() de tidyr ----------------------------------------------

supercias <-
  supercias_raw %>% 
  mutate(fecha_limpio = dmy(fecha_constitucion),
         month = month(fecha_limpio),
         year = year(fecha_limpio), # year y month son extractores de elementos para las fechas.
         mes_anio = floor_date(fecha_limpio, unit = "month")) # floor date es un redondeo de fechas

agrupación_tiempo <-
  supercias %>%
  filter(year %>% between(2015,2023)) %>% 
  count(mes_anio)

# panel con mes y provincia

agrupación_tiempo_provincia <-
  supercias %>%
  filter(year %>% between(2015,2023)) %>% 
  count(provincia, mes_anio)

# complete crea todas las combinaciones relevantes entre dos o mas variables

panel_completo <-
  agrupación_tiempo_provincia %>% 
  complete(provincia, mes_anio) %>% 
  replace_na(list(n = 0))

panel_completo %>% 
  filter(provincia == "AZUAY") %>% 
  ggplot(aes(mes_anio, n)) +
  geom_line()

