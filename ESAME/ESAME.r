#Impostazione della working directory

setwd("~/Desktop/Università/Telerilevamento") 
getwd()       # Verifica della working directory
list.files()  # Lista dei file all'interno della working directory

# Caricamento pacchetti
library(terra)     # Per la gestione di dati raster. 
library(imageRy)   # Gestione, analisi e visualizzazione multiframe di immagini raster
library(ggplot2)   # Creazione di grafici personalizzati
library(patchwork) # Per la combinazione flessibile dei grafici a barre in un'unica interfaccia;
library(viridis)   # Palette di colori ad alta leggibilità
library(ggridges)  # Grafici a cresta per visualizzare distribuzioni continue

# Funzione per tagliare raster usando un vettore

clipCoast <- function(img, boundary){
  img_crop <- crop(img, boundary)       # Ritaglia il raster all'estensione dello shapefile
  img_mask <- mask(img_crop, boundary)  # Mantiene i pixel interni al perimetro dello shapefile
  return(img_mask)
  }

# Importazione dati raster da Sentinel-2

pre2018 <- rast("Australia_2018_bands.tif") # rast() permette di importare SpatRaster
post2020 <- rast("Australia_2020_bands.tif")
post2026 <- rast("Australia_2026_bands.tif")

# Mostra layer separati

im.multiframe(3,4) # Suddivisione della finestra grafica in 3 righe e 4 colonne

plot(pre2018[[1]], col = rocket(100), main = "2018, B2") #Mostra valori della prima banda
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

#Visualizzazione a colori naturali

im.multiframe(1,3)

plotRGB(pre2018, r=3, g=2, b=1, stretch = "lin", main = "2018")  # pacchetto Terra
plotRGB(post2020, r=3, g=2, b=1, stretch = "lin", main = "2020") # Allarga i valori centrali per aumentare contrasto
plotRGB(post2026, r=3, g=2, b=1, stretch = "lin", main = "2026") # main = titolo

# NIR su Red

plotRGB(pre2018, r=4, g=2, b=1, stretch = "lin", main = "2018")   # Metto banda B8 sul rosso
plotRGB(post2020, r=4, g=2, b=1, stretch = "lin", main = "2020")  # Permette di mettere in evidenza la riflettanza della vegetazione
plotRGB(post2026, r=4, g=2, b=1, stretch = "lin", main = "2026")

# Eliminare il Mare dal raster

coast <- vect("AustraliaCosta.shp") # importa shapefile come SpatVector

pre2018 <- clipCoast(pre2018,coast)
post2020 <- clipCoast(post2020,coast)
post2026 <- clipCoast(post2026,coast)

#DVI Difference vegetation index

dvi_2018 <- im.dvi(pre2018, 4, 3)    # Funzione di imageRy
dvi_2020 <- im.dvi(post2020, 4, 3)   # Differenza di riflettanza tra banda NIR (4) e Rossa (3), mostra salute vegetazione
dvi_2026 <- im.dvi(post2026, 4, 3)

plot(dvi_2018, col = magma(100), main = "DVI 2018")
plot(dvi_2020, col = magma(100), main = "DVI 2020")
plot(dvi_2026, col = magma(100), main = "DVI 2026")

# NDVI Normalized difference vegetation index -> standardizzato per diverse risoluzioni radiometriche -> range -1 / +1

ndvi_2018 <- im.ndvi(pre2018, 4, 3) # DVI(somma banda NRI e visibile (rossa)
ndvi_2020 <- im.ndvi(post2020, 4, 3)
ndvi_2026 <- im.ndvi(post2026, 4, 3)

plot(ndvi_2018, col = inferno(100), main = "NDVI 2018")
plot(ndvi_2020, col = inferno(100), main = "NDVI 2020")
plot(ndvi_2026, col = inferno(100), main = "NDVI 2026")

# Analisi multitemporale della densità di distribuzione dell'NDVI mediante ridgeline plot

stack_ndvi <- c(ndvi_2018, ndvi_2020, ndvi_2026)
names(stack_ndvi) <- c("NDVI 2018", "NDVI 2020", "NDVI 2026")
im.ridgeline(stack_ndvi, scale = 1, palette = "plasma")

# Analisi temporale tramite differenze dell'NDVI

dev.off() #chiude finestra grafica

ndvi_diff1 <- ndvi_2020 - ndvi_2018  # Differenza tra prima dell'inizio e dopo la fine degli incendi
ndvi_diff2 <- ndvi_2026 - ndvi_2020  # Differenza tra dopo la fine e il periodo di recupero
ndvi_diff3 <- ndvi_2026 - ndvi_2018  # Differenza totale

