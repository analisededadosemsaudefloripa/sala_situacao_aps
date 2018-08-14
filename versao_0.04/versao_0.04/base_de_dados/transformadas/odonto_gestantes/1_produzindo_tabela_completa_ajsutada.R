setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)


#Dimensão integralidade


##Encaminhamentos Médicos
odont_gestantes <- read_csv("base_de_dados/extraidas/gestantes/gestantes.csv")

#Trocando as áreas, para valores corretos
odont_gestantes$AREA<-as.character(odont_gestantes$AREA)
odont_gestantes$AREACS<-paste(odont_gestantes$UNIDADE, odont_gestantes$AREA)
odont_gestantes <- select(odont_gestantes,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
odont_gestantes<-left_join(odont_gestantes,areas,by = "AREACS")
odont_gestantes <- select(odont_gestantes, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(odont_gestantes, "base_de_dados/transformadas/odonto_gestantes/odont_gestantes_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


