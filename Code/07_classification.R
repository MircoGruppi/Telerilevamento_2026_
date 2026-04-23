# R code for classifying images

library(terra)
library(imageRy)
library(ggplot2) #disegna grafici
library(patchwork) #compone plot di ggplot

setwd("C:/Users/mirco/Downloads")


im.list()

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

?im.classify
#classificazione non supervisionata -> R sceglie automaticamente i tipi di gruppi, noi richiediamo il numero
sunc <- im.classify(sun, num_clusters=3) #classificazione in classi
#di default il seed è considerato NULL, dobbiamo definirlo noi
sunc <- im.classify(sun, num_clusters=3, seed=19) #tra le migliaia di iterazioni possibili sceglie la diciannovesima
#scegliendo stesso seed ogni persona ottiene la stessa mappa

# Grand Canyon

can <- im.import("dolansprings_oli_2013088_canyon_lrg.jpg")
canc <- im.classify(can,num_clusters=4,seed=19)
#alcune tipi di superfici unite insieme

# classifichiamo immagine scaricata
list.files()

getwd()
dji <- rast("Nuovo progetto (1).png" )
dji <- flip(dji)
plot(dji)

djic <- im.classify(dji, num_clusters=5)

# Classificazione Mato Grosso

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

im.multiframe(2,1)
plot(m1992)
plot(m2006)

m1992c <- im.classify(m1992,num_clusters=2,seed=19)
m2006c <- im.classify(m2006,num_clusters=2,seed=19)
#Foresta Classe 1
#Fiume + Aree umane 2

#Assegniamo etichette -> usando tabelle

levels(m1992c) <- data.frame(
  value = c(1, 2),
  label = c("forest", "human")
)

levels(m2006c) <- data.frame(
  value = c(2, 1),
  label = c("forest", "human")
)
pa

#Percentuali
#Frequenza= numero di pixel di una classe
freq1992 <- freq(m1992c)

#percentuale = freq /100 * TOT

perc1992 <- freq1992$count * 100 / ncell(m1992c) #ncell calcola pixel totali immagine

#uguale con 2006
freq2006 <- freq(m2006c)

perc2006 <- freq2006$count * 100 / ncell(m2006c)

# creiamo tabella -> dataframe a 3 colonne
tabout <- data.frame(
  class=c("Forest","Human"),
  perc1992=c(83, 17),
  perc2006=c(45, 55)
  )

#funzione per fare plot in ggplot: ggplot
# aesthetics (aes) definisce estetica del grafico -> asse x, y e colori -> richiamano colonne della tabella
#dopo funzione definisce tipo di grafico da usare -> geom_bar usa barre (istogrammi), altrimenti _point, ecc
#ogni pezzo aggiunto in sequenza alla funzione da "+"

#fill definisce colore interno delle barre
p1 <- ggplot(tabout, aes(x=class, y=perc1992, color=class)) + 
      geom_bar(stat="identity", fill="white") + 
      ylim(c(0,100)) + #limiti
      theme(legend.position="none") #nasconde legenda

#facciamo per 2006

p2 <- ggplot(tabout, aes(x=class, y=perc2006, color=class)) + 
      geom_bar(stat="identity", fill="white") + 
      ylim(c(0,100)) +
      theme(legend.position="none") #theme_minimal toglie lo sfondo grigio tipico di ggplot, theme_dark mette sfondo scuro

p1 + p2 #patchwork mette insieme i due grafici
#l'asse delle y è diverso

#abbiamo aggiunto ylim per indicare limiti asse y uguale ad entrambe
#legenda ripetuta, la rimuoviamo dal primo grafico
