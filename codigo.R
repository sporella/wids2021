library(sf)
library(stars)
library(ggplot2)


# Datos -------------------------------------------------------------------

rm <- read_sf("https://raw.githubusercontent.com/sporella/30daymap/master/data/comunas_metropolitana.geojson")

enero <- (read_stars("data/ene.tif")*0.02) - 273.15
junio <- (read_stars("data/jun.tif")*0.02) - 273.15
rm <- st_transform(rm, crs = 4326)

enero <- st_crop(enero, rm)
junio <- st_crop(junio, rm)

# Visualización -----------------------------------------------------------

## Capas base
ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm)

## Escalas
ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent")

## Coordenadas  

ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent")+
  coord_sf(crs = 4326)

## Tema
library(ggthemes)

ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent")+
  coord_sf(crs = 4326)+
  ggthemes::theme_fivethirtyeight()

ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent")+
  coord_sf(crs = 4326)+
  theme(panel.background = element_rect(fill = "transparent"),
        panel.grid = element_line(colour = "grey30", linetype = "dotted"))

## Etiquetas

p_enero <- ggplot()+
  geom_stars(data = enero)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent",
                       limits = c(-20.195, 46.41))+
  labs(x = "", y = "", fill = "[°C]", 
       title = "Temperatura Superficial Mes de Enero",
       subtitle = "promedio 2001-2020", tag = "A", caption = "MOD11A1")+
  coord_sf(crs = 4326)+
  theme(panel.background = element_rect(fill = "transparent"),
        panel.grid = element_line(colour = "grey30", linetype = "dotted"))

p_junio <- ggplot()+
  geom_stars(data = junio)+
  geom_sf(data = rm, fill = "transparent")+
  scale_fill_distiller(palette = "Spectral", na.value = "transparent",
                       limits = c(-20.195, 46.41))+
  labs(x = "", y = "", fill = "[°C]", 
       title = "Temperatura Superficial Mes de Junio",
       subtitle = "promedio 2001-2020", tag = "B", caption = "MOD11A1")+
  coord_sf(crs = 4326)+
  theme(panel.background = element_rect(fill = "transparent"),
        panel.grid = element_line(colour = "grey30", linetype = "dotted"))

library(patchwork)

p_final <- p_enero + p_junio

ggsave(filename = "figuras/grafico_enero_junio.png", height = 9.58, width = 4.49)
