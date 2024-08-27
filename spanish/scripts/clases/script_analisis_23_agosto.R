# Script de analisis de base de datos LAPOP

# Preliminares ------------------------------------------------------------

# Cargar el paquete:

library(haven) # Carga bases de datos de otros programas
library(tidyverse) # Libreria que contiene paquetes de analisis de datos
# Contiene dplyr

lapop_2019 <- read_dta("data/Ecuador LAPOP AmericasBarometer 2019 v1.0_W.dta")

# Analisis ----------------------------------------------------------------

names(lapop_2019) # Nombres

# Names me da nombres de todas las columnas (variables)

## Operador Pipe -----------------------------------------------------------

# Con el operador pipe (viene en el paquete tidyverse)

lapop_2019 %>% names

# El operador pipe (%>%) pone lo que esta a su izquierda como primer argumento de la funcion que se pone a la derecha

head(lapop_2019, n = 5) %>% View # igual a usar View por fuera

View(head(lapop_2019, n = 5))

# Magritr ya esta cargado en tidyverse
# Dplyr ya carga el operador pipe

lapop_2019$idnum %>% length %>% View() # Se puede usar varias veces este operador, envia el resultado de la primera operacion.

# Los verbos del paquete dplyr --------------------------------------------

# Los verbos de dplyr son funciones que permiten limpiar bases de datos
# Se llaman verbos porque siempre hacen lo mismo en una estructura especifica.

# Filter: selecciona solo las filas que cumplen cierta condicion.

lapop_2019 %>% filter(estratopri == 901)

# Verbos se utilizan (idealmente) con el operador pipe
# Filter toma dos argumentos, base de datos y condicion logica
# Cuando se esta trabajando en condiciones logicas, siempre se usa el igual doble (==), no simple (=)

# Asignarle a un objeto lo que se está filtrando.

lapop_2019_costa <- lapop_2019 %>% filter(estratopri == 901)

lapop_2019_mayores_30 <- lapop_2019 %>% filter(q2 > 30)

lapop_2019_menores_30_mayores_20 <- lapop_2019 %>% filter(q2 >= 20, q2 <= 30) # La coma permite filtrar mas a partir de una segunda condicion logica

# La coma hace que se cumplan las dos condiciones al mismo tiempo

lapop_2019_menores_30_mayores_20 <- lapop_2019 %>% filter(q2 %>% between(20,30)) # Esto cumple la misma funcion que lo de arriba. (siempre mayor o igual y menor o igual)

# Quiero filtrar en base a un caracter (texto)

# Utilizar la funcion glimpse para observar las variables rapidamente

lapop_2019 %>% glimpse()

# Filtrar en base a urbano y rural (caracteres)

# lapop_2019_urbano <- lapop_2019 %>% filter(ur == "Urbano") 

# Verbo select() hace seleccion de variables

# Atajo el pipe es Ctrl + Shift + M

base_pequena <- lapop_2019 %>% select(idnum, estratopri, ur)

# Borrar un objeto de el ambiente: utilizar el comando rm en la consola

base_pequena_filtrada_costa <- base_pequena %>% filter(estratopri == 901)

# Aplicar select y filter en el mismo "call", en la misma linea de codigo. 

base_pequena_filtrada_costa <- lapop_2019 %>% select(idnum, estratopri, ur) %>% filter(estratopri == 901)

# Analisis Exploratorio con graficos --------------------------------------

# Seleccionar la edad y generar un diagrama de caja

lapop_2019 %>% select(q2) %>% boxplot
# lapop_2019 %>% select(q2) %>% hist requiere un cambio de tipo de datos de double a entero u otro numerico mas simple

lapop_2019$q2 <- as.numeric(lapop_2019$q2)

hist(lapop_2019$q2)

# Signo - permite seleccionar todo menos esa variable.

# Otros verbos de dplyr ---------------------------------------------------

# Arrange (ordenar) - ordena en base a los valores de una columna.

lapop_2019_ordenada_idnum <- lapop_2019 %>% arrange(idnum) # Ordena de forma ascendente

lapop_2019_ordenada_idnum_desc <- lapop_2019 %>% arrange(desc(idnum)) # Ordena de forma descendiente

# Se ordena en base a valores numericos para variables numericas
# En base al alfabeto para textos (caracteres)

lapop_2019_ordenada_idnum_region <- lapop_2019 %>% arrange(estratopri, idnum)

# Mutar (mutate) - crea o modifica columnas dentro de la base de datos.

lapop_2019_modificada <- lapop_2019 %>% mutate(edad = as.numeric(lapop_2019$q2), # Edad numerica
                                               costa = if_else(estratopri == 901, 1,0)) # Variable dummy

# Mutate - definir el nombre de la variable a crear o a modificar, un igual (simple =) y la expresion que define la variable.
# Para crear mas variables, utilizar una coma.
# En el call de mutate de arriba, creamos edad como una version numerica de q2.
# Para variables dicotomicas o dummy, se debe utilziar una funcion de ayuda, if_else o ifelse (cualquiera de las dos funciona)
# ifelse es como la funcion SI en Excel. 

# Transmutar - transmute - selecciona variables solamente y mantiene lo que se muta. 

lapop_2019_modificada_t <- lapop_2019 %>% transmute(edad = as.numeric(lapop_2019$q2),
                                                    costa = if_else(estratopri == 901, 1,0),
                                                    idnum,
                                                    provincia = estratopri) # Renombrar, nombre nuevo = nombre antiguo

# Agrupaciones y resumenes ------------------------------------------------

# El verbo summarise o summarize toma estadistica descriptiva para una variable en especifico. 

lapop_2019 %>% summarise(media_educacion = mean(ed, na.rm = TRUE), desviacion = sd(ed, na.rm = TRUE))

# NA, "not available" no disponible.
# NA se da como resultado de un calculo cuando hay NAs en los datos. 
# El remedio es utilizar un argumento en la funcion mean que diga "ignorar los NAs", na.rm = TRUE

# Utilizar agrupaciones (group_by) me permite hallar estadistica descriptiva para diferentes grupos.

lapop_2019 %>% group_by(estratopri) %>% summarise(media_educacion = mean(ed, na.rm = TRUE),
                                                  desviacion = sd(ed, na.rm = TRUE))

lapop_2019 %>% group_by(estratopri, q1) %>% summarise(media_educacion = mean(ed, na.rm = TRUE),
                                                      desviacion = sd(ed, na.rm = TRUE),
                                                      numero_personas = n())

