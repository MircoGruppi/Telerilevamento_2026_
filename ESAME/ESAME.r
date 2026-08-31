#importa raster
Bologna2020<-rast("Bologna_2020_bands.tif")
Bologna2025<-rast("Bologna_2025_bands.tif")
Bologna2020
Bologna2025

#mostra layer separati
im.multiframe(2,4)
plot(Bologna2020[[1]], col = magma(100), main = "2020, B2")
plot(Bologna2020[[2]], col = magma(100), main = "2020, B3")
plot(Bologna2020[[3]], col = magma(100), main = "2020, B4")
plot(Bologna2020[[4]], col = magma(100), main = "2020, B8")
plot(Bologna2025[[1]], col = magma(100), main = "2020, B2")
plot(Bologna2025[[2]], col = magma(100), main = "2020, B3")
plot(Bologna2025[[3]], col = magma(100), main = "2020, B4")
plot(Bologna2025[[4]], col = magma(100), main = "2020, B8")

#visualizzazione a colori naturali
im.multiframe(1,2)
im.plotRGB(Bologna2020, r=3, g=2, b=1, title="Bologna 2020")
im.plotRGB(Bologna2025, r=3, g=2, b=1, title="Bologna 2025")

#visualizzazione a falso colori -> nir su blu per evidenziare consumo suolo
im.plotRGB(Bologna2020, r=3, g=2, b=4, title="Bologna 2020")
im.plotRGB(Bologna2025, r=3, g=2, b=4, title="Bologna 2025")

# nir su red
im.plotRGB(Bologna2020, r=4, g=2, b=1, title="Bologna 2020")
im.plotRGB(Bologna2025, r=4, g=2, b=1, title="Bologna 2025")

#DVI
dvi_2020 <- im.dvi(Bologna2020, 4, 3)
dvi_2025 <- im.dvi(Bologna2025, 4, 3)
plot(dvi_2020, col = cividis(100), main = "DVI 2020")
plot(dvi_2025, col = cividis(100), main = "DVI 2025")

#NDVI
ndvi_2020 <- im.ndvi(Bologna2020, 4, 3)
ndvi_2025 <- im.ndvi(Bologna2025, 4, 3)
plot(ndvi_2020, col = cividis(100), main = "NDVI 2020")
plot(ndvi_2025, col = cividis(100), main = "NDVI 2025")

#Stack
stack_ndvi <- c(ndvi_2020, ndvi_2025) 
names(stack_ndvi) <- c("NDVI 2020", "NDVI 2025")
im.ridgeline(stack_ndvi, scale = 1, palette = "inferno")

#NDVI diff
dev.off()
ndvi_diff <- ndvi_2025 - ndvi_2020
plot(ndvi_diff, col = inferno(100), main = "2020 - 2025")

#CLASSI
class_2020 <- im.classify(ndvi_2020, seed = 42, num_cluster = 4)
class_2025 <- im.classify(ndvi_2025, seed = 42, num_cluster = 4)

f_2020 <- freq(class_2020)
f_2025 <- freq(class_2025)

prop_2020 <- f_2020$count / ncell(class_2020)
prop_2025 <- f_2025$count / ncell(class_2025)

perc_2020 <- prop_2020 * 100
perc_2025 <- prop_2025 * 100

tabella <- data.frame(
  class = c(1, 2, 3),
  P2020 = perc_2020,
  P2025 = perc_2025
)

tabella
