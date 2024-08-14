# Instalar paquetes ----
install.packages("openxlsx") #permitir importar archivos de excel
install.packages("tidyverse") # manipulación y ordenamiento de datos
install.packages("magrittr") # operador pipe
install.packages("readr")

# Cargar paquetes ----
library(openxlsx)
library(magrittr)
library(tidyverse)

## arrange()
data_banco %>% arrange(Tiempo_Servicio_seg) %>% view("arrange") #por default arrange() ordena las filas de menor a mayor
data_banco %>% arrange(desc(Tiempo_Servicio_seg)) %>% view("arrange_1") # para ordenar filas de mayor a menor, usamos la función auxiliar desc()

data_banco %>% arrange(Transaccion,desc(Tiempo_Servicio_seg)) %>% view("arrange_2")

# mutate() - transmute()
# crear variables o modificar variables

#mutate()
# crear la variable de tiempo de serv en minutos
data_banco_2<-data_banco %>% mutate(Tiempo_serv_min=Tiempo_Servicio_seg/60) %>% view("mutate_1") #crea  una variable nueva y lo agrega al dataframe original

data_banco %>% transmute(Tiempo_serv_min=Tiempo_Servicio_seg/60) %>% view("Transmute") #crea una variable nueva pero no la agrega al dataframe original

# glimpse()que se utiliza con tibble ---str()
# tibble es una estructura de datos: es un dataframe MEJORADO!

data_banco<-tbl_df(data_banco)

glimpse(data_banco)

# la familia str_*() pertenece al paquete stringr
data_banco_3<-data_banco %>% mutate(Monto=str_replace(Monto,pattern=",",replacement=".")) %>%
  mutate(Sucursal=as.character(Sucursal),
         Cajero=as.character(Cajero),
         Satisfaccion=parse_factor(Satisfaccion,levels=c("Muy Malo","Malo","Regular","Bueno","Muy Bueno"),ordered=T),
         Monto=parse_number(Monto,locale=locale(decimal_mark = ".")))

glimpse(data_banco_3)



# descripción de datos
summary(data_banco_3)

# función summary()
summary(data_banco) #la función summary() nos permite obtener rápidamente ciertas medidas de resumen
# del centro y de posición. La desventaja es que no retorna medidas de dispersión.

# paquete para descriptive: rstatix
data_banco %>% get_summary_stats() %>% view() #esta nueva función del paquete rstatix es amigable
# con la sintaxis tidyverse
# esta función retorna un tibble que contiene medidas de tedencia central y de dispersión

# summarise()
data_banco_3 %>% summarise(PROMEDIO_TIEMPO=mean(Tiempo_Servicio_seg),
                           DESVEST_TIEMPO=sd(Tiempo_Servicio_seg)) %>% view() #con summarise() puedo declarar las medidas de resúmenes para alguna variable en particular y retorna  un tibble

# funciones auxiliares
data_banco_3 %>% summarise_at(vars(Tiempo_Servicio_seg,Monto),
                              list(PROMEDIO=~mean(.,na.rm = TRUE),
                                   DESVEST=~sd(.,na.rm=TRUE))) %>% view("summarise") #esta función auxiliar tiene la ventaja de permitir declarar en el argumento vars() 2 variables o más a ser resumidas
data_banco_3 %>% summarise_if(is.numeric,
                              list(PROMEDIO=~mean(.,na.rm=TRUE),
                                   DESVEST=~sd(.,na.rm=TRUE))) %>% view("summarise_if") #esta función auxiliar tiene la ventaja de declarar el tipo de dato sobre el cual se aplicarán las medidas de resúmenes

# agrupamientos: group_by()
# Explorando y agrupando---- summarise() es más útil cuando va combinado con group_by()
#agrupando por una variable
data_banco_3 %>% group_by(Transaccion) %>%
  summarise(PROMEDIO_TIEMPO=mean(Tiempo_Servicio_seg)) %>%
  view("grp_summ")

# muestre la media y la desv estándar del tiempo de serv en segundos para
# la sucursal 443 por transacción y satisfacción

data_banco_3 %>% filter(Sucursal == 443) %>% # antes de agrupar, es posible hacer otro tipo de manipulación como por ejemplo filtrar el objeto
  group_by(Transaccion,Satisfaccion) %>%
  summarise(PROMEDIO_TIEMPO=mean(Tiempo_Servicio_seg),
            DESVEST_TIEMPO=sd(Tiempo_Servicio_seg)) %>% view("doblegrup")

## UNIR DATOS
df_1;df_2

# agregar filas: rbase - tidyverse
bind_rows(df_1,df_2) %>% view("bindrows1")
rbind(df_1,df_2)

rbind(df_2,df_1)

df_3

bind_rows(df_1,df_3) %>% view("bindrows2")
rbind(df_1,df_3) #no me permite agregar filas por dimensionalidad

#agregar columnas: bind_cols()
bind_cols(df_1,df_2)

# agregar columnas
#Si los 2 dfs tienen exactamente las mismas filas o unidades de análisis ( y ademas en el mismo orden).
#En este caso, solo habría que juntar en una misma tabla las columnas de df1 y de df3.
#Esto lo podemos hacer con bind_cols() (o con cbind() de R-base)
bind_cols(df_1,df_3)

# JOINS----
# Las variables usadas para conectar cada par de variables se llaman claves (del inglés key)

# En dplyr hay 3 tipos de funciones(verbos) que se ocupan de diferentes operaciones para unir datasets:
# Mutating joins
# Filtering joins
# Set operations

# r base: merge()
# inner_join

#inner_join(x,y): Retorna todas las columnas de x y también las de y,
#PERO solo retorna las filas de x que tienen una equivalencia en y. (
#la equivalencia se define en función del valor de una variable o variables comunes en x e y)

df_6<-data.frame(A=c("Ana","Jose","Daniel"),B=c(100,200,300))

df_1 %>% view("df_1")
df_6 %>% view("df_6")

merge(x=df_1,y=df_6,by.x="Nombre",by.y = "A") %>% view("inner")

# right join

##rigth_join(x,y): Retorna todas las columnas de x y también las de y;
#en cuanto a las filas, retorna TODAS las filas de y.
#(Si hubiesen varios matches entre x e y  se retornan todas las combinaciones)

merge(x=df_1,y=df_6,by.x="Nombre",by.y="A",all.y=TRUE) %>% view("right")

#left join
##left_join(x,y): Retorna todas las columnas de x y también las de y;
#en cuanto a las filas, retorna TODAS las filas de x.
#(Si hubiesen varios matches entre x e y  se retornan todas las combinaciones)
merge(x=df_1,y=df_6,by.x="Nombre",by.y="A",all.x = TRUE) %>% view("left")

# full join
# full_join(x,y): Retorna todas las columnas de x y también las de y;
# en cuanto a las filas, retorna TODAS las filas de x e y . Osea, retorna TODAS las filas y TODAS las columnas de las 2 tablas.
# (Donde no hay matches retorna NA’s)
merge(df_1,df_6,by.x="Nombre",by.y="A",all=TRUE) %>% view("full")

#Nota: Las mutating joins se usan principalmente para añadir columnas,
#PERO en el proceso pueden generarse nuevas filas.
# Joins en tidyverse

#inner join
df_1 %>% inner_join(df_6,by=c("Nombre"="A")) %>% view("inner_td")

#left join
df_1 %>% left_join(df_6,by=c("Nombre"="A")) %>% view("left_td")

# right join
df_1 %>% right_join(df_6,by=c("Nombre"="A")) %>% view("right_td")

# full join
df_1 %>% full_join(df_6,by=c("Nombre"="A")) %>% view("full_td")

