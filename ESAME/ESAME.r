#Impostazione della working directory
setwd("~/Desktop/Università/Telerilevamento") 
getwd() #verifica della working directory
list.files() #lista dei file all'interno della working directory

### Caricamento pacchetti
library(terra)     # Per la gestione di dati raster. 
library(imageRy)   # Gestione, analisi e visualizzazione multiframe di immagini raster
library(ggplot2)   # Creazione di grafici personalizzati
library(patchwork) # Per la combinazione flessibile dei grafici a barre in un'unica interfaccia;
library(viridis)   # Palette di colori ad alta leggibilità
library(ggridges)  # Grafici a cresta per visualizzare distribuzioni continue

# Funzione per tagliare raster usando un vettore

clipCoast <- function(img, boundary){
  img_crop <- crop(img, boundary)
  img_mask <- mask(img_crop, boundary)
  return(img_mask)
  }

#Importa Raster

pre2018 <- rast("Australia_2018_bands.tif")
post2020 <- rast("Australia_2020_bands.tif")
post2026 <- rast("Australia_2026_bands.tif")
pre2018
post2020
post2026

#mostra layer separati
im.multiframe(3,4)

plot(pre2018[[1]], col = rocket(100), main = "2018, B2")
plot(pre2018[[2]], col = rocket(100), main = "2018, B3")
plot(pre2018[[3]], col = rocket(100), main = "2018, B4")
plot(pre2018[[4]], col = rocket(100), main = "2018, B8")

plot(post2020[[1]], col = rocket(100), main = "2020, B2")
plot(post2020[[2]], col = rocket(100), main = "2020, B3")
plot(post2020[[3]], col = rocket(100), main = "2020, B4")
plot(post2020[[4]], col = rocket(100), main = "2020, B8")

plot(post2026[[1]], col = rocket(100), main = "2026, B2")
plot(post2026[[2]], col = rocket(100), main = "2026, B3")
plot(post2026[[3]], col = rocket(100), main = "2026, B4")
plot(post2026[[4]], col = rocket(100), main = "2026, B8")

#visualizzazione a colori naturali
im.multiframe(1,3)

plotRGB(pre2018, r=3, g=2, b=1, stretch = "lin", main = "2018") #pacchetto Terra
plotRGB(post2020, r=3, g=2, b=1, stretch = "lin", main = "2020")
plotRGB(post2026, r=3, g=2, b=1, stretch = "lin", main = "2026")

# nir su red   
plotRGB(pre2018, r=4, g=2, b=1, stretch = "lin", main = "2018")
plotRGB(post2020, r=4, g=2, b=1, stretch = "lin", main = "2020")
plotRGB(post2026, r=4, g=2, b=1, stretch = "lin", main = "2026")

#Elimino mare da DVI
coast <- vect("AustraliaCosta.shp")

pre2018 <- clipCoast(pre2018,coast)
post2020 <- clipCoast(post2020,coast)
post2026 <- clipCoast(post2026,coast)

#DVI
dvi_2018 <- im.dvi(pre2018, 4, 3)
dvi_2020 <- im.dvi(post2020, 4, 3)
dvi_2026 <- im.dvi(post2026, 4, 3)

plot(dvi_2018, col = magma(100), main = "DVI 2018")
plot(dvi_2020, col = magma(100), main = "DVI 2020")
plot(dvi_2026, col = magma(100), main = "DVI 2026")

#NDVI
ndvi_2018 <- im.ndvi(pre2018, 4, 3)
ndvi_2020 <- im.ndvi(post2020, 4, 3)
ndvi_2026 <- im.ndvi(post2026, 4, 3)

plot(ndvi_2018, col = inferno(100), main = "NDVI 2018")
plot(ndvi_2020, col = inferno(100), main = "NDVI 2020")
plot(ndvi_2026, col = inferno(100), main = "NDVI 2026")

