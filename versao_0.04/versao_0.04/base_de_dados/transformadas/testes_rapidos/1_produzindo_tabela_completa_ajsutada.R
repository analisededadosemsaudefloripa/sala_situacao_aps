setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)
library(zoo)


#Dimensão acesso

##demanda_espontanea
testes_rapidos <- read_csv("base_de_dados/extraidas/testes_rapidos/testes_rapidos.csv")


#Trocando as áreas, para valores corretos
testes_rapidos$AREA<-as.character(testes_rapidos$AREA)
testes_rapidos$AREACS<-paste(testes_rapidos$UNIDADE, testes_rapidos$AREA)
testes_rapidos <- select(testes_rapidos,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
testes_rapidos<-left_join(testes_rapidos,areas,by = "AREACS", all.x = T)
testes_rapidos <- select(testes_rapidos, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(testes_rapidos, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