im.multiframe(1,3)

plot(ndvi_diff1, col = rocket(100), main = "2018 - 2020")
plot(ndvi_diff2, col = rocket(100), main = "2020 - 2026")
plot(ndvi_diff3, col = rocket(100), main = "2018 - 2026")

# Classificazione non supervisionata delle tre immagini raster in 3 cluster

class_2018 <- im.classify(ndvi_2018, seed = 96, num_cluster = 3) # R sceglie automaticamente i tipi di gruppi
class_2020 <- im.classify(ndvi_2020, seed = 20, num_cluster = 3) # seed indica una delle iterazioni possibili
class_2026 <- im.classify(ndvi_2026, seed = 09, num_cluster = 3)

# Assegnazione delle etichette alle 3 classi

levels(class_2018) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo")) # levels assegna valore ad un determinato attributo
levels(class_2020) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))
levels(class_2026) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))

# Assegnazione colori personalizzati alle 3 classi

col_classes <- c("Mare" = "#ffffff","Vegetazione" = "#09622A", "Suolo nudo"="#E8C761") # Mare colorato di bianco in quanto non d'interesse per le analisi

# Visualizzazione delle classificazioni

plot(class_2018, col=col_classes, main="2018", legend=FALSE) # legend=FALSE non mostra la legenda
plot(class_2020, col=col_classes, main="2020", legend=FALSE)
plot(class_2026, col=col_classes, main="2026", legend=FALSE)

# Creazione Legenda

labels <- c("Vegetazione" = "#09622A", "Suolo nudo"="#E8C761") # Colori per due cluster -> escluso Mare

legend("bottomleft", 
       legend = names(labels), 
       fill = labels,  # Determina colori in base a palette definita
       bg = "white",
       xpd = TRUE)     # Può essere disegnata fuori dall'interfaccia grafica

# Calcolo delle frequenze

f_2018 <- freq(class_2018) # Frequenza valori nel raster
f_2020 <- freq(class_2020)
f_2026 <- freq(class_2026)

# Eliminiamo la classe del Mare

f_2018 <- f_2018[-1, ] #Elimina tutti elementi della prima riga
f_2020 <- f_2020[-1, ]
f_2026 <- f_2026[-1, ]

# Calcolo delle percentuali

perc_2018 <- (f_2018$count / sum(f_2018[,3])) * 100  # Proporzione: Prende conteggi e divide per somma pixel terza colonna (Vegetazione + Suolo nudo)
perc_2020 <- (f_2020$count / sum(f_2018[,3])) * 100  # Percentuale: Moltiplica prop per 100
perc_2026 <- (f_2026$count / sum(f_2018[,3])) * 100

# Creazione tabella riassuntiva

tabella <- data.frame( 
  class = c("Vegetazione", "Suolo nudo"),
  Pre_2018 = perc_2018 ,
  Post_2020 = perc_2020 ,
  Post_2026 = perc_2026 ,
)

# Visualizzazione tabella

tabella

#        class  Pre_2018 Post_2020 Post_2026
#1 Vegetazione 96.628875  63.62995 95.879389
#2  Suolo Nudo  3.371125  36.29394  4.075564

# Generazione di grafici a barre per il confronto

p1 <- ggplot(tabella, aes(x = class, y = perc_2018, fill = class)) +              # Creazione del grafico usando il dataset tabella
  geom_bar(stat = "identity") +                                                   # Definizione del tipo di grafico (grafico a barre)                       
  ylim(c(0, 100)) +                                                               # Limiti asse y
  scale_fill_manual(values = labels) +                                            # Impostazione manuale dei colori delle barre
  labs(title = "Copertura Pre incendio", x = "Classe", y = "Percentuale (%)") +   # Definizione etichette del grafico
  theme(legend.position = "none")                                                 # Elimina la legenda del grafico

p2 <- ggplot(tabella, aes(x = class, y = perc_2020, fill = class)) +              # Funzione di ggplot
  geom_bar(stat = "identity") +                                                                         
  ylim(c(0, 100)) +                                                              
  scale_fill_manual(values = labels) +                                           
  labs(title = "Copertura Post incendio (2020)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none")

p3 <- ggplot(tabella, aes(x = class, y = perc_2026, fill = class)) +              # aes definisce estetica: assi e colori che richiamano tabella
  geom_bar(stat = "identity") +                                                   # assi x mostra le classi, y i valori percentuali         
  ylim(c(0, 100)) +                                                              
  scale_fill_manual(values = labels) +                                           
  labs(title = "Copertura Post incendio (2026)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none") 

# Visualizzazione dei grafici 

p1 + p2 + p3 # Pacchetto patchwork permette di unire grafici

