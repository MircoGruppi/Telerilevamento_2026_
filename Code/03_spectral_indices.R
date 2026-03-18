library(terra)
library(imageRy)
library(viridis)

#listing files
im.list()

# 15 progetto landsat
#importing data
mato1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 <- flip(mato1992) # jpeg non georeferenziata, ribalta verticalmente per reimpostare Nord e Sud -> confronto da landsat
mato1992 #3 bande
# l1=NIR l2=Red l3=Green
im.plotRGB(mato1992,r=1,g=2,b=3)

im.plotRGB(mato1992,r=2,g=3,b=1) #mette in evidenza il suolo nudo

# aster
mato2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 <- flip(mato2006) 
im.plotRGB(mato2006,r=1,g=2,b=3)
#si nota perdita di foresta

im.multiframe(1,2)
im.plotRGB(mato1992,r=1,g=2,b=3)
im.plotRGB(mato2006,r=1,g=2,b=3)

im.multiframe(1,2)
im.plotRGB(mato1992,r=2,g=3,b=1)
im.plotRGB(mato2006,r=2,g=3,b=1)

#DVI
#Pianta ha riflettanda da 0-100
#NIR=100 red=0
#indice DVI = NIR - red = 100-0 = 100 -> Valore massimo vegetazione
#Pianta stressata riflette meno nel nir e più nel rosso
#NIR = 70 - 10 = 60 -> cala valore DVI

dvi1992 <- mato1992[[1]]-mato1992[[2]]
dvi2006 <- mato2006[[1]]-mato2006[[2]]

im.multiframe(1,2)
plot(dvi1992,col=inferno(100))
plot(dvi2006,col=inferno(100))

# DVI con diverse RISOLUZIONE RADIOMETRICA (diversi bit)
# 8 bit -> 0 - 255 (0 conta come 1, max è 2^8-1)
# DVI = NIR - red = 255-0 = 255 #max DVI
# DVI = NIR - red = 0-255 = -255 #max DVI
#Ad 8 bit il range è -255 - 255

# 3 bit -> DVI ha range -3 - 3 di default
#non possibile confrontare immagini con risoluzione radiometrica diversa

# NDVI per standardizzare
# 8 bit
# NDVI = (NIR - red) / (NIR + red) = (255-0) / (255+0) = 1 #MAX NDVI
#min è inverso = -1

# 3 bit
# 3-0 / 3+0 = 1
#comparabile con 8 bit

ndvi1992 <- dvi1992 / (mato1992[[1]]+mato1992[[2]])
ndvi2006 <- dvi2006 / (mato2006[[1]]+mato2006[[2]])

im.multiframe(2,2)
plot(dvi1992,col=inferno(100))
plot(dvi2006,col=inferno(100))
plot(ndvi1992,col=inferno(100))
plot(ndvi2006,col=inferno(100))

#DVI con imageRy

dvi1992 <- im.dvi(mato1992,1,2)
dvi2006 <- im.dvi(mato2006,1,2)
plot(dvi1992,col=inferno(100))
plot(dvi2006,col=inferno(100))

#NDVI con imageRy

ndvi1992 <- im.ndvi(mato1992,1,2)
ndvi2006 <- im.ndvi(mato2006,1,2)
plot(ndvi1992,col=inferno(100))
plot(ndvi2006,col=inferno(100))
