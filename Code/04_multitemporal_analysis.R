library(terra)
library(imageRy)

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
