# Script de importacion de bases de datos

# Preliminares ------------------------------------------------------------

# Instalar paquete haven para cargar base de datos de Stata de encuesta LAPOP
# Instalar en la consola (no se instala nunca en script)
# Guardar script con Ctrl + S para no perder mi trabajo.
# Si yo ya tengo instalado haven, no es necesario reinstalar, solamente utilizar library(), eso si va siempre en el script.
# Utilizar el visor de paquetes a la derecha para verificar si el paquete esta instalado.

# Cargar el paquete:

library(haven) # Carga bases de datos de otros programas

# Stata tiene extensiones de archivo .dta
# Visor de archivos de RStudio permite visualizar extensiones de archivo.

lapop_2019 <- read_dta("data/Ecuador LAPOP AmericasBarometer 2019 v1.0_W.dta")

# La libreria "here" es una libreria dinamica que define el directorio de trabajo adecuadamente.
# Se utiliza here cuando NO tengo un proyecto de R. En este caso yo no debo utilizar here. 

# Exploracion de la base --------------------------------------------------

str(lapop_2019) # Codigo que me devuelve la "estructura"

# La clase del objeto: vector, matriz, dataframe
# El tipo de datos que tienen los objetos internos. 
# Si es que es una dataframe, devuelve las columnas y los tipos de datos de cada una con algunos valores. 

# Ej: columna idnum va de 1 a 1533 (tiene 1533 observaciones). 
# es una columna numerica.
# Tiene atributos: informacion adicional que la base de datos contiene.
# base de datos es un "tibble", una dataframe especial en formato tidyverse.
# lapop 2019 es un tibble.

View(head(lapop_2019, n = 5))
