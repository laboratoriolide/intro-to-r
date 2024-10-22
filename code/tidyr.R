# Tidyr

# Preliminares ------------------------------------------------------------

library(tidyverse) # tidyr incluido en el tidyverse

# Cargar datos

used_cars <- 
  read_csv("data/used_cars_ecuador.csv") %>% 
  janitor::clean_names()

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

