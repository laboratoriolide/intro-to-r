# Este es mi primer script (y se usa numeral para comentar)
# Young Researchers Fellowship 2024

# Preliminares ------------------------------------------------------------

# Se puede crear una seccion con Ctrl + Shift + R

library(babynames) # Cargar el paquete babynames
library(dplyr) # Cargar dplyr

dplyr::filter() # Operador de dos puntos llama a una funcion especifica con su paquete. 

stats::filter() # funcion diferente 

# Operador de dos puntos permite usar funciones sin necesidad de usar library()

janitor::clean_names() # comunmente clean_names se usa de esta manera, sin cargar janitor. 

# File paths deben definirse de forma relativa a la ubicacion del Rproj. 

# Funciones para cambiar directorios de trabajo son setwd() y getwd (similar a pwd en bash)

getwd()

# Crear una variable con el asignador (<-)

a <- 2

a

