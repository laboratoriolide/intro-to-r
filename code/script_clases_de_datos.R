# Script para revisar clases (tipos) y estructuras de datos en R

mi_vector <- c(5,3,4,6)

# Es importante indexar vectores para seleccionar sus elementos

# se indexa con el operador de corchetes y el indice de cada elemento

mi_vector[1]

mi_vector[2]

elemento_2 <- mi_vector[2]

mi_vector[1:2]

# Operadores logicos

1 > 6 # operador logico mayor que. 

elemento_logico <- 6 > 3

class(elemento_logico)

# tipo de dato logico es que TRUE es equivalente a 1, FALSE es equivalente a 0. 

TRUE*FALSE

# Operador no es igual a 

6 != 6

6 == 6 # operador logico de igual es siempre doble igual para diferenciar del operador de asignacion = (para variables y argumentos en una funcion)

# Operadores logicos complejos (AND, OR y NOT)

# AND (y) & (ampersand)

6 == 6 & 5 == 3 # devuelve FALSE porque uno de los statements logicos (el segundo) es falso

6 == 6 & 5 == 5 # devuelve TRUE

# OR (O) | (signo de valor absoluto)

6 == 6 | 5 == 3 # devuelve TRUE porque uno de los statements logicos es verdadero

6 == 3 | 5 == 3 # devuelve FALSE porque ambos statements son falsos. 

!(6 == 3) # TRUE porque niega el FALSE dentro del parentesis. 

# R tiene dataframes de prueba

mtcars # dataframe

df <- mtcars

head(df) # ver las 6 primeras filas

tail(mtcars) # ver las 6 ultimas filas

head(df, n = 10) 

# Estadistica descriptiva rapida de cada columna

summary(df)

rownames(df)

# Yo puedo acceder a una sola columna de un dataframe mediante $

unique(df$mpg)

df[1,2] 

df[1,] # poner coma y en blanco para sacar toda la primera fila (todas las columnas)

df[,2] # esto es igual a usar el dolar (pero con indexacion numerica)

df[, "drat"] # igual que arriba, pero con el nombre de la columna

df$drat # el signo de dolar es para acceder a una columna de la misma manera que se hace con indices.

df$`variable con espacio` <- df$drat

df$`variable con espacio` # Utilizar apostrofes para nombres invalidos

base_de_datos_con_un_nombre_muy_largo <- df

mpg

attach(base_de_datos_con_un_nombre_muy_largo)

# no utilizar attach!!

mpg

# en r se elimina todo del ambiente con rm(list = ls())

# las listas combinan objetos de cualquier tipo (dataframes, vector, matrices, etc.)

mi_primera_lista <-
  list(df, elemento_2, elemento_logico, matrix(2,2,3))

str(mi_primera_lista)

mi_primera_lista[1]

mi_primera_lista[2]

unlist(mi_primera_lista)
