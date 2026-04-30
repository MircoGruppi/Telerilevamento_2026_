#Le mie funzioni
library(imageRy)

somma <- function(x,y){
    z=x+y #definisce funzione
    return(z) #restituisce risultato
    }

#funzione chiamata differenza

diff <- function(x,y){
    z=x-y #definisce funzione
    return(z) #restituisce risultato
    }

#par
mf <- function(nx,ny) {
  par(mfrow=c(nx,ny))
  }


sent <- im.import("sentinel.dolomites")

mf(1,2)
plot(sent[[1]])
plot(sent[[2]])

n
> plot(sent[[1]])
Errore in plot.xy(xy, type, ...) : 
  invalid type passed to graphics function
> 
 

mf2 <- function(nx=1,ny=2) { #default 1 e 2 nella funzione -> 1 riga e 2 colonne
  par(mfrow=c(nx,ny))
  }

mf2()
plot(sent[[1]])
plot(sent[[2]])

#CONDIZIONI: if / else

pos <- function (x){
    if(x>0){
        "Questo numero è positivo"
        }
    else if(x<0) {
        "Questo numero è negativo"}
    else {
        "Zero non è negativo né positivo"
        }
}

#CICLO FOR

loop <- function() { #inseriamo tutti i numeri da 1 a 4
    for (i in 1:50) #riferiamo range di ripetizione funzione -> da 1 a 50
        print(i)
    }

loop2 <- function() { 
    for (i in 1:50) { #graffa serve per far fare tutte le istruzioni tutte insieme
        op <- i*7
        print(op)
        }
    }

setwd("C:/Users/mirco/Desktop/Università/Telerilevamento")
sink("output.txt") #produce txt nella cartella selezionata con funzione
loop2() #funzione che viene sinkata
