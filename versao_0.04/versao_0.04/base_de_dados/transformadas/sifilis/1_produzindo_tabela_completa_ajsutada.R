setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(reshape2)
library(zoo)


#Dimensão acesso

##unindo as duas tabelas
sifilis <- read_csv("base_de_dados/extraidas/sifilis/sifilis.csv")


#Trocando as áreas, para valores corretos
sifilis$AREA<-as.character(sifilis$AREA)
sifilis$AREACS<-paste(sifilis$UNIDADE, sifilis$AREA)
sifilis <- select(sifilis,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
sifilis<-left_join(sifilis,areas,by = "AREACS", all.x = T)
sifilis <- select(sifilis, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(sifilis, "base_de_dados/transformadas/sifilis/sifilis_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


