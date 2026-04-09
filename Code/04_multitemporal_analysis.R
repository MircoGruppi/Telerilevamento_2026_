install.packages("ggridges")

library(terra)
library(imageRy)
library(ggridges)

EN_01 <- im.import("EN_01.png")
EN_01 <- flip(EN_01)
plot(EN_01)

EN_13 <- im.import("EN_13.png")
EN_13 <- flip(EN_13)
plot(EN_13)

im.multiframe(2,1)
plot(EN_01)
plot(EN_13)

# Differencing
ENdif <- EN_01[[1]] - EN_13[[1]]
plot(ENdif) #mostra differenza valori tra due tempi
#si vedono posti che inquinano di meno in giallo e e di più in blu

#appunti Marta Marrone

#stack immagini dalla groenlandia
gl_00=im.import("greenland.2000.tif")                                
gl_05=im.import("greenland.2005.tif")                                
gl_10=im.import("greenland.2010.tif")                                
gl_15=im.import("greenland.2015.tif")

stack_gl= c(gl_00,gl_05,gl_10,gl_15)

#oppure lo stack si può fare così:
gr = im.import("greenland")

im.multiframe(1,2)
plot(gr[[1]])
plot(gr[[4]])

dif = gr[[4]] - gr[[1]]
dev.off()
plot(dif)

#RGB
RGB = im.plotRGB(gr, 1, 2, 4)
#tutte le zone che hanno temperature più alte nel 2000 vengono rosse, 
#quelle con temperature più alte nel 2005 vengono verdi, quelle con temperature più alte nel 2015 verrano blu)

#importo dati
ndvi <- im.import("Sentinel2_NDVI")
hist(ndvi)
#picchi nei mesi estivi in valori alti, e picchi in valori bassi in inverno
#possiamo convertire istogrammi in linee continue: kernel density

im.ridgeline(ndvi, scale=1, palette="viridis")
#ne mostra solo uno, ogni immagine ha stesso nome della variabile e sovrascrive quello prima
names(ndvi) <- c("02feb","05may","08aug","11nov")
#funzione names() rinomina variabili

im.ridgeline(ndvi, scale=2, palette="inferno")
#separa meno i grafici

#Scatterplot (di due dati) per mostrare variazione ndvi tra mesi
plot(ndvi[[1]],ndvi[[2]])
#Confronto tra Febbraio e Maggio

#aggiungiamo linea di correlazione perfetta ipotetica y=x 
#intercetta a=0 pendenza b=1
abline(0,1,col="red")
#linea non a 45°, assi in scale diverse

#sistemiamo assi
plot(ndvi[[1]],ndvi[[2]], xlim=c(-0.3,0.9), ylim=c(-0.3,0.9))
abline(0,1,col="red")
#I valori tra Febbraio e Maggio non sono uguali
#Valori sopra a retta indicano che sono più alti in maggio, sotto se sono più alti in febbraio
