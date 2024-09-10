# Estadisticas Descriptivas

# Preliminares ------------------------------------------------------------

library(readxl) # Cargar base de datos de Excel
library(dplyr) # Limpieza de datos y operador pipe (%>%) (ctrl + shift + m)
library(readr) # Para la funcion parse_number

supercias <- read_excel("data/directorio_companias.xlsx", 
                        skip = 4) %>% # Saltarse las primeras 4 filas
             janitor::clean_names() # Clean names viene de la libreria janitor

# Limpieza preliminar -----------------------------------------------------

supercias$capital_suscrito %>% class() # cargado como un caracter inicialmente, hay que cambiar.

# class consulta a R que tipo de dato es el argumento

supercias_limpio <-
  supercias %>%
  mutate(capital_suscrito = parse_number(capital_suscrito, locale = locale(decimal_mark = ",", grouping_mark = "."))) # Convierte a numero con formato del Sistema Internacional

supercias_limpio$capital_suscrito %>% class()

# Estadistica Descriptiva -------------------------------------------------

# mean(supercias$capital_suscrito)

mean(supercias_limpio$capital_suscrito) # funcion no calcula promedio, aunque sea numerico el argumento. existen NAs en la base (capital suscrito)

mean(supercias_limpio$capital_suscrito, na.rm = TRUE) # utilizando el argumento na.rm = TRUE: quita todos los valores faltantes (NA) del calculo del promedio

supercias_limpio_filtrada <-
  supercias_limpio %>% 
  filter(!is.na(capital_suscrito)) # filtrar en base a is.na(capital suscrito), y negacion (!) es igual a filtrar para los valores que NO son NA.

mean(supercias_limpio_filtrada$capital_suscrito) # no necesito incluir el argumento na.rm = T

# el uso de una de estas alternativas depende del contexto investigativo: quiero conservar filas con NAs?

# Utilizando summarise: 

supercias_limpio %>% 
  summarise(promedio_capital_suscrito = mean(supercias_limpio$capital_suscrito, na.rm = TRUE),
            mediana_capital_suscrito = median(supercias_limpio$capital_suscrito, na.rm = TRUE))

median(supercias_limpio$capital_suscrito, na.rm = TRUE)

mediana <- median(supercias_limpio$capital_suscrito, na.rm = TRUE)

media <- mean(supercias_limpio$capital_suscrito, na.rm = TRUE)

dataframe_de_descriptivos <- 
  supercias_limpio %>% 
  summarise(promedio_capital_suscrito = mean(supercias_limpio$capital_suscrito, na.rm = TRUE),
            mediana_capital_suscrito = median(supercias_limpio$capital_suscrito, na.rm = TRUE),
            desviacion_estandar_capital_suscrito = sd(supercias_limpio$capital_suscrito, na.rm = TRUE))

# Para calcular la moda, se utiliza la función table de R base

tabla_frecuencias_capital_suscrito <- table(supercias_limpio$capital_suscrito)

# Summary me da estadisticas descriptivas rapidas

summary(supercias_limpio$capital_suscrito)

# Para hallar percentiles, se utiliza la funcion quantile

quantile(supercias_limpio$capital_suscrito, 
         probs = c(0.25, 0.50, 0.95), 
         na.rm = TRUE) # quantile puede recibir vectors en su argumento probs para arrojar varios percentiles a la vez. crear un vector con c()

# Visualizacion con R base ------------------------------------------------

## Histograma

hist(supercias_limpio$capital_suscrito)

# 2E+8 (Notacion cientifica, 2 x 10^8) - 200 millones de dolares para capital suscrito

hist(supercias_limpio$capital_suscrito, 
     breaks = 5, 
     main = "Histograma de Capital Suscrito", 
     xlab = "Capital Suscrito", 
     ylab = "Frecuencia")

# Por valores atipicos, el grafico no se ve bien (hay pocas empresas con mas de 200 millones de capital)

# Aplicar una escala logaritmica para reducir la variacion

hist(log(supercias_limpio$capital_suscrito), # logaritmo natural. 
     breaks = 5, 
     main = "Histograma de Capital Suscrito", 
     xlab = "Capital Suscrito (base logaritmica natural)", 
     ylab = "Frecuencia")

# Reducir el numero de valores atipicos aplicando un filtro de valores dentro del rango intercuartil
# rango intercuartil es una medida de variabilidad (Q3-Q1)

supercias_sin_atipicos_iqr <-
  supercias_limpio %>%
  filter(capital_suscrito >= quantile(supercias_limpio$capital_suscrito, probs = 0.25, na.rm = T),
         capital_suscrito <= quantile(supercias_limpio$capital_suscrito, probs = 0.75, na.rm = T))

hist(supercias_sin_atipicos_iqr$capital_suscrito,
     breaks = 5)