# Codice R per analisi dati multispettrali
#risoluzione spettrale aumenta con aumentare numero di bande

install.packages("viridis")

library(terra) #pacchetto per usare dati spaziali
library(imageRy) #pacchetto per immagini satellitari
library(viridis)

im.list()
#im. inizio funzioni imageRy
?im.list #apre pagina di aiuto

#dato sentinel della catena dolomitica delle Tofane
#fatte da sentinel-2
#Copernicus programma per scaricare dati delle bande

#Sentinel-2 bands
#https://gisgeography.com/sentinel-2-bands-combinations/
b2 <- im.import("sentinel.dolomites.b2.tif")
#riflettanza del blu -> aree che riflettono più il blu hanno valori più alti
#nel grafico che esce il colore della max riflettanza è giallo

#legenda dei colori
cl <- colorRampPalette(c("mistyrose2","orchid3", "maroon4"))(100) #extrafunzione va specificato numero di sfumature
plot(b2, col=cl) #assegnamo all'oggetto la palette

#meno sfumature
cl3 <- colorRampPalette(c("mistyrose2","orchid3", "maroon4"))(3) #con 3 elimina le sfumature
plot(b2, col=cl3)

#possiamo installare direttamente palette prefatte
# LO INSTALLIAMO IN CIMA per sapere quali usiamo per tutto il codice
plot(b2, col=inferno(100)) #numero sfumature è dentro alla parentesi

#ESERCIZIO

#cambiamo colore in scala di grigi

clg <- colorRampPalette(c("dark gray","gray", "light gray"))(100)
plot(b2, col=clg)

# par -> permette di fare multiframe mostrando più immagini affiancate

par(mfrow=c(1,2)) #1 riga 2 colonne
plot(b2,col=inferno(100))
plot(b2,col=clg)

#dev.off() chiude finestra grafica

?im.multiframe
im.multiframe(1,2)
plot(b2,col=inferno(100))
plot(b2,col=clg)
