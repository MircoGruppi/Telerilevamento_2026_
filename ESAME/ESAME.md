> ### Telerilevamento Geo-Ecologico in R
>> Mirco Gruppi

# Analisi dell'impatto vegetazionale degli incendi in Australia del 2019-2020

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

#### Importazione dati raster da Sentinel-2

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

Usando la funzione `plotRGB` del pacchetto `Terra` possiamo sovrapporre le bande del visibile producendo immagini a colori naturali. 

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
plotRGB(post2020, r=4, g=2, b=1, stretch = "lin", main = "2020")
plotRGB(post2026, r=4, g=2, b=1, stretch = "lin", main = "2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/4e48e881e38bd8aade164a83667b9d9253733057/ESAME/Immagini/NIRsuRed.png" />

Le immagini prodotte permettono di vedere con maggiore chiarezza le aree colpite dagli incendi, poi ripristinate nell'ultima fase. Si può anche osservare come nel 2018 alcune aree appaiano già danneggiate, a causa di incendi avvenuti negli anni precedenti. Nel 2026 si può apprezzare il reucpero vegetazionale pure di queste zone.

## Analisi degli indici spettrali

### Analisi DVI

Il **Difference Vegetation Index (DVI)** è un indice di vegetazione ottenuto come differenza tra la riflettanza della banda del vicino infrarosso (NIR) e quella della banda del rosso (Red):

$DVI = NIR - Red$

Le piante, grazie ai pigmenti fotosintetici, assorbono nel visibile gran parte della radiazione nel rosso, mentre riflette il vicino infrarosso a causa di particolarità nella struttura fogliare. Di conseguenza l'indice DVI è usato per valutare la presenza di vegetazione: valori elevati di DVI indicano una vegetazione vigorosa e con elevata attività fotosintetica. È un indice non normalizzato, ma fornisce informazioni comparative, per evidenziare la perdita di vegetazione causata dal fuoco.

Dato che l'analisi è incentrata sui danni causati dagli incendi sulla vegetazione terrestre, le informazioni della superficie del mare non sono d'interesse, e possono essere rimosse usando la funzione scritta in precedenza. Importando uno shapefile come SpatVector è possibile ritagliare il file raster, rimuovendo così i pixel della superficie marina.

```r
coast <- vect("AustraliaCosta.shp") # importa shapefile come SpatVector

pre2018 <- clipCoast(pre2018,coast)
post2020 <- clipCoast(post2020,coast)
post2026 <- clipCoast(post2026,coast)
```

Procedo a calcolare il DVI usando la funzione `im.dvi` di `imageRy`

```r
dvi_2018 <- im.dvi(pre2018, 4, 3)    # Funzione di imageRy
dvi_2020 <- im.dvi(post2020, 4, 3)   # Differenza di riflettanza tra banda NIR (4) e Rossa (3)
dvi_2026 <- im.dvi(post2026, 4, 3)

plot(dvi_2018, col = magma(100), main = "DVI 2018")
plot(dvi_2020, col = magma(100), main = "DVI 2020")
plot(dvi_2026, col = magma(100), main = "DVI 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/5d7338ddbba7699bbce1c6d163c1b279e528e547/ESAME/Immagini/DVI.png" />

Le aree interessate dall'incendio corrispondono ai valori più bassi di DVI, mostrando una forte diminuizione della biomassa vegetale fotosintetica. Dopo sei anni si può notare invece il recupero della copertura forestale.

Le aree lagunari, essendo all'interno delle linee di costa, non sono state tagliate dalla funzione `clipCoast` e vengono mostrate tramite valori vicini allo 0. Ciò avviene perchè l'acqua ha una forte assorbanza nel NIR.

### Analisi NDVI

Il Normalized Difference Vegetation Index (NDVI) è uno degli indici di vegetazione più utilizzati nell'ambito del telerilevamento per valutare lo stato e il vigore della copertura vegetale. Come per il DVI, si basa sulle caratteristiche spettrali della vegetazione, che assorbe la radiazione nella banda del rosso e riflette invece le radiazioni nel vicino infrarosso. A differenza del DVI, però, l'NDVI è un indice normalizzato che assume valori compresi tra -1 e +1.

**$NDVI = \frac{NIR - Red}{NIR + Red}$**

* Valori prossimi a +1 indicano una vegetazione densa, sana e caratterizzata da elevata attività fotosintetica
* Valori intorno allo 0 sono associati a vegetazione rada, danneggiata o a suoli privi di vegetazione
* Valori prossimi a -1 indicano superfici come i corpi idrici

```r
ndvi_2018 <- im.ndvi(pre2018, 4, 3) # DVI(somma banda NRI e visibile (rossa)
ndvi_2020 <- im.ndvi(post2020, 4, 3)
ndvi_2026 <- im.ndvi(post2026, 4, 3)

plot(ndvi_2018, col = inferno(100), main = "NDVI 2018")
plot(ndvi_2020, col = inferno(100), main = "NDVI 2020")
plot(ndvi_2026, col = inferno(100), main = "NDVI 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/5d7338ddbba7699bbce1c6d163c1b279e528e547/ESAME/Immagini/NDVI.png" />

Il confronto degli indici pre e post incendio mostra come nelle aree colpite dagli incendi i valori sono prossimi allo 0, per poi tornare a valori alti vicini a +1 dopo sei anni di recupero vegetazionale. Le aree che hanno mantenuto valori bassi invece sono gli insediamenti urbani, campi e zone deforestate dall'uomo. Le lagune hanno invece valori negativi prossimi al -1.

## Analisi multitemporale della della densità di distribuzione dell'NDVI mediante ridgeline plot

Il ridgeline plot (grafico a cresta) permette di analizzare e confrontare la distribuzione dei valori dell'indice NDVI nelle diverse date di acquisizione delle immagini satellitari, evidenziando le variazioni della risposta della vegetazione nei tre periodi in esame.

```r
stack_ndvi <- c(ndvi_2018, ndvi_2020, ndvi_2026)
names(stack_ndvi) <- c("NDVI 2018", "NDVI 2020", "NDVI 2026")
im.ridgeline(stack_ndvi, scale = 1, palette = "plasma")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/9d08dadb3b9f9f35c361b26a0e6b758ee0544fb3/ESAME/Immagini/Ridgelines.png" />

I grafici a cresta mostrano come dopo gli incendi del 2019-2020 la densità di dsitribuzione dell'NDVI si è appiattita e allargata, in quanto sono scomparsi i picchi di valori alti a causa della perdita di copertura forestale, che ha lasciato posto al suolo esposto caratterizzato da valori prossimi allo 0. I picchi negativi separati appartengono invece alle aree lagunari.

### Calcolo della differenza multitemporale dell'NDVI

Calcolando la differenza dei valori di NDVI nei tempi diversi, è possibile mappare come la salute della vegetazione cambia nel tempo.

```r
dev.off() #chiude finestra grafica

ndvi_diff1 <- ndvi_2020 - ndvi_2018  # Differenza tra prima dell'inizio e dopo la fine degli incendi
ndvi_diff2 <- ndvi_2026 - ndvi_2020  # Differenza tra dopo la fine e il periodo di recupero
ndvi_diff3 <- ndvi_2026 - ndvi_2018  # Differenza totale

im.multiframe(1,3)

plot(ndvi_diff1, col = rocket(100), main = "2018 - 2020")
plot(ndvi_diff2, col = rocket(100), main = "2020 - 2026")
plot(ndvi_diff3, col = rocket(100), main = "2018 - 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/9d08dadb3b9f9f35c361b26a0e6b758ee0544fb3/ESAME/Immagini/NDVIdiff.png" />

Nella prima immagine si può vedere facilmente la perdita di vegetazione causata dagli incendi, evidenziata dalle aree di colore scuro. Nel periodo successivo invece questa perdita è stata invertita, e le stesse aree hanno un colore chiaro, indicando il ripristino vegetazionale. L'ultima immagine mostra invece il cambiamento complessivo dal 2018 al periodo attuale. Si può vedere come il recupero della copertura forestale è stato quasi completo, con pure del miglioramento nelle aree colpite prima del 2018. Tuttavia, a nord-ovest si possono notare numerose aree quasi puntiformi in cui è avvenuta invece una perdita di vegetazione.

## Classificazione

### Classificazione non supervisionata

La classificazione non supervisionata permette di raggruppare i pixel delle immagini NDVI in classi omogenee, stabilendo la frequenza dei pixel della copertura vegetale e delle aree impattate dai fuochi. 

```r
class_2018 <- im.classify(ndvi_2018, seed = 96, num_cluster = 3) # seed indica una delle iterazioni possibili
class_2020 <- im.classify(ndvi_2020, seed = 20, num_cluster = 3) 
class_2026 <- im.classify(ndvi_2026, seed = 09, num_cluster = 3)
```

<p align="center"> <img width="768" height="418"  src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/8016ec049bb2b96c607a1678120ad4eacaeedf01/ESAME/Immagini/Cluster.png" />

Indicando tre cluster, vengono individuate come classi la vegetazione, le aree a suolo nudo e le lagune. Quest'ultima classe non è veramente d'interesse per questo studio, e per questo possiamo rimuoverla dalla visualizzazione, colorandola di bianco in modo da mimetizzarla con il mare, che è stato tagliato dal raster usando la funzione `clipCoast`, e creando una legenda che mostra solo le altre due classi.

```r
# Assegnazione delle etichette alle 3 classi

levels(class_2018) <- data.frame(value = c(1, 2, 3), label = c("Laguna", "Vegetazione", "Suolo nudo"))
levels(class_2020) <- data.frame(value = c(1, 2, 3), label = c("Laguna", "Vegetazione", "Suolo nudo"))
levels(class_2026) <- data.frame(value = c(1, 2, 3), label = c("Laguna", "Vegetazione", "Suolo nudo"))

# Assegnazione colori personalizzati alle 3 classi

col_classes <- c("Laguna" = "#ffffff","Vegetazione" = "#09622A", "Suolo nudo"="#E8C761")

# Visualizzazione delle classificazioni

plot(class_2018, col=col_classes, main="2018", legend=FALSE) # legend=FALSE non mostra la legenda
plot(class_2020, col=col_classes, main="2020", legend=FALSE)
plot(class_2026, col=col_classes, main="2026", legend=FALSE)

# Creazione Legenda

labels <- c("Vegetazione" = "#09622A", "Suolo nudo"="#E8C761") # Colori per due cluster -> escluso Laguna

legend("bottomleft", 
       legend = names(labels), 
       fill = labels,  # Determina colori in base a palette definita
       bg = "white",
       xpd = TRUE)     # Può essere disegnata fuori dall'interfaccia grafica
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/8016ec049bb2b96c607a1678120ad4eacaeedf01/ESAME/Immagini/Classification.png" />

Dal confronto visivo delle mappe si rileva un'espansione delle aree classificate come "Suolo nudo" a scapito della classe "Vegetazione" dopo l'impatto degli incendi, seguito da un recupero dopo il passaggio dei sei anni. Al fine di validare quantitativamente le variazioni spaziali osservate, vengono calcolate le frequenze dei pixel per ciascuna classe.

```r
f_2018 <- freq(class_2018) # Frequenza valori nel raster
f_2020 <- freq(class_2020)
f_2026 <- freq(class_2026)
```

Possiamo eliminare dal conteggio i pixel della classe "Laguna", in quanto non d'interesse per lo studio.

```r
f_2018 <- f_2018[-1, ] #Elimina tutti elementi della prima riga
f_2020 <- f_2020[-1, ]
f_2026 <- f_2026[-1, ]
```

Procediamo con il calcolo delle percentuali delle classi rimanenti

```r
perc_2018 <- (f_2018$count / sum(f_2018[,3])) * 100
perc_2020 <- (f_2020$count / sum(f_2018[,3])) * 100
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
```

| Classi | Pre 2018 | Post 2020 | Post 2026 |
| :--- | :---: | :---: | :---: | 
| Vegetazione | 96.63%  | 63.63% | 95.88% |
| Suolo Nudo  | 3.37%  | 36.29% | 4.076% |

Dai dati si può vedere che in seguito agli incendi del 2019-2020 la vegetazione, da una condizione originaria di elevata copertura, ha subito un calo del 30%. Nel 2026 è riuscita a recuperare il danno ritornando ad un valore di 95%, non raggiungendo di poco il valore di partenza.

### Generazione di grafici a barre per il confronto delle percentuali

```r
p1 <- ggplot(tabella, aes(x = class, y = perc_2018, fill = class)) +              # Creazione del grafico usando il dataset tabella
  geom_bar(stat = "identity") +                                                   # Definizione del tipo di grafico
  ylim(c(0, 100)) +                                                               # Limiti asse y
  scale_fill_manual(values = labels) +                                            # Impostazione manuale dei colori delle barre
  labs(title = "Copertura Pre incendio", x = "Classe", y = "Percentuale (%)") +   # Definizione etichette del grafico
  theme(legend.position = "none")                                                 # Elimina la legenda del grafico

p2 <- ggplot(tabella, aes(x = class, y = perc_2020, fill = class)) +
  geom_bar(stat = "identity") +                                                                         
  ylim(c(0, 100)) +                                                              
  scale_fill_manual(values = labels) +                                           
  labs(title = "Copertura Post incendio (2020)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none")

p3 <- ggplot(tabella, aes(x = class, y = perc_2026, fill = class)) +              # aes definisce estetica di assi e colori
  geom_bar(stat = "identity") +
  ylim(c(0, 100)) +
  scale_fill_manual(values = labels) +
  labs(title = "Copertura Post incendio (2026)", x = "Classe", y = "Percentuale (%)") + 
  theme(legend.position = "none") 

# Visualizzazione dei grafici 

p1 + p2 + p3 # Pacchetto patchwork permette di unire grafici
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/f1c4c64dcb60ff87f2e74c83fa2e0ad79b2b5325/ESAME/Immagini/GrafBarre.png" />

## Conclusioni

L'analisi condotta tramite telerilevamento satellitare multitemporale ha permesso di quantificare e confrontare il danno ambientale causato dagli incendi nell'area di studio e il processo di recupero negli anni successivi. Il confronto multitemporale degli indici di NDVI e DVI hanno mostrato una perdita di vegetazione del 30% a causa degli incendi del 2019-2020, socceduto da un quasi totale ripristino nel 2026. L'anaisi qualitativa delle immagini suggerisce però che il recupero incompleto non è dovuto da una mancata rigenerazione della copertura vegetale in seguito all'incendio, ma da separati eventi. Infatti nella maggiorparte delle aree colpite si osserva il pieno ritorno della foresta, comprese quelle danneggiate da incendi precedenti alla _Black Summer_. La vegetazione dovrebbe quindi aver raggiunto uno stato di salute perfino maggiore della condizione iniziale, ma questo recupero è stato controbilanciato da un'aggiuntiva scomparsa di copertura forestale. A differenza dei danni da incendio, queste aree non sono estese ma appaiono come sparsi punti in tutta la zona a nord-est, all'incirca in corrispondenza con la foresta statale di Yambulla.

Una vista più ravvicinata dell'area mostra che la causa di tutto ciò è la deforestazione per mano dell'uomo, tramite il taglio degli alberi per l'industria del legname. La _Forestry Corporation of NSW_ è stata infatti denunciata numerose volte per il sovrasfruttamento delle risorse forestali, non curandosi dei danni causati dalla _Black Summer_, causando un'ulteriore perdita di habitat per specie minacciate dopo agli incendi.

In conclusione, dopo sei anni dalla fine degli incendi la vegetazione avrebbe potuto recuperare completamente la copertura persa tra il 2019 e il 2020, se non fosse stato per una successiva deforestazione causata dall'attività umana.

<p align="center"> <img width="337" height="262" 
 src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/01fdae50635dd5c0747eaa60d9489da74df69b19/ESAME/Immagini/Deforestazione.png" />

## Sitografia

[Bushfires in the ACT - ACT State of the Environment](https://www.actsoe2023.com.au/issues/bushfires-in-the-act/)

[Forestry Corp pinged for logging environmentally significant forests after the Black Summer bushfires](https://www.nature.org.au/forestry_corp_pinged_for_logging_environmentally_significant_forests_after_the_black_summer_bushfires)
