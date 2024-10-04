# Tidyverse, pt.2

# Preliminares ------------------------------------------------------------

# Cargar librerias

library(tidyverse)
library(wbstats)

# Importacion de datos ----------------------------------------------------

# Cargando desde GH:

carros_raw <-
  read_csv("https://raw.githubusercontent.com/laboratoriolide/intro-to-r/refs/heads/main/data/used_cars_ecuador.csv")

carros_csv_base <-
  read.csv("https://raw.githubusercontent.com/laboratoriolide/intro-to-r/refs/heads/main/data/used_cars_ecuador.csv")

# Banco mundial

# utilizar wb_data (no wb)

wb_datos <- wb_data(indicator = "NE.GDI.FTOT.ZS", country = "EC")

fdi <- wb_data(indicator = "BN.KLT.DINV.CD")

# descargando

# Download a file from the web

options(timeout = 300)

download.file("https://mercadodevalores.supercias.gob.ec/reportes/directorioCompanias.jsf",
              destfile = "data/downloads/supercias_downloaded.xlsx")

# Agrupaciones de datos ---------------------------------------------------

# cargar base de used cars ecuador

df <- read_csv("data/used_cars_ecuador.csv")

# agrupar la base por año y calcular numero de carros x año

numero_de_carros_por_año <-
  df |> 
  janitor::clean_names() |> 
  group_by(ano) |> 
  summarise(numero_de_carros = n())

barplot(numero_de_carros_por_año$numero_de_carros, width = numero_de_carros_por_año$ano)

# para contar el numero de filas agrupado por alguna variable, existe la funcion "count"
# es lo mismo que utilizar group_by y summarise de la manera que hicimos arriba.

df |> 
  janitor::clean_names() |> 
  count(ano)

# summarise sirve en general para calcular estadistica descriptiva.

df |> 
  summarise(promedio = mean(Precio, na.rm = T))

# extraer como vector una columna de la base, utilizo pull()

df |> 
  pull(Año)

numero_de_carros_por_año |> 
  pull(numero_de_carros)

df |> 
  summarise(promedio = mean(Precio, na.rm = T)) |> 
  pull(promedio)

# group_by con varias estadisticas descriptivas

stats_carros <-
df |> 
  group_by(Año) |> 
  summarise(n = n(),
            promedio_precio = mean(Precio, na.rm = T),
            sd = sd(Precio, na.rm = T))

stats_carros_anio_provincia <-
  df |> 
  group_by(Año, Lugar) |> 
  summarise(n(),
            promedio = mean(Precio, na.rm = T))

df |> 
  count(Año, Lugar)

# filtrado avanzado con operadores
# opcion para filtrar valores de categorias para mas de una categoria

# opcion 1: utilizar operador logico | (OR)

df |> 
  filter(Lugar == "Quito" | Lugar == "Sangolqui")

# opcion 2: "percent in percent" o %in% (en)

df |> 
  filter(Lugar %in% c("Quito", "Sangolqui"))