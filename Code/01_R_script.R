# in Markdown (scrittura di Github) l'hashtag indica il titolo, su R è un commento
2+3 #calcolatore automatico
#oggetto
michele <- 2 + 3 #freccia ASSEGNA 2+3 a michele
michele = 2+3 #Biunivoco, oggetto è la stessa cosa di 2+3 / stessa funzione
michele

tecla <- 4+6
michele + tecla
michele ^ tecla

# arrays o vettori
sonia <- c(10, 8, 3, 1, 0) #concatenazione -> Funzione con argomenti (separati da virgola
#funzione assegnata a sonia
giorgia <- c(3, 10, 20, 50, 100)
plot(giorgia, sonia, col="blue", pch=19, cex=2, xlab="Pollution", ylab="Dolphin number") #relazione tra variabile dipendente ed altra -> indipendente su x, dipendente su y
#variare dei delfini in funzione dei pfas
# pch è il tipo di simbolo
#cex è la dimensione

#installazione pacchetti

#CRAN
#pacchetto terra: usa funzioni per gestire dati raster e vettori
install.packages("terra") #scegliere una città italiana
library(terra) #richiama pacchetto per usarlo

install.packages("devtools") # remotes
library(devtools) # remotes
install_github("ducciorocchini/imageRy") #installazione tramite github -> + comodo per aggiornamento (???)
library(imageRy)
im.list()
