setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(reshape2)


#Dimensão integralidade

##Encaminhamentos Médicos
encs_med <- read_csv("base_de_dados/extraidas/encaminhamentos/encs_med.csv")

#Trocando as áreas, para valores corretos
encs_med$AREA<-as.character(encs_med$AREA)
encs_med$AREACS<-paste(encs_med$UNIDADE, encs_med$AREA)
encs_med <- select(encs_med,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
encs_med<-left_join(encs_med,areas,by = "AREACS", all.x = T)
encs_med <- select(encs_med, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(encs_med, "base_de_dados/transformadas/encaminhamentos/encs_med_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


