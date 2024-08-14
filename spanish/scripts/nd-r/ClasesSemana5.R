## Cargando librerías-----
library(openxlsx)
library(magrittr)
library(dplyr)
library(tidyverse)
library(readxl)
library(ggplot2)
library(patchwork)

## una variable CT
ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram()

# componente básico del gráfico: título y nombres a los ejes
ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram() +
  labs(title = "Distribución del Tiempo", y = "Cantidad", x = "Tiempo") +
  facet_wrap("Sucursal")

# Extensión para variables CT #####

# themes
ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram() +
  labs(title = "Distribución del Tiempo", y = "Cantidad", x = "Tiempo") +
  facet_wrap("Sucursal") +
  theme_light()


ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram() +
  labs(title = "Distribución del Tiempo", y = "Cantidad", x = "Tiempo") +
  theme_light()

range(data_banco_3$Tiempo_Servicio_seg)

# podemos crear nuestros propios intervalos
breaks_histograma<-c(seq(from = 0, to = 900, by = 30),1200,1700)

# ahora a construir un nuevo gráfico basado en el objeto breaks_histograma

ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_freqpoly(breaks = breaks_histograma)

# ¿qué pasa si escribo 2 geometrías: geom_histogram() y geom_freqpoly()?

# answer: se superponen!

ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram() +
  geom_freqpoly(breaks = breaks_histograma)  # con breaks no iguales entre geometrías

ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram(breaks = breaks_histograma) +
  geom_freqpoly(breaks = breaks_histograma) # superposición con breaks iguales entre geometrías

# la densidad de mis datos: es una buena forma de ver mis datos
sin_breaks<-data_banco_3 %>% ggplot(aes(x = Tiempo_Servicio_seg)) +
  geom_histogram(aes(y=..density..))

con_breaks<-data_banco_3 %>% ggplot(aes(x = Tiempo_Servicio_seg)) +
  geom_histogram(aes(y=..density..),breaks = breaks_histograma) +
  geom_density(color = "orange", linetype= "dashed", size = 1, alpha = 0.7)

sin_breaks / con_breaks # usando patchwork

data_banco_3 %>% ggplot(aes(x = Tiempo_Servicio_seg)) +
  geom_density(color = "orange")

# El famoso boxplot: diagrama de cajas
ggplot(data_banco_ok,aes(x="",y= Monto)) +
  geom_boxplot(fill="steelblue")

ggplot(data_banco_ok,aes(x="",y= Monto)) +
  geom_boxplot(aes(fill= Sucursal)) + ## FILL
  coord_flip()

ggplot(data_banco_ok,aes(x="",y= Monto)) +
  geom_jitter(alpha = 0.05, color = "gray") +
  geom_boxplot(fill="steelblue")

# combinemos
ggplot(data_banco_ok,aes(x= "",y= Monto)) +
  geom_jitter(alpha = 0.05, color = "gray") +
  geom_boxplot(fill = "steelblue",alpha = 0.1) +
  coord_flip() +
  labs(title = "Boxplot de Monto", y = "Dólares") +
  theme_light()

# 3D
#función scatterplot3D
library(scatterplot3d)

scatter3D(data_banco_3$Tiempo_Servicio_seg,data_banco_3$Monto,data_banco_3$Tiempo_Servicio_seg,bty = "g")

## VARIABLES CUALITATIVAS
# variable sucursal

ggplot(data_banco_ok,aes(x=Sucursal)) +
  geom_bar()+
  labs(title="Cantidad de transacciones por Sucursal", y ="Cantidad")

# ordenar las barras
ggplot(data_banco_ok,aes(x=forcats::fct_infreq(Sucursal)))+
  geom_bar()+
  labs(title="Cantidad de transacciones por Sucursal", y ="Cantidad", x ="Sucursal")

# dando color
ggplot(data_banco_ok,aes(x=forcats::fct_infreq(Sucursal)))+
  geom_bar(aes(fill= Sucursal)) +
  geom_text(aes(label = stat(count)),stat="count", nudge_y = 500)+
  labs(title="Cantidad de transacciones por Sucursal", y ="Cantidad", x ="Sucursal")+
  theme_bw()+
  theme(legend.position = "none") #esta línea de código desaparece la leyenda


# Analizando varias variables
ggplot(data_banco_ok,aes(x=Tiempo_Servicio_seg)) +
  geom_density(aes(color = Nuevo_Sistema, fill = Nuevo_Sistema), alpha= 0.3) +
  facet_grid(Transaccion~Satisfaccion)
# Funciones: (user-defined functions)-----

# crear nuestra primer función (Simple)

# crear función para convertir grados celsius a farenheit

c_to_f <- function(celsius,freezing)
  9/5*celsius + freezing

c_to_f(celsius = 20)

# 1. ¿podemos no colocar el label del argumento dentro de la función?

c_to_f(20)

c_to_f(20,32)
c_to_f(celsius = 20, freezing = 32)

c_to_f(32,20) # entregando el valor de 32 para celsius, y de 20 para freezing

# 2. ¿ qué pasará si declaro un label?

c_to_f(freezing = 32, 20) # ¡correcto!

