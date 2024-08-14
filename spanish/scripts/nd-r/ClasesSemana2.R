# Instalar paquetes ----
install.packages("openxlsx")
install.packages("magrittr")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("rstatix")



# Cargar paquetes ----
# Cargando paquetes ----
library(openxlsx)
library(magrittr)
library(tidyverse)
library(dplyr)
library(rstatix)

# Cargando paquetes de forma conjunta mediante la función lapply()
paquetes<-c("magrittr","fdth","openxlsx")
lapply(paquetes,library,character.only=TRUE) # cargar varios paquetes

## filtrar: filter()----
# operador equivalencia
data_banco_filtrada<-data_banco %>% filter(Sucursal==62) %>% View() #error
data_banco_filtrada

data_banco_filtrada_dos<-data_banco %>% filter(Sucursal==62) %>% view()

# operador o: | (pleca)

#entrégame las observaciones de la sucursal 62 u 85
suc_dos<-data_banco %>% filter(Sucursal==62|85) # error sintaxis

data_banco %>% filter(Sucursal==(62|85)) #error de sintaxis 2

data_banco %>% filter(Sucursal==62|Sucursal==85) %>% view()

# operador %in%
data_banco %>% filter(Sucursal %in% c(443,267)) %>% view()


# filtrado por excepción
data_banco %>% filter(!(Sucursal %in% c(62,85))) %>% view("ejemplo")

# filtrado por 2 variables
data_banco %>% filter(Sucursal %in% c(62,85),Tiempo_Servicio_seg > 100) %>% view

# filtado por 3 variables

data_banco %>% filter(Sucursal == 85 & Tiempo_Servicio_seg < 100 & Satisfaccion == "Muy Bueno") %>% view()

# distinct()  y unique()
data_banco %>% distinct(Sucursal) # equivalente a unique() pero en dplyr
data_banco %>% unique(Sucursal) # error en el argumento del objeto , unique () es de rbase

unique(data_banco$Sucursal) #  r base
?unique

data_banco$Sucursal %>% unique()  # extracción de variable para verificación con unique

#si interesa filtrar las filas por matches de partes de strings, se trabaja
# con las funciones del paquetes 'stringr'
data_banco %>%
  filter(str_detect(Satisfaccion, (str_c(c("^Bu", "^Muy"), collapse="|")))) %>% view()


# Función select()----
data_banco[,5] # r base

data_banco %>% select(Sucursal,Transaccion) %>% view

data_banco %>% select(Tiempo_Servicio_seg) %>% boxplot()

data_banco %>% select(c(2,4,6)) %>% view()
data_banco %>% view()

data_banco %>% select(-Cajero)
data_banco %>% select(!c("Cajero","Satisfaccion")) %>% view()


## select y funciones complementarias

data_banco %>% select(contains("Tra")) %>% view()
data_banco %>% select(starts_with("S")) %>% view()

data_banco %>% select(contains("Tra"),ends_with("on")) %>% view() # selecciona variables que empiecen con "Tra", así como variables que terminen en "on"
data_banco_2 %>% select(contains("Tra") & ends_with("on")) %>% view("combined") #selecciona variables que cumplan con la condición que empiecen con "Tra" y terminen en "on"

data_banco %>% select(Monto,Transaccion,everything()) %>% view()

data_banco %>% select(Sucursal:Transaccion)


data_banco %>% rename(transaccion=Transaccion)

data_banco %>% select_all(toupper) # convirtiendo en mayúsculas el nombre de todas las variables
data_banco %>% select(matches("r?sa")) %>% view() #la función auxiliar matches() trabaja con expresiones regulares

# select() y filter()
data_banco %>% filter(Sucursal==62) %$% cor(Tiempo_Servicio_seg,Tiempo_Servicio_seg)

# quiero de data banco encontrar la correlación de pearson
# entre Tiempo y Monto para la sucursal 62

data_banco %>% select(Tiempo_Servicio_seg) %>% fivenum()  # error

# necesito los 5 números de tukey para la variable Tiempo de ser
?fivenum()

data_banco %$% fivenum(Tiempo_Servicio_seg,na.rm = TRUE)

# reubicar columnas: relocate()
data_banco_2 %>% relocate(Monto) #por default colocará a Monto al inicio del dataset
data_banco_2 %>% relocate(Monto,.after=Transaccion) %>% view("relocate_after") #colocando a Monto después de Transacción
data_banco_2 %>% relocate(amount=Monto) %>% view() #COlocando a Monto al inicio del dataset y cambiando su nombre por "amount"
