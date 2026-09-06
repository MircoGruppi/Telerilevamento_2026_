> ### Telerilevamento Geo-Ecologico in R
>> Mirco Gruppi

# Analisi dell'impatto degli incendi in Australia nel 2019-2020

<p align="center"> <img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/Mallacoota.png" />

## Introduzione

A partire da giugno 2019 fino a febbraio 2020 l'Australia sud-orientale è stata colpita da una serie di incendi boschivi. Il periodo è stato nominato l'"___Australian bushfire season___" o "___Black Summer___", data la lunga durata, la quantità di fuochi e l'area di impatto di oltre 24 milioni di ettari. 
Una delle aree più impattate è stata la costa attorno al paese di *Mallacoota*, situato al confine tra gli stati di *Victoria* e *New South Wales* nella Contea di *East Gippsland*. Qui numerose aree protette sono state interessate dai fuochi, tra cui vari parchi nazionali. É importante quindi studiare gli impatti di questa serie di incendi e capire come la vegetazione ha recuperato nel tempo.

<p align="center"> <img width="362" height="512" src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0b29b7d197b15eef397cb02e3ec5501c5f4ee7f/ESAME/Immagini/Bushfires.jpg" />

Tramite le immagini satellitari di Sentinel-2, lanciato per il progetto Copernicus, è possibile analizzare gli effetti degli incendi sulla vegetazione, confrontando tre diverse fasi:

* Estate 2018: Situazione pre-incendio (baseline)

* Estate 2020: Situazione post-incendio

* Estate 2026: Situazione di recupero attuale, sei anni dopo l'incendio

<p align="center"> <img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/Map.png" />

## Obiettivi

L'obiettivo è valutare gli impatti dell'incendio sulla vegetazione sia con un'analisi qualitativa (tramite composizoni RGB), sia quantitativamente utilizzando i seguenti indici:
* NBR: Normalized Burn Ratio
* NDVI: Normalized Difference Vegetation Index

L'analisi multitemporale invece permette di valutare il recupero vegetazionale dopo sei anni.

## Metodologia

