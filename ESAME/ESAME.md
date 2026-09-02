> ### Telerilevamento Geo-Ecologico in R
>> Mirco Gruppi

# Analisi dell'impatto vegetazionale degli incendi in Australia del 2019-2020

Appello d'esame: 07/09/2026

## Introduzione

A partire da giugno 2019 fino a febbraio 2020 il sud-est dell'Australia è stata colpita da una serie di incendi boschivi. Il periodo venne nominato l'"__Australian bushfire season__" o anche la "__Black Summer__", data la lunga durata, la quantità di fuochi e un'area di impatto di oltre 24 milioni di ettari. 
Una delle aree più impattate è la costa attorno al paese di **Mallacoota**, situato al confine tra gli stati di Victoria e New South Wales nella Contea di East Gippsland. 

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

L'analisi multitemporale invece permette di valutare la resilienza dell'ecosistema e il recupero vegetazionale dopo sei anni.

## Metodologia

### Acquisizione dati
Le immagini sono state acquisite dal portale web di [Google Earth Engine](https://earthengine.google.com/), selezionando l'area colpita dall'incendio. Le immagini sono state selezionate nello stesso periodo stagionale per minimizzare gli effetti fenologici. 

### Analisi tramite Software R

#### Impostazione della working directory

```r
setwd("~/Desktop/Università/Telerilevamento") 
getwd()       #verifica della working directory
list.files()  #lista dei file all'interno della working directory
```
#### Caricamento dei pacchetti che verranno utilizzati nello studio.
