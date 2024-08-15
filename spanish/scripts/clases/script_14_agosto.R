# Este es mi primer script
# Los comentarios se escriben con signo numeral # o hash.
# Seleccionar lineas y Ctrl + Enter ejecuta el codigo
# El boton "Source" envia todo el script a la consola.
a <- 2
a

# Puedo dejar lineas en blanco.
# Para instalar paquetes, uso el siguiente codigo:

install.packages("tidyverse",repos ='http://cran.us.r-project.org') # Instala tidyverse
install.packages("dplyr",repos ='http://cran.us.r-project.org') # Instala dplyr
install.packages("animation",repos = 'http://cran.us.r-project.org') # Instala animation

# No se debe instalar paquetes desde el script!!
# Se debe instalar solamente si es que no le instalado anteriormente, y desde la consola. (abajo del script)

# Para utilizar un paquete, se lo debe "llamar". Esto se hace con library()

library(tidyverse)

# Mensajes de advertencia:
# Warning messages:
#   1: package ‘tidyverse’ was built under R version 4.4.1 
# 2: package ‘dplyr’ was built under R version 4.4.1 

# Mensajes de advertencia si permiten ejecutar el codigo, pero indican el usuario de un posible problema en el futuro.

# library(animatio)

# Mensaje de error:

# Error in library(animatio) : there is no package called ‘animatio’

# Mensajes de error pausan la ejecucion del codigo.


# Establecer el directorio de trabajo en un script de R.

# Con getwd, R nos dice en que directorio de trabajo estamos. Equivalente a pwd en Git (shell)

getwd()

# Cambiar el directorio de trabajo a la carpeta UNEMI. Con setwd(), equivalente a cd.
# R tampoco permite usar el backslash (\) para directorios de trabajo. Cambiar a slash (/)

setwd("C:/Users/user/Desktop/UNEMI")

# Verificar el cambio de wd

getwd()

# Para un equivalente a ls, utilizar list.files()

list.files()







