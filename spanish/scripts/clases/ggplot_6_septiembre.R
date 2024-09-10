# Graficos con ggplot2

# Preliminares ------------------------------------------------------------

# Librerias

library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)
library(readr)
library(forcats)

# Cargar datos

supercias <- read_excel("data/directorio_companias.xlsx", 
                        skip = 4) %>% # Saltarse las primeras 4 filas
             janitor::clean_names() # Clean names viene de la libreria janitor

# Limpieza preliminar -----------------------------------------------------

# Convertir capital suscrito a numerico (de lo que es texto), considerando que tiene comas como separador decimal.
# Utilizar readr, parse_number.

supercias_limpio <-
  supercias %>%
  mutate(capital_suscrito = parse_number(capital_suscrito, locale = locale(decimal_mark = ",", grouping_mark = ".")))

# Graficacion con ggplot2 ----------------------------------------------------------------

## Histograma -----------------------------------------------

# Empezamos con la capa de estetica

ggplot(supercias_limpio, aes(capital_suscrito)) + # se utiliza el mas para crear nuevas capas de la gramatica de graficos
  geom_histogram(bins = 50, color = "blue", fill = "cyan") + # Geometria de histograma
  theme_bw() + 
  labs(x = "Capital Suscrito (en dólares USD)",
       y = "Frecuencia de ocurrencias (empresas)",
       title = "Histograma de empresas por capital suscrito",
       subtitle = "Datos de SUPERCIAS 2024")
  
# Para ggplot, "color" es el delineado de una barra
# "fill" o relleno es el relleno de la barra

# Como manejar el histograma que no grafica adecuadamente los intervalos:
# 1. aplicar escala log
# 2. filtrar valores atipicos

# Escala log

supercias_limpio %>%
  filter(capital_suscrito != 0) %>% 
  ggplot(aes(capital_suscrito)) + # se utiliza el mas para crear nuevas capas de la gramatica de graficos
    geom_histogram(bins = 50, color = "blue", fill = "cyan") + # Geometria de histograma
    theme_bw() + 
    labs(x = "Capital Suscrito (en dólares USD)",
         y = "Frecuencia de ocurrencias (base log 10)",
         title = "Histograma de empresas por capital suscrito",
         subtitle = "Datos de SUPERCIAS 2024") +
    scale_y_log10()

q1 <- quantile(supercias_limpio$capital_suscrito, probs = 0.25, na.rm = T)
q3 <- quantile(supercias_limpio$capital_suscrito, probs = 0.75, na.rm = T)

supercias_limpio %>%
  filter(capital_suscrito != 0) %>% 
  ggplot(aes(capital_suscrito)) + # se utiliza el mas para crear nuevas capas de la gramatica de graficos
  geom_histogram(bins = 50, color = "blue", fill = "cyan") + # Geometria de histograma
  theme_bw() + 
  labs(x = "Capital Suscrito (en dólares USD)",
       y = "Frecuencia de ocurrencias (base log 10)",
       title = "Histograma de empresas por capital suscrito",
       subtitle = "Datos de SUPERCIAS 2024") +
  xlim(q1,q3)

supercias_limpio %>%
  filter(capital_suscrito != 0,
         capital_suscrito %>% between(q1,q3)) %>% 
  ggplot(aes(capital_suscrito)) + # se utiliza el mas para crear nuevas capas de la gramatica de graficos
  geom_histogram(bins = 30, color = "blue", fill = "cyan") + # Geometria de histograma
  theme_bw() + 
  labs(x = "Capital Suscrito (en dólares USD)",
       y = "Frecuencia de ocurrencias",
       title = "Histograma de empresas por capital suscrito",
       subtitle = "Datos de SUPERCIAS 2024")

## Diagrama de caja -----------------------------------------------

# Utilizar la geometria geom_boxplot()

# Se debe hacer filtrado para poder visualizar mejor la distribucion del grafico

