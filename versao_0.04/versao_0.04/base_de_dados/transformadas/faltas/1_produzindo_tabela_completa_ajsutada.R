setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)


#Dimensão integralidade


##Encaminhamentos Médicos
faltas <- read_csv("base_de_dados/extraidas/faltas/faltas.csv")

#Trocando as áreas, para valores corretos
faltas$AREA<-as.character(faltas$AREA)
faltas$AREACS<-paste(faltas$UNIDADE, faltas$AREA)
faltas <- select(faltas,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
faltas<-left_join(faltas,areas,by = "AREACS")
faltas <- select(faltas, -AREACS)

faltas <- na.omit(faltas)


#Escrevendo tabela pronta completa pronta
write.csv(faltas, "base_de_dados/transformadas/faltas/faltas_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


