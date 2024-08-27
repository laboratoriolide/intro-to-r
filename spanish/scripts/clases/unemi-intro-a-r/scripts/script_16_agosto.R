# Script clase 16 de agosto

# Crear secciones de codigo con Ctrl + Shift + R

# Preliminares ------------------------------------------------------------

# Cargar paquetes

library(readr) # Para cargar bases de datos
library(tidyverse) # Paquete tidyverse multifuncion

# R como calculadora ------------------------------------------------------

# LIBRARY(readr) Existe sensibilidad de mayusculas en R

3+3

9+9

7-3

23*2 # Multiplicacion es con asterisco *

23/2 # Division es con slash /

5^2 # Sombrero ^

5^(1/2) # R respeta el orden de las operaciones (PEMDAS)

sqrt(5) # Funcion de raiz cuadrada

log(2) # Log sin ningun otro argumento es un logaritmo natural

log(2, base = 10) # Logaritmo base 10

exp(4) # funcion exponencial

pi # numero pi

exp(1) # numero e

# Asignacion --------------------------------------------------------------

# Crear variables en R (titulo no puede ser numero)
# Envia objetos al ambiente de trabajo

a <- 3 # Utilizar asignador

# Asignar un valor a una variable no imprime valor a la consola.

# Asignador es una flecha, <-, tiene un atajo es alt menos (-)

b <- 6 

# Operaciones con variables:

a + b

# Asignar texto

texto <- "hola" # Tiene que estar entre comillas

# Tambien se puede usar solo una comilla, '', pero no se recomienda

otro_texto <- 'hola otro texto' # No se pueden usar espacios en nombres de variables, si se permite espacio en los valores de las variables

# Funciones base ----------------------------------------------------------

# Funcion "print"

print(a) 

# Para entender una funcion, ver la documentacion de la misma
# Utilizar la funcion "help"
# Escribir ? y lo que se busca en la consola

# Una funcion tiene argumentos obligatorios y opcionales.
# No poner argumentos obligatorios equivale a un error de programacion

print()

# Secuencias

1:10 # secuencia de numeros del 1 al 10

seq(2,10,2)

# asignar una variable a una secuencia

secuencia <- seq(2,10,2)

# variables con variables con calculos

c <- a + b 

# Tipos de datos o "Clases" -----------------------------------------------

class(a) # Class devuelve el tipo de dato o la "clase" de la variable u objeto

class(texto)

class(secuencia) # Tener varios elementos no cambia el tipo de dato

factor_especial <- factor("especial")

class(factor_especial)

# Estructuras de datos ----------------------------------------------------

## Vectores ----------------------------------------------------------------

# Str (structure) devuelve la estructura de un objeto de R.

str(a) # Vector de un solo elemento

str(secuencia) # Vector de 5 elementos, numericos

# Los vector permiten seleccionar a partir del indice. 
# El indice se accede a partir de los corchetes.

secuencia[4] # Seleccionar el cuarto elemento del objeto secuencia

a[1] # Seleccionar el primer elemento del vector a

a[2] # NA "not available" no esta disponible.

# La funcion c nos permite crear vectores. Significa "concatenar" (unir)

mi_vector <- c("hola", "este", "es", "mi", "vector")

mi_vector[2]

TRUE # ELEMENTO logico verdadero
FALSE # Elemento logico falso

# generalmente sirven para argumentos de funciones

vector_logicos <- c(TRUE, FALSE, TRUE)
vector_logicos

vector_logicos[2]

length(vector_logicos) # Length mide la longitud en elemetntos de un vector

## Matrices ----------------------------------------------------------------

# Bidimensional, filas y columnas.
# Solamente pueden tener un solo tipo de dato.

matriz <-
matrix(data = 
         1
       :
         9
       , nrow = 
         3
       , ncol = 
         3
       , byrow = 
         F
)

matriz[1,1]
matriz[2,3]
matriz[3,]

fila_3 <- matriz[3,]
fila_3

## Dataframes --------------------------------------------------------------

#Creando un dataframe
muestra_df <- data.frame(secuencia = 
                           1
                         :
                           5
                         ,
                         aleatorio = rnorm(
                           5
                         ),
                         letras = c(
                           "a"
                           , 
                           "b"
                           , 
                           "c"
                           , 
                           "d"
                           , 
                           "e"
                         ))
muestra_df

str(muestra_df)

# int es integer (entero): numerico sin decimales

muestra_df$secuencia -> variable_secuencia

muestra_df[,1] # primera columna, todas las filas (mismo que pedir secuencia con signo de dolar)

dim(muestra_df)

rownames(muestra_df) # Nombres de las filas

# Cambiar nombres de las filas 

rownames(muestra_df) <- c("fila 1", "fila 2", "fila 3", "fila 4", "fila 5")

# Listas ------------------------------------------------------------------

lista_ejemplo <- list(muestra_df, a, b)