supercias_limpio %>%
  filter(capital_suscrito > q1 - 1.5 * IQR(capital_suscrito, na.rm = T),
         capital_suscrito < q3 + 1.5 * IQR(capital_suscrito, na.rm = T)) %>% 
  ggplot(aes(capital_suscrito)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  coord_flip()

# Tabla de Frecuencias ----------------------------------------------------

# Aplico un filtro para evadir valores atipicos (por ejemplo, capital suscrito negativo o demasiado alto)
# Crear los intervalos mediante la funcion cut, debe estar dentro de mutate porque se va a crear una nueva variable.

supercias_filtrada_con_intervalos <-
  supercias_limpio %>%
  filter(capital_suscrito > q1 - 1.5 * IQR(capital_suscrito, na.rm = T),
         capital_suscrito < q3 + 1.5 * IQR(capital_suscrito, na.rm = T)) %>% 
  mutate(intervalo_capital_suscrito = cut(capital_suscrito, 10, labels = F))

# FALSE o TRUE se pueden tambien escribir como F o T

# Ver la nueva variable creada por cut a continuacion: 

supercias_filtrada_con_intervalos  %>% 
  select(capital_suscrito, intervalo_capital_suscrito) %>% 
  arrange(desc(capital_suscrito))

# Calcular las frecuencias de ocurrencia en cada uno de los intervalos:

supercias_tabla_frecuencias <-
  supercias_filtrada_con_intervalos %>% 
  group_by(intervalo_capital_suscrito) %>% 
  summarise(frecuencia = n())

# la tabla de arriba solo calcula frecuencia absoluta (numero de ocurrencias por cada intervalo)
# frecuencia relativa (la proporcion de observaciones sobre el total que sucede en cada intervalo)


supercias_tabla_frecuencias_abs_y_relativa <-
  supercias_filtrada_con_intervalos %>% 
  group_by(intervalo_capital_suscrito) %>% 
  summarise(frecuencia_abs = n()) %>%
  mutate(frecuencia_rel = frecuencia_abs/sum(frecuencia_abs),
         acum_freq_abs = cumsum(frecuencia_abs),
         acum_freq_rel = cumsum(frecuencia_rel))

# Graficar las frecuencias acumuladas mediante una ojiva

supercias_tabla_frecuencias_abs_y_relativa %>% 
  ggplot(aes(intervalo_capital_suscrito, acum_freq_abs, group = 1)) +
  geom_line() + 
  geom_point() +
  theme_minimal() +
  labs(x = "Intervalos de Capital Suscrito",
       y = "Frecuencia",
       title = "Ojiva de Capital Suscrito",
       subtitle = "Datos de SUPERCIAS 2024")

# Es necesario aplicar group = 1 en las esteticas cuando tengo una observacion por "grupo"
# Ggplot define a "grupos" como variables categoricas (texto)

# Graficos y analisis de datos categoricos --------------------------------

## Grafico de barras ----------------------------------------------------

# Con geom_bar: se calcula directamente la frecuencia de ocurrencia (no. de filas) por cada una de las categorias alimentadas

supercias_limpio %>% 
  ggplot(aes(provincia)) + 
  geom_bar() +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90))

# theme() siempre deberia estar al final
# Si es que aplico un tema visual predeterminado como theme_bw() despues de theme(), las opciones se resetean.

# Para reducir el numero de categorias, considerar solo el top 5, top 10 o el numero deseado

supercias_limpio %>%
  count(provincia) %>% 
  top_n(5, n) %>%
  arrange(n) %>% 
  ggplot(aes(fct_reorder(provincia,n), y = n)) + 
    geom_bar(stat = "identity", fill = "skyblue", color = "black") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90)) +
    labs(x = "Provincia",
         y = "Frecuencia por provincia",
         title = "Provincias con mas empresas en Ecuador",
         subtitle = "Datos SUPERCIAS 2024")

# Facetas -----------------------------------------------------------------

# Filtrar sin intervalos

supercias_filtrada <-
  supercias_limpio %>%
  filter(capital_suscrito > q1 - 1.5 * IQR(capital_suscrito, na.rm = T),
         capital_suscrito < q3 + 1.5 * IQR(capital_suscrito, na.rm = T))

# Histograma con facetas a partir de la region

supercias_filtrada %>%
  ggplot(aes(capital_suscrito, fill = region))+
  geom_histogram()+
  facet_wrap(~region, scales = "free_y") +
  theme_bw() + 
  labs(title = "Empresas por región",
       y = "Frecuencia",
       x = "Capital Suscrito (USD)",
       fill = "Región") + 
  theme(legend.title = element_text(size = 10),
        legend.position = "bottom",
        text = element_text(family = "serif", size = 15),
        panel.grid = element_blank())

ggsave("grafico_empresas_region.png")



