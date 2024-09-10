# Uso de catalogo

# Preliminares ------------------------------------------------------------

library(dplyr)
library(readr)
library(readxl)

catalogo <- read_excel("data/Catalogo de Provincias.xlsx")

supercias_agrupado <- read_excel("data/SUPERCIAS empresas.xlsx")

ventas_sri <- read_csv("data/ventas_Enero.csv")

# Joins -------------------------------------------------------------------

supercias_agrupado_con_codigo <-
  supercias_agrupado %>% 
  left_join(catalogo %>% select(DPA_PROVIN, provincia_sin_tilde), by = c("provincia" = "provincia_sin_tilde")) %>%
  rename("codigo_provincia" = DPA_PROVIN)

ventas_sri_con_codigo <-
  ventas_sri %>%
  filter(ventas_Enero > 0) %>% 
  left_join(catalogo %>% select(DPA_PROVIN, provincia_sin_tilde), by = c("provincia" = "provincia_sin_tilde")) %>%
  rename("codigo_provincia" = DPA_PROVIN)

# juntar supercias con sri

consolidado_final <-
  supercias_agrupado_con_codigo %>% 
  left_join(ventas_sri_con_codigo %>% select(-provincia), by = "codigo_provincia") %>%
  relocate(codigo_provincia) %>% 
  mutate(indicador = ventas_Enero/numero_empresas)