### Acquisizione dati
Le immagini sono state acquisite dal portale web di [Google Earth Engine](https://earthengine.google.com/), selezionando l'area colpita dall'incendio. Le immagini sono state selezionate nello stesso periodo stagionale estivo (1/05 - 31/05) per minimizzare gli effetti fenologici. 

## Analisi tramite Software R

Impostazione della working directory

```r
setwd("~/Desktop/Università/Telerilevamento") 
getwd()       #verifica della working directory
list.files()  #lista dei file all'interno della working directory
```

Caricamento dei pacchetti che verranno utilizzati nello studio.

```r
library(terra)     # Per la gestione di dati raster
library(imageRy)   # Gestione, analisi e visualizzazione multiframe di immagini raster
library(ggplot2)   # Creazione di grafici personalizzati
library(patchwork) # Per la combinazione flessibile dei grafici a barre in un'unica interfaccia
library(viridis)   # Palette di colori ad alta leggibilità
library(ggridges)  # Grafici a cresta per visualizzare distribuzioni continue
```

Importazione dati raster da Sentinel-2

```r
pre2018 <- rast("Australia_2018_bands.tif")
post2020 <- rast("Australia_2020_bands.tif")
post2026 <- rast("Australia_2026_bands.tif")
```

## Visualizzazione

### Visualizzazione delle singole bande del visibile (B2, B3, B4), e dell'infrarosso (B8, B12)

```r
im.multiframe(3,5) # Suddivisione della finestra grafica in 3 righe e 5 colonne

plot(pre2018[[1]], col = rocket(100), main = "2018, B2") #Mostra valori della prima banda
plot(pre2018[[2]], col = rocket(100), main = "2018, B3")
plot(pre2018[[3]], col = rocket(100), main = "2018, B4")
plot(pre2018[[4]], col = rocket(100), main = "2018, B8")
plot(pre2018[[5]], col = rocket(100), main = "2018, B12")

plot(post2020[[1]], col = rocket(100), main = "2020, B2")
plot(post2020[[2]], col = rocket(100), main = "2020, B3")
plot(post2020[[3]], col = rocket(100), main = "2020, B4")
plot(post2020[[4]], col = rocket(100), main = "2020, B8")
plot(post2020[[5]], col = rocket(100), main = "2020, B12")

plot(post2026[[1]], col = rocket(100), main = "2026, B2")
plot(post2026[[2]], col = rocket(100), main = "2026, B3")
plot(post2026[[3]], col = rocket(100), main = "2026, B4")
plot(post2026[[4]], col = rocket(100), main = "2026, B8")
plot(post2026[[5]], col = rocket(100), main = "2026, B12")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/Bande.png" />

La visualizzazione separata delle bande del visibile (blu, verde e rosso) e dell'infrarosso (NIR e SWIR) consente di comparare la risposta spettrale delle diverse superfici nelle tre fasi analizzate. Osservando la banda del NIR, sensibile alla presenza e allo stato di salute della vegetazione, si nota una diminuzione della riflettanza in seguito agli incendi, e un recupero sei anni dopo. La banda del SWIR invece mette in evidenza le stesse aree colpite dalle fiamme.

### Composizione RGB a colori naturali

Usando la funzione `plotRGB` del pacchetto `terra` possiamo sovrapporre le bande del visibile producendo immagini a colori naturali. 

```r
im.multiframe(1,3)

plotRGB(pre2018, r=3, g=2, b=1, stretch = "lin", main = "2018")  # pacchetto Terra
plotRGB(post2020, r=3, g=2, b=1, stretch = "lin", main = "2020") # Stretch allarga i valori centrali per aumentare contrasto
plotRGB(post2026, r=3, g=2, b=1, stretch = "lin", main = "2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/ColoriNaturali.png" />

La composizione RGB a colori naturali permette di effettuare un primo confronto qualitativo tra le condizioni dell'area di studio pre e post incendio, evidenziando le variazioni della copertura vegetale e le aree percorse dal fuoco, che appaiono con tonalità più scure. A sei anni dall'evento, si osserva un ripristino quasi completo della vegetazione.

### Composizione RGB a falsi colori

Sostituendo il NIR al posto della banda del rosso, si evidenziano le zone con vegetazione. Queste immagini permettono di osservare lo stato di salute della vegetazione, poichè una maggiore riflessione del NIR indica una vegetazione sana che apparità con un rosso più intenso, rispetto invece a una vegetazione danneggiata e sottoposta a stress.

```r
plotRGB(pre2018, r=4, g=2, b=1, stretch = "lin", main = "2018")   # Metto banda B8 sul rosso
plotRGB(post2020, r=4, g=2, b=1, stretch = "lin", main = "2020")
plotRGB(post2026, r=4, g=2, b=1, stretch = "lin", main = "2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/FalseColors.png" />

Le immagini prodotte permettono di vedere con maggiore chiarezza le aree colpite dagli incendi, poi ripristinate nell'ultima fase. Si può anche osservare come nel 2018 alcune aree appaiano già danneggiate, a causa di incendi avvenuti negli anni precedenti. Nel 2026 si può apprezzare il recupero vegetazionale pure in queste zone.

## Analisi degli indici spettrali

## Analisi NBR

Il ***Normalized Burn Ratio (NBR)*** è un indice progettato per evidenziare aree bruciate da vasti incendi. Viene calcolato sfruttando la banda NIR (B8), indice di vegetazione in salute, e la banda **SWIR (B12)**, sensibile all'umidità e alle superfici bruciate.

L'indice è normalizzato tramite la proporzione con la somma delle due bande:

+ Valori prossimi al +1 indicano buona attività fotosintetica.
+ valori prossimi al -1 invece mostrano il suolo nudo e aree recentemente bruciate.
+ Le superfici che invece non hanno subito danni da incendi hanno valori vicino allo 0.

$$NBR = \frac{NIR - SWIR}{NIR + SWIR}$$

Dato che l'analisi è incentrata sui danni causati dagli incendi sulla vegetazione terrestre, le informazioni della superficie del mare non sono d'interesse, e possono essere rimosse usando la funzione scritta in precedenza. Importando uno shapefile come SpatVector è possibile ritagliare il file raster, rimuovendo così i pixel della superficie marina.


```r
coast <- vect("AustraliaCosta.shp") # importa shapefile come SpatVector

pre2018 <- crop(pre2018, coast, mask = TRUE) # crop taglia il file SpatRaster usando il vettore
post2020 <- crop(post2020, coast, mask = TRUE) # mask = TRUE elimina pixel al di fuori del shapefile
post2026 <- crop(post2026, coast, mask = TRUE)
```

Procedo a calcolare l'indice NBR

```r
nbr_2018 = (pre2018[["B8"]] - pre2018[["B12"]]) / (pre2018[["B8"]] + pre2018[["B12"]])       # Calcolo NBR pre-incendio
nbr_2020 = (post2020[["B8"]] - post2020[["B12"]]) / (post2020[["B8"]] + post2020[["B12"]])   # Calcolo NBR post-incendio
nbr_2026 = (post2026[["B8"]] - post2026[["B12"]]) / (post2026[["B8"]] + post2026[["B12"]])

# Visualizzazione NBR

plot(nbr_2018, col = magma (100), main = "NBR 2018")
plot(nbr_2020, col = magma (100), main = "NBR 2020")
plot(nbr_2026, col = magma (100), main = "NBR 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/NBR.png" />

Nel 2020 si può vedere l'ampia estensione degli incendi, i cui danni sono rappresentati dai colori più scuri. Dopo sei anni si può notare che il suolo ha recuperato buona parte dell'impatto. Nel 2018 si notano bene le aree a sud-ovest già colpite da incendi, e il loro recupero negli anni successivi.

### Burn Severity

La gravità dell'impatto degli incendi può essere calcolato tramite il delta NBR 

$$∆NBR = PreNBR - PostNBR$$

Il valore risultante ci dice il livello di gravità:

| Livello di gravità | Range ∆NBR |
| :--- | :---: |
| Ricrescita elevata | -0.500 — -0251  |
| Ricrescita bassa  | -0.250 — -0.101  |
| Non bruciato | -0.100 — +0.099  |
| Grav. bassa — moderata | +0.270 — +0.439  |
| Grav. moderata — alta  | +0.440 — +0.659  |
| Gravità alta  | +0.660 — +1.300  |

```r
nbr_diff1 <- nbr_2018 - nbr_2020  # Differenza tra prima dell'inizio e dopo la fine degli incendi
nbr_diff2 <- nbr_2020 - nbr_2026  # Differenza tra dopo la fine e il periodo di recupero
nbr_diff3 <- nbr_2018 - nbr_2026  # Differenza totale

plot(nbr_diff1, col = rocket(100), main = "2018 - 2020")
plot(nbr_diff2, col = rocket(100), main = "2020 - 2026")
plot(nbr_diff3, col = rocket(100), main = "2018 - 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/4ccf13c7b9819685ecb0d341df93e129b73a588e/ESAME/Immagini/BurnSeverity.png" />

Nella prima mappa si può vedere come le zone colpite dagli incendi hanno valori vicino al +1, un livello di gravità molto alto. Interessante notare però come l'impatto degli incendi precedenti al 2018 era già stato recuperato nel 2020. Nell'immagine successiva la situazione si è invertita, e i valori negativi mostrano che nei sei anni successivi alla _Black Summer_ c'è stata una ricrescita quasi totale della vegetazione. Nella terza immagine si vede infatti che la maggiorparte dei danni dell'incendio dopo sei anni sono stati ripristinati.

## Analisi NDVI

Il ***Normalized Difference Vegetation Index (NDVI)*** è uno degli indici di vegetazione più utilizzati nell'ambito del telerilevamento per valutare lo stato e il vigore della copertura vegetale. Si basa sulle caratteristiche spettrali della vegetazione, che grazie ai pigmenti fotosintetici assorbe la radiazione nel visibile, in particolare gran parte della radiazione nel rosso, e riflette invece le radiazioni nel vicino infrarosso a causa dell'interazione con l'endodermide fogliare. Di conseguenza l'indice NDVI è usato per valutare la presenza di vegetazione: valori elevati di NDVI indicano una vegetazione vigorosa e con elevata attività fotosintetica. 

$$NDVI = \frac{NIR - Red}{NIR + Red} = \frac{DVI}{NIR + Red}$$

È un indice normalizzato, ricavato dal ***Difference Vegetation Index (DVI)***, e assume valori compresi tra -1 e +1:

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

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/d0bfcc5fb8647919e5e82713c136b6517135c446/ESAME/Immagini/NDVI.png" />

Il confronto degli indici pre e post incendio mostra come nelle aree colpite dagli incendi i valori sono prossimi allo 0, per poi tornare a valori alti vicini a +1 dopo sei anni di recupero vegetazionale. Le aree che hanno mantenuto valori bassi invece sono gli insediamenti urbani, campi e zone deforestate dall'uomo. 

Le aree lagunari, essendo all'interno delle linee di costa, non sono state tagliate dalla funzione `crop` e vengono mostrate tramite valori vicini al -1. Ciò avviene perchè l'acqua ha una forte assorbanza nel NIR.

### Analisi multitemporale della della densità di distribuzione dell'NDVI mediante ridgeline plot

Il ridgeline plot (grafico a cresta) permette di analizzare e confrontare la distribuzione dei valori dell'indice NDVI nelle diverse date di acquisizione delle immagini satellitari, evidenziando le variazioni della risposta della vegetazione nei tre periodi in esame.

```r
stack_ndvi <- c(ndvi_2018, ndvi_2020, ndvi_2026)              # crea vettore di oggetti concatenandoli
names(stack_ndvi) <- c("NDVI 2018", "NDVI 2020", "NDVI 2026") # assegna nomi agli oggetti del vettore
im.ridgeline(stack_ndvi, scale = 1, palette = "inferno") +
  xlim(0, 1) +                                                # Restringimento dei valori di x per una visualizzazione migliore 
       labs(title = "Ridgeline plot dei valori di NDVI")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/8239aba4ed8cd0af89a47a95d6eebc6c6c52a407/ESAME/Immagini/Ridgelines.png" />

I grafici a cresta mostrano come dopo gli incendi del 2019-2020 la densità di dsitribuzione dell'NDVI si è appiattita e allargata, in quanto sono scomparsi i picchi di valori alti a causa della perdita di copertura forestale, che ha lasciato posto al suolo esposto caratterizzato da valori prossimi allo 0.

### Calcolo della differenza multitemporale dell'NDVI

Calcolando la differenza dei valori di NDVI nei tempi diversi, è possibile mappare come la salute della vegetazione cambia nel tempo.

```r
dev.off()                            #chiude finestra grafica

ndvi_diff1 <- ndvi_2020 - ndvi_2018  # Differenza tra prima dell'inizio e dopo la fine degli incendi
ndvi_diff2 <- ndvi_2026 - ndvi_2020  # Differenza tra dopo la fine e il periodo di recupero
ndvi_diff3 <- ndvi_2026 - ndvi_2018  # Differenza totale

im.multiframe(1,3)

plot(ndvi_diff1, col = plasma(100), main = "2018 - 2020")
plot(ndvi_diff2, col = plasma(100), main = "2020 - 2026")
plot(ndvi_diff3, col = plasma(100), main = "2018 - 2026")
```

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/83df1e455eefa2a96a7a90fcd37a2e678fec9aaf/ESAME/Immagini/NVDIdiff.png" />

Nella prima immagine si può vedere facilmente la perdita di vegetazione causata dagli incendi, evidenziata dalle aree di colore scuro. Nel periodo successivo invece questa perdita è stata invertita, e le stesse aree hanno un colore chiaro, indicando il ripristino vegetazionale. L'ultima immagine mostra invece il cambiamento complessivo dal 2018 al periodo attuale. Si può vedere come il recupero della copertura forestale è stato quasi completo, con pure del miglioramento nelle aree colpite prima del 2018. Tuttavia, a nord-ovest si possono notare numerose aree quasi puntiformi in cui è avvenuta invece una perdita di vegetazione.

## Classificazione

### Classificazione non supervisionata

La classificazione non supervisionata permette di raggruppare i pixel delle immagini NDVI in classi omogenee, stabilendo la frequenza dei pixel della copertura vegetale e delle aree impattate dai fuochi. 

```r
class_2018 <- im.classify(ndvi_2018, seed = 1303, num_cluster = 3) # seed indica una delle iterazioni possibili
class_2020 <- im.classify(ndvi_2020, seed = 20, num_cluster = 3)
class_2026 <- im.classify(ndvi_2026, seed = 09, num_cluster = 3)
```

<p align="center"> <img width="768" height="418"  src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/83df1e455eefa2a96a7a90fcd37a2e678fec9aaf/ESAME/Immagini/Cluster.png" />

Indicando tre cluster, vengono individuate come classi la vegetazione, le aree a suolo nudo e le lagune. Quest'ultima classe non è veramente d'interesse per questo studio, e per questo possiamo rimuoverla dalla visualizzazione, colorandola di bianco in modo da mimetizzarla con il mare, che è stato tagliato dal raster usando la funzione `crop`, e creando una legenda che mostra solo le altre due classi.

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

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/83df1e455eefa2a96a7a90fcd37a2e678fec9aaf/ESAME/Immagini/Classification.png" />

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
  Pre_2018 = round(perc_2018, digits = 2) , # arrotondiamo a due cifre decimali
  Post_2020 = round(perc_2020, digits = 2) ,
  Post_2026 = round(perc_2026, digits = 2) ,
)

# Visualizzazione tabella

tabella
```

| Classi | Pre 2018 | Post 2020 | Post 2026 |
| :--- | :---: | :---: | :---: | 
| Vegetazione | 96.77%  | 63.58% | 96.00% |
| Suolo nudo  | 3.23%  | 36.34% | 3.95 |

Dai dati si può vedere che in seguito agli incendi del 2019-2020 la vegetazione, da una condizione originaria di elevata copertura, ha subito un calo maggiore del 30%. Nel 2026 è riuscita a recuperare il danno ritornando ad un valore di 96%, non raggiungendo per poco meno di un centesimo poco valore di partenza.

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

<img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/83df1e455eefa2a96a7a90fcd37a2e678fec9aaf/ESAME/Immagini/BarPlot.png" />

## Conclusioni

L'analisi condotta tramite telerilevamento satellitare multitemporale ha permesso di quantificare e confrontare il danno ambientale causato dagli incendi nell'area di studio e il processo di recupero negli anni successivi. Il confronto multitemporale degli indici di NBR e NDVI hanno mostrato una perdita di vegetazione del 30% a causa degli incendi del 2019-2020, socceduto da un quasi totale ripristino nel 2026. Il recupero incompleto potrebbe essere ascrivibile al semplice errore o da una mancata rigenerazione della copertura vegetale in pochissime zone, tuttavia l'anaisi qualitativa delle immagini suggerisce che ciò potrebbe essere spiegato da eventi successivi agli incendi. Infatti nella maggiorparte delle aree colpite si osserva il pieno ritorno della foresta, comprese quelle danneggiate da incendi precedenti alla _Black Summer_. La vegetazione dovrebbe quindi aver raggiunto uno stato di salute perfino maggiore della condizione iniziale, ma questo recupero è stato controbilanciato da un'aggiuntiva scomparsa di copertura forestale. A differenza dei danni da incendio, queste aree non sono estese ma appaiono come sparsi punti in tutta la zona a nord-est, all'incirca in corrispondenza con la foresta statale di _Yambulla_.

Una vista più ravvicinata dell'area mostra che la causa di tutto ciò è la deforestazione per mano dell'uomo, tramite il taglio degli alberi per l'industria del legname. La _Forestry Corporation of NSW_ è stata infatti denunciata numerose volte per il sovrasfruttamento delle risorse forestali, non curandosi dei danni causati dalla _Black Summer_, causando un'ulteriore perdita di habitat per specie minacciate dopo agli incendi.

In conclusione, dopo sei anni dalla fine degli incendi la vegetazione avrebbe potuto recuperare completamente la copertura persa tra il 2019 e il 2020, se non fosse stato per una successiva deforestazione causata dall'attività umana.

<p align="center"> <img src="https://github.com/MircoGruppi/Telerilevamento_2026_/blob/01fdae50635dd5c0747eaa60d9489da74df69b19/ESAME/Immagini/Deforestazione.png" />

## Sitografia

[Bushfires in the ACT - ACT State of the Environment](https://www.actsoe2023.com.au/issues/bushfires-in-the-act/)

[Normalized Burn Ratio (NBR) - Office for Outer Space Affairs UN-SPIDER Knowledge Portal](https://un-spider.org/advisory-support/recommended-practices/recommended-practice-burn-severity/in-detail/normalized-burn-ratio)

[Forestry Corp pinged for logging environmentally significant forests after the Black Summer bushfires - Nature Conservation Council in NSW](https://www.nature.org.au/forestry_corp_pinged_for_logging_environmentally_significant_forests_after_the_black_summer_bushfires)
