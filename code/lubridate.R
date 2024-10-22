# Manejo de fechas con R Base y Lubridate

# Preliminares ------------------------------------------------------------

# Cargar librerías

library(lubridate)
library(readr)
library(readxl)
library(dplyr)
library(ggplot2)

# Cargar base de SUPERCIAS

supercias_raw <-
  read_excel("data/directorio_companias_supercias.xlsx", skip = 4) %>% 
  janitor::clean_names() %>% 
  mutate(capital_suscrito = parse_number(capital_suscrito, locale = locale(grouping_mark = ".", decimal_mark = ",")))

# Manejo de fechas --------------------------------------------------------

# crear una fecha como caracter y pasar a la funcion as.Date()

fecha_de_ayer <- "2024-10-20" %>% as.Date()

fecha_de_hoy <- Sys.Date()

fecha_de_hoy - fecha_de_ayer # 1 dia de diferencia

fecha_de_ayer - fecha_de_hoy # -1 dia de diferencia

fecha_de_hoy + 5

# Lubridate ---------------------------------------------------------------

# Solucionar el problema de fechas en SUPERCIAS

# error en la conversion: R no reconoce el formato y se equivoca en la transformacion.

supercias_raw[1,] %>% 
  pull(fecha_constitucion) %>% 
  as.Date()

# usar lubridate para cargar la base con fechas

supercias_raw[1,] %>% 
  pull(fecha_constitucion) %>% 
  dmy() # day, month, year: dmy

# si yo ponia ymd(), no hubiera funcionado y tambien habria una equivocacion.

# convertir toda la columna

supercias <-
  supercias_raw %>% 
  mutate(fecha_limpio = dmy(fecha_constitucion),
         month = month(fecha_limpio),
         year = year(fecha_limpio), # year y month son extractores de elementos para las fechas.
         mes_anio = floor_date(fecha_limpio, unit = "month")) # floor date es un redondeo de fechas

# extraer partes de la fecha. usar year(), day(), month()

# agrupar por mes y fecha, contar numero de empresas constituidas

agrupación_tiempo <-
  supercias %>% 
  count(mes_anio)

# Graficar ----------------------------------------------------------------

# con ggplot2, trabajar con fechas de SUPERCIAS
# grafico de serie de tiempo (grafico de lineas y puntos del numero de empresas incorporadas)

supercias %>% 
  filter(year %>% between(2015, 2023)) %>%
  count(mes_anio) %>% 
  ggplot(aes(x = mes_anio, y = n)) + 
    geom_point() +
    geom_line() +
    scale_x_date(date_labels = "%Y-%b", date_breaks = "6 months") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))


