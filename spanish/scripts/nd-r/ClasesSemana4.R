## Cargando librerías
library(openxlsx)
library(magrittr)
library(dplyr)
library(tidyverse)

# tidyr
# importando la data
base_1<-read.xlsx("Data/bases/base_1.xlsx",detectDates = TRUE)
base_1 %>% view()

names(base_1)

# gsub(): vamos a reemplazar el "-" por "." en el nombre de to  das las variables
names(base_1)<-gsub("-",".",names(base_1))

names(base_1)

# RESHAPE DATA: gather()

long_base_1<-base_1 %>% gather(key="Mes",value = "Exportaciones",Valor.en.2008.M01:Valor.en.2008.M07) %>%
  view("gather")

# SPLIT CELLS: separate()

separate_1<-long_base_1 %>% separate(Mes,c("chr1","chr2","Año","mes")) %>% view("separate")

long_base_1 %>% separate(Mes,c("Caracter","Anio","Caracter2","mes"),sep=c(9,13,14,17)) %>% view() #otro ejemplo usando el argumento sep de la función separate()


## PIVOTANDO: pivot_longer()

base_1 %>% pivot_longer(cols = Valor.en.2008.M01:Valor.en.2008.M07,
                        names_to="Mes",values_to = "Exportaciones") %>% view("pivot_1")

base_1 %>% pivot_longer(
  cols= Valor.en.2008.M01:Valor.en.2008.M07,
  names_to = c("chr1","chr2","Año","mes"),
  names_pattern = "(Valor).(en).(....).(.*)",
  values_to = "Exportaciones"
) %>% view("pivot_pw")

# Mejorando los scripts: purrr
files<-list.files(path = "Data/bases",pattern = "*.xlsx",full.names = TRUE)

# importar
# paquete purrr: map_df()
# rbase: sapply()

# paquete purrr: map_df()
TOTAL<-map_df(files,read_excel)

# importación masiva con sapply()
tbl<-sapply(files,read_excel,simplify = TRUE) %>% bind_rows(.id="id")

View(tbl)

names(tbl)<-gsub("Valor en ","AÑO",names(tbl))
names(tbl)<-gsub("-",".",names(tbl))
names(tbl)<-gsub("Código del producto","Partida",names(tbl))

#pivotear

tbl %>% pivot_longer(
  cols = AÑO2008.M01:AÑO2011.M09,
  names_to = c("chr","año","chr2","mes"),
  names_pattern = "(AÑO)(.*).(M)(.*)",
  values_drop_na = TRUE,
  values_to = "Exportaciones"
) %>%
  select(-c("id","chr","chr2")) %>%
  filter(Partida == "partida.0603") %>% view("tddp")

# toy data
pollution <- tribble(
  ~city, ~particle_size, ~amount,
  "New York", "large",      23,
  "New York", "small",      14,
  "London", "large",      22,
  "London", "small",      16,
  "Beijing", "large",     121,
  "Beijing", "small",     121
)

pollution %>% view()

pollution %>% spread(key= particle_size, value = amount) %>% view("spread")

# reescriban la línea de código 21 con pivot_wider()
?pivot_wider

pivot_wider()

#  Introduccion ggplot2 ----
anscombe
anscombe_df<-anscombe %>% pivot_longer(
  cols = everything(),
  names_to = c(".value","CASO"),
  names_pattern = "(.)(.)") %>% select_all("toupper") %>% view()

## crear un gráfico
# paquete ggplot2
## ggplot()
ggplot(anscombe_df,aes(x=X,y=Y)) + geom_point(aes(color=CASO))

anscombe_df

ggplot(data = anscombe_df)

anscombe_df %>% ggplot()

ggplot(data = anscombe_df,mapping = aes(x = X, y = Y)) +
  geom_point(mapping = aes(color= CASO))

ggplot(anscombe_df) +
  geom_point(mapping = aes(x= X, y = Y), color = "blue")

ggplot(anscombe_df) +
  geom_point(mapping = aes(x= X, y = Y, color = "blue"))

## facet: facet_wrap(), facet_grid()

ggplot(anscombe_df,aes(x = X, y = Y)) +
  geom_point(aes(color = CASO)) +
  facet_wrap("CASO",nrow = 1) +
  labs(title = 'Gráfico Anscombe cuarteto', y = "Cantidad", x = "Cantidad 2")


## VARIABLES CUANTITATIVAS: una variable cuantitativa
# geom_histogram

# graficar la variable tiempo de servicio en segundos de data banco
# mediante un histograma (por sucursal)

geom_histogram()
data_banco_3 %>% view()

ggplot(data_banco_3,aes(x= Tiempo_Servicio_seg)) +
  geom_histogram() +
  labs(title = "Distribución del Tiempo de Servicio en segundos", y = "Cantidad", x = "Tiempo (Segs)") +
  facet_wrap(~Sucursal)







