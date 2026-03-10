# Codice R per analisi dati multispettrali
#risoluzione spettrale aumenta con aumentare numero di bande

install.packages("viridis")
install.packages("ggplot2")
install.packages("patchwork")
install.packages("GGally")

library(terra) #pacchetto per usare dati spaziali
library(imageRy) #pacchetto per immagini satellitari
library(viridis) #palette
library(ggplot2) #Per fare plot
library(patchwork) #usa operazioni matematiche per concatenare plot
library(GGally) #Usa dataframe -> useremo in futuro

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

clgr <- colorRampPalette(c("dark gray","gray", "light gray"))(100)
plot(b2, col=clgr)

# par -> permette di fare multiframe mostrando più immagini affiancate

par(mfrow=c(1,2)) #1 riga 2 colonne
plot(b2,col=mako(100))
plot(b2,col=clg)

#dev.off() chiude finestra grafica

?im.multiframe
im.multiframe(1,2)
plot(b2,col=inferno(100))
plot(b2,col=clg)

#05/03/2026

#Importiamo banda del verde
b3 <- im.import("sentinel.dolomites.b3.tif")
plot(b3, col=viridis(100)) #grafico usando palette viridis

#banda rosso
b4 <- im.import("sentinel.dolomites.b4.tif")
plot(b4, col=magma(100))

#banda Near Infrared VNIR

b8 <- im.import("sentinel.dolomites.b8.tif")
#Maggiore discrezione tra elementi diversi del paesaggio

#Esercizio: multiframe con 4 bande, legende in linea con le wavelenght
clb <- colorRampPalette(c("dark blue","blue", "light blue"))(100)
clg <- colorRampPalette(c("dark green","green", "light green"))(100)
clr <- colorRampPalette(c("#9C0824","#D73529", "#EAC0BD"))(100)
im.multiframe(2,2)
plot(b2,col=clb)
plot(b3,col=clg)
plot(b4,col=clr)
plot(b8,col=plasma(100))

#STACK
#Prende immagini e le mette insieme
#Bande possono essere visti come elementi di un vettore
sentinel <- c(b2,b3,b4,b8)
plot(sentinel) #le disegna tutte automaticamente insieme, con stessa palette
plot(sentinel, col=inferno(100))

b2 #mostra informazioni dell'oggetto
sentinel #mostra vettore con tutti i layer
plot(sentinel$sentinel.dolomites.b8) # $ serve per legare vari oggetti tra di loro

# layer1=b2 blue, layer2=b3 green, layer3=b4 red, layer4=b8 infrared
plot(sentinel[4]) #nelle matrici si usa parentesi quadra
#richiamato solo quarto elemento -> Subset
plot(sentinel[2])

#coord. ref. : WGS 84 / UTM zone 32N (EPSG:32632) 
#Sistema di riferimento delle coordinate

?im.ggplot #Fa plot basato su pacchetto ggplot
im.ggplot(b8,layerfill=1) #argomento layerfill= quale strato usato per illustrare -> usato valore 1 di default

p1 <- im.ggplot(b8)
p2 <- im.ggplot(b4)
p1+p2 #tratto i plot come oggetti unendoli

#MULTIFRAME: 4 metodi
# 1. par(mfrow=c(1,2)
# 2. im.multiframe(1,2) -> simula il par
# 3. creare STACK 
# 4. ggplot2 patchwork

#RGB plotting
?im.plotRGB #crea stack multispettrale con varie bande diverse

#creiamo stack sentinel -> fatto prima
# layer1=b2, layer2=b3, layer3=b4, layer4=b8
im.plotRGB(sentinel,r=3,g=2,b=1) #3 filtri di colore, 4 valori -> usiamo quelli nel visibile
#Abbiamo ottenuto COLORI NATURALI visti da occhio umano

#usiamo la banda in infrarosso
im.plotRGB(sentinel,r=4,g=3,b=2) #spostato di 1 le bande
# FALSE COLORS vegetazione che riflette in NIR ottiene colore rosso

im.multiframe(1,2) #multiframe per confrontarle
im.plotRGB(sentinel,r=3,g=2,b=1)
im.plotRGB(sentinel,r=4,g=3,b=2)
#Infrarosso permette di distinguere bene la vegetazione dalle ombre scure

plot(sentinel[[4]])
im.plotRGB(sentinel,r=4,g=3,b=2) #confronto tra vidione infrarossa da sola e con altre due bande

im.plotRGB(sentinel,r=3,g=4,b=1) #NIR su verde

im.plotRGB(sentinel,r=3,g=2,b=4) #NIR su blu -> utile per evidenziare suolo nudo -> mostra deforestazione

#Mettendo NIR su un colore la vegetazione assume quel colore

#Multiframe con 4 rappresentazioni diverse
im.multiframe(2,2)
im.plotRGB(sentinel,r=3,g=2,b=1)
im.plotRGB(sentinel,r=4,g=3,b=2)
im.plotRGB(sentinel,r=3,g=4,b=1)
im.plotRGB(sentinel,r=3,g=2,b=4)

#bande visibili sono altamente correlate tra loro, scambiandole mentre si usa l'infrarosso non cambia molto
im.multiframe(1,2)
im.plotRGB(sentinel,r=4,g=2,b=3)
im.plotRGB(sentinel,r=4,g=3,b=2)

pairs(sentinel) #mostra correlazione tra tutti layer e le combinazioni tra loro
#usa correlazione di Pearson (cor) parametrica

#si può semplificare funziona senza scritte
im.plotRGB(sentinel,3,2,1)

#plotRGB da terra
plotRGB(sentinel,4,2,3, stretch="lin") #RIASCOLTA
plotRGB(sentinel,4,2,3, stretch="hist") #stretch che amplia area centrale -> aumenta valori medi
