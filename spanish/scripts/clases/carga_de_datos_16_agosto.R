# Carga de datos LAPOP

# Carga de datos del AmericasBarometer

# Preliminares ------------------------------------------------------------

library(haven)
ecuador_lapop <- read_dta("data/Ecuador LAPOP AmericasBarometer 2019 v1.0_W.dta")
# View(Ecuador_LAPOP_AmericasBarometer_2019_v1_0_W) No se recomienda el comando View en el script, solo poner con botones o escribir en consola

# Borrar objetos de el ambiente de R (para ahorrar memoria RAM)
# Dos maneras: cerrar el programa RStudio o utiliza funcion rm(list = ls())
# rm(list = ls()) no necesariamente incluir en el script, sino en consola

# Objeto cargado es un dataframe

# Analisis ----------------------------------------------------------------

head(ecuador_lapop) # primeras 6 filas de un dataframe

head(ecuador_lapop, n = 15)

tail(ecuador_lapop) # ultimas 6 filas

summary(ecuador_lapop) # funcion summary es para dar un resumen rapido

# De donde vienen las personas

ecuador_lapop$estratopri

summary(ecuador_lapop$estratopri)

ecuador_lapop$estratopri_factor <- factor(ecuador_lapop$estratopri)

summary(ecuador_lapop$estratopri_factor)
