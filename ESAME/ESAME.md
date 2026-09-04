> ### Telerilevamento Geo-Ecologico in R
>> Mirco Gruppi

# Analisi dell'impatto vegetazionale degli incendi in Australia del 2019-2020

Appello d'esame: 07/09/2026

## Introduzione

A partire da giugno 2019 fino a febbraio 2020 il sud-est dell'Australia è stata colpita da una serie di incendi boschivi. Il periodo è stato nominato l'"__Australian bushfire season__" o "__Black Summer__", data la lunga durata, la quantità di fuochi e un'area di impatto di oltre 24 milioni di ettari. 
Una delle aree più impattate è la costa attorno al paese di **Mallacoota**, situato al confine tra gli stati di Victoria e New South Wales nella Contea di East Gippsland. Qui numerose aree protette sono state interessate dai fuochi, tra cui dei parchi nazionali. É importante quindi studiare gli impatti di questa serie di incendi e capire come la vegetazione ha recuperato nel tempo.

<p align="center"> <img width="362" height="512" src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0b29b7d197b15eef397cb02e3ec5501c5f4ee7f/ESAME/Immagini/Bushfires.jpg" />

Tramite le immagini satellitari di Sentinel-2, lanciato per il progetto Copernicus, è possibile analizzare gli effetti degli incendi sulla vegetazione, confrontando tre diverse fasi:

* Estate 2018: Situazione pre-incendio (baseline)

* Estate 2020: Situazione post-incendio

* Estate 2026: Situazione di recupero attuale, sei anni dopo l'incendio

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/f50f78fbeb1e4dbde5b684880c1c86fde41ec925/ESAME/Immagini/Mallacoota.png" />

## Obiettivi

L'obiettivo è valutare gli impatti dell'incendio sulla vegetazione sia con un'analisi qualitativa (tramite composizoni RGB), sia quantitativamente utilizzando gli indici di vegetazione:
* DVI: Difference Vegetation Index 
* NDVI: Normalized Difference Vegetation Index

L'analisi multitemporale invece permette di valutare il recupero vegetazionale dopo sei anni.

## Metodologia

### Acquisizione dati
Le immagini sono state acquisite dal portale web di [Google Earth Engine](https://earthengine.google.com/), selezionando l'area colpita dall'incendio. Le immagini sono state selezionate nello stesso periodo stagionale (1/05 - 31/05) per minimizzare gli effetti fenologici. 

## Analisi tramite Software R

#### Impostazione della working directory

```r
setwd("~/Desktop/Università/Telerilevamento") 
getwd()       #verifica della working directory
list.files()  #lista dei file all'interno della working directory
```

#### Caricamento dei pacchetti che verranno utilizzati nello studio.

```r
library(terra)     # Per la gestione di dati raster. 
library(imageRy)   # Gestione, analisi e visualizzazione multiframe di immagini raster
library(ggplot2)   # Creazione di grafici personalizzati
library(patchwork) # Per la combinazione flessibile dei grafici a barre in un'unica interfaccia;
library(viridis)   # Palette di colori ad alta leggibilità
library(ggridges)  # Grafici a cresta per visualizzare distribuzioni continue
```

#### Scrittura di una funzione da richiamare successivamente

```r
clipCoast <- function(img, boundary){
  img_crop <- crop(img, boundary)       # Ritaglia il raster all'estensione dello shapefile
  img_mask <- mask(img_crop, boundary)  # Mantiene i pixel interni al perimetro dello shapefile
  return(img_mask)
  }
```

### Importazione dati raster da Sentinel-2

```r
pre2018 <- rast("Australia_2018_bands.tif") # rast() permette di importare SpatRaster
post2020 <- rast("Australia_2020_bands.tif")
post2026 <- rast("Australia_2026_bands.tif")
```

## Visualizzazione

### Visualizzazione delle singole bande del visibile (B2, B3, B4) e del vicino infrarosso (B8)

```r
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
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/4e48e881e38bd8aade164a83667b9d9253733057/ESAME/Immagini/Bande.png" />

La visualizzazione separata delle bande del visibile (blu, verde e rosso) e della banda del vicino infrarosso (NIR) consente di comparare la risposta spettrale delle diverse superfici nelle tre fasi analizzate. Osservando la banda del NIR, sensibile alla presenza e allo stato di salute della vegetazione, si nota una diminuzione della riflettanza in seguito agli incendi, e un recupero sei anni dopo.

### Composizione RGB a colori naturali

Usando la funzione plotRGB del pacchetto Terra possiamo sovrapporre le bande del visibile producendo immagini a colori naturali. 

```r
im.multiframe(1,3)

plotRGB(pre2018, r=3, g=2, b=1, stretch = "lin", main = "2018")  # pacchetto Terra
plotRGB(post2020, r=3, g=2, b=1, stretch = "lin", main = "2020") # Stretch allarga i valori centrali per aumentare contrasto
plotRGB(post2026, r=3, g=2, b=1, stretch = "lin", main = "2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/4e48e881e38bd8aade164a83667b9d9253733057/ESAME/Immagini/ColoriNaturali.png" />

La composizione RGB a colori naturali permette di effettuare un primo confronto qualitativo tra le condizioni dell'area di studio pre e post incendio, evidenziando le variazioni della copertura vegetale e le aree percorse dal fuoco, che appaiono con tonalità più scure. A sei anni dall'evento, si osserva un ripristino quasi completo della vegetazione.

### Composizione RGB a falsi colori

Sostituendo il NIR al posto della banda del rosso, si evidenziano le zone di vegetazione. Queste immagini permettono di osservare lo stato di salute della vegetazione, poichè una maggiore riflessione del NIR indica una vegetazione sana che apparità con un rosso più intenso, rispetto invece a una vegetazione danneggiata e sottoposta a stress.

```r
lotRGB(pre2018, r=4, g=2, b=1, stretch = "lin", main = "2018")   # Metto banda B8 sul rosso
plotRGB(post2020, r=4, g=2, b=1, stretch = "lin", main = "2020")  # Permette di mettere in evidenza la riflettanza della vegetazione
plotRGB(post2026, r=4, g=2, b=1, stretch = "lin", main = "2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/4e48e881e38bd8aade164a83667b9d9253733057/ESAME/Immagini/NIRsuRed.png" />

Le immagini prodotte permettono di vedere con maggiore chiarezza le aree colpite dagli incendi, poi ripristinate nell'ultima fase. Si può anche osservare come nel 2018 alcune aree appaiano già danneggiate, a causa di incendi avvenuti negli anni precedenti. Nel 2026 si può apprezzare il reucpero vegetazionale pure di queste zone.
