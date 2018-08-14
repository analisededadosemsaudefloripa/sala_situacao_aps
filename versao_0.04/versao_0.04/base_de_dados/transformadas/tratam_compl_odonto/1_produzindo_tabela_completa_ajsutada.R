setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(reshape2)
library(zoo)


#Dimensão acesso

##demanda_espontanea
tratam_compl_odonto <- read_csv("base_de_dados/extraidas/odonto/odonto.csv")
tratam_compl_odonto <- tratam_compl_odonto[,c(1:5,7)]
names(tratam_compl_odonto) <- c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES", "QUANTIDADE")

#Trocando as áreas, para valores corretos
tratam_compl_odonto$AREA<-as.character(tratam_compl_odonto$AREA)
tratam_compl_odonto$AREACS<-paste(tratam_compl_odonto$UNIDADE, tratam_compl_odonto$AREA)
tratam_compl_odonto <- select(tratam_compl_odonto,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
tratam_compl_odonto<-left_join(tratam_compl_odonto,areas,by = "AREACS", all.x = T)
tratam_compl_odonto <- select(tratam_compl_odonto, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(tratam_compl_odonto, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


