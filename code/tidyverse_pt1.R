# Tidyverse, pt.1

# Preliminares ------------------------------------------------------------

# Cargar librerias

library(tidyverse) # En tidyverse ya viene cargado readr (paquete de importacion de datos.)

# Cargar datos ------------------------------------------------------------

# La funcion relevante es read_csv (diferent a read.csv)

used_cars_ecuador <- read_csv("data/used_cars_ecuador.csv")

used_cars_ecuador_base <- read.csv("data/used_cars_ecuador.csv")

# read.csv() carga datos como data.frames (base) y read_csv carga datos como tibbles (dataframes mejoradas)

glimpse(used_cars_ecuador)

# glimpse se carga con tidyverse porque viene en el paquete dplyr

used_cars_ecuador$`Último número de la placa` # con nombres invalidos debo utilizar apostrofes para que funcione

used_cars_clean <-
  janitor::clean_names(used_cars_ecuador) # llamar a clean_names mediante :: es lo que comunmente se hace puesto que solo utilizamos clean_names y nada mas

used_cars_clean$ultimo_numero_de_la_placa

# Tibbles -----------------------------------------------------------------

class(mtcars) # mtcars es un dataframe no un tibble

mtcars_a_tibble <- as_tibble(mtcars)

# mtcars guarda el nombre del carro como "rownames" o como indice de cada fila
# si es que se transforma a tibble, esa informacion

mtcars_a_tibble$carro <- rownames(mtcars)

# Dplyr (limpieza de datos) -----------------------------------------------

carros <-
  select(used_cars_clean, ano, kilometraje, precio)

carros_r_base <- used_cars_clean[,c("ano", "kilometraje", "precio")]

carros <-
  rename(carros, "anio" = ano)

# sintaxis "tidyselect" permite escoger o seleccionar variables eficientemente

carros_solo_variables_con_c <-
  select(used_cars_clean, starts_with("c"))

# filtrar de carros solo los carros del anio 2020

carros_2020 <-
  filter(carros, carros$anio == "2020")

# ventaja de dplyr es que como ya declare el nombre de la base de datos, no necesito utilizar el 
# funciona asi en todos los paquetes tidyverse

carros_2020 <-
  filter(carros, anio == 2020)

# Pipe operator -----------------------------------------------------------

# Sin un pipe:

carros_filtrados <-
    filter(carros, precio < 15000)

carros_con_nombre_cambiado <-
  rename(carros_filtrados, "price" = precio)

# lo de arriba es menos "leible" que lo de abajo:

# Ctrl Shift M para hacer el pipe (%>%)

carros_con_nombre_cambiado_pipe <-
  carros %>% 
  filter(precio < 15000) %>% 
  rename("price" = precio) %>% 
  relocate(kilometraje)

# los pipes se pueden continuar "infinitamente"

# Mutar dataframes (crear nuevas columnas) --------------------------------

carros_columnas_extra <-
  carros %>% 
  mutate(precio_miles = precio/1000,
         pais = "Ecuador") %>% 
  relocate(pais) %>% 
  relocate(precio_miles, .before = precio)

# utilizando transmute (renombra, selecciona y muta al mismo tiempo)

carros_columnas_transmute <-
  used_cars_clean %>% 
  transmute(anio = ano,
            precio,
            negotiation = negociacion,
            precio_miles = precio/1000 %>% round(2)) %>% 
  arrange(desc(precio))

# arrange predeterminado: menor a mayor
# desc para cambiar el orden de mayor a menor
# ordenamientos de texto son alfabeticos (default), puedo cambiar a alfabetico invertido.

