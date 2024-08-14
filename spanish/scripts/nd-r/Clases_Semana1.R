#Instalar paquetes ----
# Nunca se debe instalar un paquete en un script de R, esto se debe hacer en la consola de R, pero para efectos de este curso se ha incluido en el script
install.packages("tidyverse")
install.packages("openxlsx")
install.packages("magrittr")

# Cargar paquetes ----
library(tidyverse)
library(openxlsx)
library(magrittr)

# Generalidades de R ----
2 + 3 # expresión
a <- 2
edad <- c(32,45,67,9) # asignación para crear un vector

log(3)
round(log(3)) # escritura de código en r-base

# secuencias y repeticiones
seq(5,20,by=5)
rep(log(3),6)

#una secuencia del 10 al 20 de 5 en 5
seq(10,20,5)

seq(10,5,20) # esta es una forma erróna de escribir argumentos de una función

seq(5,by=5,length.out = 5)
seq(5,5,length.out = 5)

# Proceso de tidyverse: introducción
#Importación de datos: paquete openxlsx
library(openxlsx)

data_banco<-read.xlsx("Data/Data_Banco.xlsx",sheet = "Data")

# Estructuras de datos de R
# vectores
edades<-c(25,45,36,75,86) #creando un vector NUMÉRICO con la función c()
nombres<-c("ana","mariela","sandy","jorge","janina")

obj_nonez<-c(25,45,"ana","mariela")

# dataframe
df_1<-data.frame(edades,nombres)
df_2<-data.frame(Edades=c(34,59,68,54),Ciudad=c("Uio","Gye","Uio","Mch"))


names(df_1)
rownames(df_1)<-paste("id_",1:5,sep="")

# Entender data : Data Banco
str(data_banco)

# Creando factores en R
puntuaciones<-c("Regular","Malo","Regular","Bueno")

fct_pt<-factor(c("Regular","Malo","Regular","Bueno"),levels = c("Malo","Regular","Bueno","Muy Bueno","Excelente"),ordered=T)

unique(data_banco$Satisfaccion)


## Cambio de tipo de datos

# familia de funciones as.*(): esta familia de funciones hace coerción de los tipos de datos

# lógico -> entero -> numérico -> caracter
#logical -> int    ->   num   -> chr


# tipo de dato num a chr
6
as.character(6)

# de factor a chr
fct_pt_no<-as.character(fct_pt)
is.character(fct_pt)

# de chr a numerico
"seis"

as.numeric("seis")

