install.packages("qrcode")

library(qrcode)

url <- "https://github.com/MircoGruppi"
qr <- qr_code(url)

setwd("C:/Users/mirco/Desktop")

png("github_profile_qr.png", width = 1000, height = 1000)
plot(qr)
