# Visualizacion de datos con R

# Preliminares -------------------------------------------------------------

# Cargar librerias

library(readr) # cargar csv
library(dplyr)
library(ggplot2)
library(ggthemes)

# Cargar datos

used_cars <- 
  read_csv("data/used_cars_ecuador.csv", locale = locale(grouping_mark = ".", decimal_mark = ",")) %>% 
  janitor::clean_names()

# Visualizacion con R base ------------------------------------------------

# Histograma de precio

# limitarnos a Quito

used_cars_quito <-
  used_cars %>% 
  filter(lugar == "Quito")

hist(used_cars_quito$precio) # parece que R no carga correctamente el precio, arreglar el separador de miles

# arreglado una vez que cambie el "locale" de los datos: avisandole a R que utilice el sistema internacional para leer datos

# con format yo puedo visualizar sin notacion cientifica (1e05)

precios_sin_notacion_cientifica <- format(used_cars_quito$precio, scientific = F)

# visualizar el summary() de la variable

summary(used_cars_quito$precio)

hist(log(used_cars_quito$precio))

# Plot (scatter plot o diagrama de dispersion) entre el precio y el kilometraje

used_cars_quito <-
  used_cars_quito %>% 
  filter(precio %>% between(2000, 300000))

plot(used_cars_quito$kilometraje, used_cars_quito$precio)

# Ggplot 2!!! -------------------------------------------------------------

# Dispersion

used_cars_quito %>% 
  ggplot(aes(x = kilometraje, y = precio)) + 
  geom_point()

# Histograma

used_cars_quito %>% # 1era capa: datos
  ggplot(aes(x = precio)) +  # 2da capa: esteticas
  geom_histogram(bins = 25, fill = "skyblue", color = "black") + # 3ra capa: geometria (tipo de grafico)
  #ggtitle("Histograma de precio de los carros usados en Ecuador", subtitle = "Datos de Kaggle"), asi se puede poner titulos
  labs(title = "Histograma de precios de carros usados en ECU",
       subtitle = "Datos de Kaggle",
       x = "Precio (USD)",
       y = "Frecuencia (número de carros)")

# fill es el relleno de una geometria (por ejemplo, el relleno de la barra)
# color, es el delineado de la geometria, generalmente.
# se puede utilizar hex codes

used_cars %>% 
  ggplot(aes(precio)) + 
  geom_histogram(bins = 10, fill = "#FEDB00", color = "#0033A0") + 
  theme_minimal()

# theme_minimal es un tema predeterminado
# tambien hay otros: theme_bw(), theme_gray (ya vienen con ggplot2)
# ggthemes es un paquete que trae mas temas

used_cars %>% 
  ggplot(aes(precio)) + 
  geom_histogram(bins = 10, fill = "#FEDB00", color = "#0033A0") + 
  theme_economist()

# cambiar limites de los ejes con xlim, ylim

used_cars_quito %>% 
  ggplot(aes(x = kilometraje, y = precio)) + 
  geom_point() +
  scale_y_continuous(labels = scales::number_format(big.mark = ",")) +  #number_format funciona mejor que scales::comma
  theme_bw()
  #xlim(2000, 200000) + 
  #ylim(2000, 180000) +

# boxplot

used_cars_quito %>% 
  ggplot(aes(precio)) +
  geom_boxplot() + 
  scale_x_continuous(labels = scales::number_format(big.mark = ",")) + 
  coord_flip() + # da la vuelta 90 grados a las escalas.
  labs(title = "Boxplot de precio",
       subtitle = "Datos de Kaggle",
       x = "Precio") + 
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
  

# diagrama de lineas con puntos

# precio promedio a lo largo del tiempo

used_cars %>% 
  group_by(ano) %>% 
  summarise(mean = mean(precio, na.rm = T)) %>%
  filter(ano > 2000) %>% 
  ggplot(aes(ano, mean)) +
    geom_point() + 
    geom_line()

# ojiva (frecuencia acumulada)
# poner datos en cut() para crear intervalos

# ojiva de precios:

used_cars %>%
  filter(precio > 0) %>% 
  mutate(intervalo = cut(precio, breaks = 7)) %>% 
  group_by(intervalo) %>% 
  summarise(count = n()) %>% 
  tidyr::drop_na() %>% 
  mutate(frecuencia_acumulada = cumsum(count)) %>% 
  ggplot(aes(intervalo, frecuencia_acumulada, group = 1)) + # group = 1 cunado grafico un solo punto con una variable categorica.
  geom_point() + 
  geom_line()

# visualizacion de variables categoricas generalmente comprende diagramas de barras

# utilizando geom_col: se grafica EXACTAMENTE lo que esta en el dataframe

used_cars %>%
  group_by(lugar) %>% 
  summarise(precio_promedio = mean(precio, na.rm = T)) %>% 
  ggplot(aes(lugar, precio_promedio)) + 
    geom_col() + 
  theme(axis.text.x = element_text(angle = 90))

# utilizando geom_bar, se tiene una agrupacion para contar frecuencias por categoria incorporada. 
# geom_bar NO grafica exactamente lo que se ve en una base de datos (salvo le diga lo contrario)

used_cars %>% 
  ggplot(aes(lugar)) + 
  geom_bar()
  #geom_bar(stat = "identity") # CON IDENTITY, se grafica exactamente lo que esta en el dataframe