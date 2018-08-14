setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)


#Dimensão integralidade


##Encaminhamentos Médicos
gestantes <- read_csv("base_de_dados/extraidas/gestantes/gestantes.csv")

#Trocando as áreas, para valores corretos
gestantes$AREA<-as.character(gestantes$AREA)
gestantes$AREACS<-paste(gestantes$UNIDADE, gestantes$AREA)
gestantes <- select(gestantes,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
gestantes<-left_join(gestantes,areas,by = "AREACS")
gestantes <- select(gestantes, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(gestantes, "base_de_dados/transformadas/gestantes/gestantes_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


