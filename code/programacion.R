# Programming o conceptos avanzados de programacion en R

# Preliminares ------------------------------------------------------------


library(tidyverse)

# Cargar datos

used_cars <- 
  read_csv("data/used_cars_ecuador.csv", locale = locale(decimal_mark = ",", grouping_mark = ".")) %>% 
  janitor::clean_names()

# Estructuras de Control --------------------------------------------------

# Condicional (el puro con llaves)

x <- used_cars$precio

if (x[1] > 30000) # en parentesis va la condicion { # entre llaves va lo que pasara en base al resultado de la condicion
  {print("El carro es caro") 
  print(paste0(x[1], " es lo que cuesta el carro"))
} else {
  print("El carro no es tan caro")
}

if (x[700] > 30000) # en parentesis va la condicion { # entre llaves va lo que pasara en base al resultado de la condicion
{print("El carro es caro") 
  print(paste0(x[700], " es lo que cuesta el carro"))
} else {
  print("El carro no es tan caro")
  print(paste0(x[700], " es lo que cuesta el carro"))
}

# resolucion en forma de funcion para dataframes: ifelse(), existe if_else() de dplyr

used_cars <-
  used_cars %>% 
  mutate(caro = if_else(precio > 30000, "El carro es caro", "El carro no es tan caro"))

# For loops

for (i in 1:100) {
  if(i > 5) {
    print(i)
    print ("i es bien grande")
  } else {
    print(i)
    print ("i no es tan grande")
  }
}

students_list <- c("Alan", "Cristian", "Vicky", "Anna")

for (student in students_list) {
  print(paste0("Hello", " ", student))
}

# repetition mediante rep()

n <- 100

data <- tibble(
  id = 1:(3*n),
  group = rep(1:3, each = n),
  training = rep(c("A", "B", "C"), each = n),
  score = round(rnorm(3*n, mean = 50, sd = 10), 2)
)

rep(1:3, 100)

# Funciones ---------------------------------------------------------------

funcion_que_saluda <- function (nombre1, nombre2){
  # saluda a dos personas mediante paste0
  print(paste0("Hola ", nombre1, " y ", nombre2 ))
}

funcion_que_saluda("Vicky", "Alan")

vicky_nombre <- "vicky"

alan_nombre <- "alan"

funcion_que_saluda(vicky_nombre, alan_nombre)

a <- c(0,1,2)

b <- c(0,3,5)

funcion_que_saluda(a,b)

# Lapply -----------------------------------------------


lista_de_nombres <- list(
  "Vicky",
  "Alan",
  "Cristian",
  "Luis",
  "Anna"
)

funcion_que_saluda <- function (nombre1){
  # saluda a dos personas mediante paste0
  saludo <- paste0("Hola ", nombre1)
  return(saludo)
}

funcion_que_saluda(lista_de_nombres[[1]])

lapply(lista_de_nombres, funcion_que_saluda)

a <- c(2,3,4,5,6,7, NA)

b <- seq(1,100, by = 2)

c <- rep(5, 100)

lista <- list(a,b,c)

lapply(lista, mean, na.rm = T)

# sapply y vapply

# sapply es "simplified apply"

sapply(lista, mean, na.rm = T)

resultado <- lapply(lista, mean, na.rm = T)

# vapply tiene argumento extra que devuelve un valor predeterminado

vapply(lista, mean, na.rm = T)