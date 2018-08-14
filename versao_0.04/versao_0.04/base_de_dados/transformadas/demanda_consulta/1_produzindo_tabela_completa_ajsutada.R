setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(reshape2)
library(zoo)


#Dimensão acesso

##demanda_consulta
demanda_consulta <- read_csv("base_de_dados/extraidas/demanda_consulta/demanda_consulta.csv")


#Trocando as áreas, para valores corretos
demanda_consulta$AREA<-as.character(demanda_consulta$AREA)
demanda_consulta$AREACS<-paste(demanda_consulta$UNIDADE, demanda_consulta$AREA)
demanda_consulta <- select(demanda_consulta,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
demanda_consulta<-left_join(demanda_consulta,areas,by = "AREACS", all.x = T)
demanda_consulta <- select(demanda_consulta, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(demanda_consulta, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