#Stack
stack_ndvi <- c(ndvi_2018, ndvi_2020, ndvi_2026) 
names(stack_ndvi) <- c("NDVI 2018", "NDVI 2020", "NDVI 2026")
im.ridgeline(stack_ndvi, scale = 1, palette = "plasma")

#NDVI diff
dev.off()

ndvi_diff1 <- ndvi_2020 - ndvi_2018
ndvi_diff2 <- ndvi_2026 - ndvi_2020
ndvi_diff3 <- ndvi_2026 - ndvi_2018

im.multiframe(1,3)

plot(ndvi_diff1, col = rocket(100), main = "2018 - 2020")
plot(ndvi_diff2, col = rocket(100), main = "2020 - 2026")
plot(ndvi_diff3, col = rocket(100), main = "2018 - 2026")

#CLASSI
class_2018 <- im.classify(ndvi_2018, seed = 96, num_cluster = 3)
class_2020 <- im.classify(ndvi_2020, seed = 20, num_cluster = 3)
class_2026 <- im.classify(ndvi_2026, seed = 09, num_cluster = 3)

levels(class_2018) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))
levels(class_2020) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))
levels(class_2026) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))

col_classes <- c("Mare" = "#ffffff","Vegetazione" = "#09622A", "Suolo nudo"="#E8C761")

#col_classes <- c("1" = "#ffffff","2" = "#09622A", "3"="#E8C761")

plot(class_2018, col=col_classes, main="2018", legend=FALSE)
plot(class_2020, col=col_classes, main="2020", legend=FALSE)
plot(class_2026, col=col_classes, main="2026", legend=FALSE)

labels <- c("Vegetazione" = "#09622A", "Suolo nudo"="#E8C761")

legend("bottomleft", 
       legend = names(labels), 
       fill = labels, 
       bg = "white",
       xpd = TRUE)

f_2018 <- freq(class_2018)
f_2020 <- freq(class_2020)
f_2026 <- freq(class_2026)

#Eliminiamo la classe del Mare

f_2018 <- f_2018[-1, ]
f_2020 <- f_2020[-1, ]
f_2026 <- f_2026[-1, ]

perc_2018 <- (f_2018$count / sum(f_2018[,3])) * 100
perc_2020 <- (f_2020$count / sum(f_2018[,3])) * 100
perc_2026 <- (f_2026$count / sum(f_2018[,3])) * 100


tabella <- data.frame( 
  class = c("Vegetazione", "Suolo nudo"),
  Pre_2018 = perc_2018 ,
  Post_2020 = perc_2020 ,
  Post_2026 = perc_2026 ,
)

tabella

#        class  Pre_2018 Post_2020 Post_2026
#1 Vegetazione 96.628875  63.62995 95.879389
#2  Suolo Nudo  3.371125  36.29394  4.075564

p1 <- ggplot(tabella, aes(x = class, y = perc_2018, fill = class)) +              #creazione del grafico usando il dataset tabella
  geom_bar(stat = "identity") +                                                  #definizione del tipo di grafico (grafico a barre)                       
  ylim(c(0, 100)) +                                                              #limiti asse y
  scale_fill_manual(values = labels) +                                           #impostazione manuale dei colori delle barre
  labs(title = "Copertura Pre incendio", x = "Classe", y = "Percentuale (%)") + #definizione etichette del grafico
  theme(legend.position = "none")                                                #elimina la legenda del grafico

p2 <- ggplot(tabella, aes(x = class, y = perc_2020, fill = class)) +              
  geom_bar(stat = "identity") +                                                                         
  ylim(c(0, 100)) +                                                              
  scale_fill_manual(values = labels) +                                           
  labs(title = "Copertura Post incendio (2020)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none") 


p3 <- ggplot(tabella, aes(x = class, y = perc_2026, fill = class)) +              
  geom_bar(stat = "identity") +                                                                         
  ylim(c(0, 100)) +                                                              
  scale_fill_manual(values = labels) +                                           
  labs(title = "Copertura Post incendio (2026)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none") 

#visualizzazione dei grafici 

p1 + p2 + p3

