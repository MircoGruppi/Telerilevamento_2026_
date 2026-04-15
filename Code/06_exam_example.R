library(terra) #package to manage spatial data
library(imageRy) #package for RS didactics

setwd("~/Desktop/")
getwd()
list.files()

ice <- rast("ISS074-E-417243.jpg")

im.multiframe(1,2)
plot(ice[[1]])
plot(ice[[2]])

im.multiframe(3,1)
hist(values(ice[[1]]), main="Istogramma Red", col="red")
hist(values(ice[[2]]), main="Istogramma Green", col="green")
hist(values(ice[[3]]), main="Istogramma Blue", col="blue")