## asignar valores por default ##

c_to_f <- function(celsius, freezing = 32)
  9/5*celsius + freezing

c_to_f(20)


# 3. si el argumento freezing viene por default,
# ¿será posible setearle un nuevo valor a freezing?

c_to_f(20, freezing = 15)

## BIEN :) --- LÓGICA BÁSICA DE CREAR UNA FUNCIÓN SIMPLE ----

##IT'S YOUR TURN

## Crear una función simple (1 línea en el cuerpo)
# que me entregue el promedio de 2 valores
# HINT: piensen en qué argumentos recibe la función
# piensen en la fórmula de promedio


media <- function(numberone,numbertwo)
  (numberone + numbertwo)/2

media(50,40)
media(90,65)


## crear funciones más complejas
c_to_f <- function(celsius, freezing = 32)
  9/5* celsius + freezing

c_to_f <- function(celsius, freezing = 32){
  multiplicacion <- 9/5* celsius
  multiplicacion + freezing
}

c_to_f(20)

c_to_f <- function(celsius, freezing = 32){
  multiplicacion <- 9/5* celsius
  f <- multiplicacion + freezing

  f
}

c_to_f(20)

## return()
c_to_f <- function(celsius, freezing = 32){
  multiplicacion <- 9/5* celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f(20)

## FUNCIONES ( crear)

# programación a la defensiva
# assertion statements

c_to_f <- function(celsius, freezing = 32){
  multiplicacion <- 9/5*celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f(20)

c_to_f(a)

# evaluar una condición sobre el argumento celsius
# crear un ERROR: funcipon stop()

# condición " si celsius es numeric", " si celsius no es numeric#

# if statements

# if( the conditional statement is TRUE){
# do something}

c_to_f <- function(celsius, freezing = 32){
  if(!is.numeric(celsius)){
    stop("celsius debe ser un vector numerico")
  }
  multiplicacion <- 9/5*celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f(20)

c_to_f("a")
c_to_f(TRUE)

# para 2 argumentos que estén libres

c_to_f <- function(celsius, freezing){
  if(!is.numeric(c(celsius,freezing))){
    stop("los argumentos deben ser numericos")
  }
  multiplicacion <- 9/5 * celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f(TRUE,"B")
c_to_f(20,"B")

c_to_f_proof <- function(celsius, freezing){
  if(!is.numeric(celsius) | !is.numeric(freezing)){
    stop("los argumentos deben ser numericos")
  }
  multiplicacion <- 9/5 * celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f_proof("a",32)


## IT'S YOUR TURN!!!

# 1. convertir la función simple que calculaba el promedio
# de 2 números, en una función más compleja que incluya:
# un objeto que se  llame "promedio"
# retorne dicho objeto

## 2. escriban un if statement sobre los 2 argumentos numéricos,
## con un mensaje que retorne "este es mi primer error"



##########
## if_else()

c_to_f <- function(celsius, freezing = 32){
  if(!is.numeric(celsius)){
    stop("celsius debe ser numerico")
  } else{
    print("buen trabajo")
  }

  multiplicacion <- 9/5*celsius
  f <- multiplicacion + freezing

}




c_to_f("a")

c_to_f(20)


##############

# ¿ qué pasaría si tuviéramos que evaluar varias condiciones ?

# stopifnot()

c_to_f <- function(celsius, freezing){
  stopifnot(is.numeric(celsius), is.numeric(freezing),!is.na(celsius),!is.na(freezing))
  multiplicacion <- 9/5*celsius
  f <- multiplicacion + freezing

  return(f)
}

c_to_f(20,32)

c_to_f("a",32)

c_to_f("a",TRUE)

### Rdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAkCAYAAAD7PHgWAAAA00lEQVR42mNgGAWjYBQMUxAauorZLL452TyhZQUtMMhs47QGLrIdaJ7QmtSyeP+5fTc//N98+e1/agGQWSvOvPqfNGHnRbO4lnjyHRjfvHzvzff/Zx5+/r9x60OqORBkFgg3bHnw1yy+ZQkFIdiyAuRbmIHUdiAIg+wYdeCoA0cdOOrAUQdSyYG0wKMOHHUgOQ6kNGOMOhCXpaMOHHXgiHTgSmDva9A6ENRvTejfcYFWDkzs33kBZAfZDvTMncQO6huDup+06rhbhvZxjg6RjILBDgAZYqbbTdtPRgAAAABJRU5ErkJggg==ETORNO DE VARIOS OBJETOS ####

# vamos a crear una función de medidas descriptivas

medidas_descriptivas <- function(datos){
  if(!is.data.frame(datos)){
    stop("los datos deben ser un dataframe")
  }
  columnas_numericas <- sapply(datos,is.numeric)
  media_datos <- sapply(datos[,columnas_numericas], mean, na.rm = TRUE)
  varianza_datos <- sapply(datos[,columnas_numericas], var, na.rm = TRUE)

  resultado <- list(media = media_datos, varianza = varianza_datos)

  return(resultado)

}

medidas_descriptivas(data_banco)

medidas_descriptivas(data_banco_ok)






