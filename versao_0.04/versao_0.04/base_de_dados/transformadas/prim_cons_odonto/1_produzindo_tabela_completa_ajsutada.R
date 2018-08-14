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
prim_cons_odonto <- read_csv("base_de_dados/extraidas/odonto/odonto.csv")
prim_cons_odonto <- prim_cons_odonto[,c(1:6)]
names(prim_cons_odonto) <- c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES", "QUANTIDADE")

#Trocando as áreas, para valores corretos
prim_cons_odonto$AREA<-as.character(prim_cons_odonto$AREA)
prim_cons_odonto$AREACS<-paste(prim_cons_odonto$UNIDADE, prim_cons_odonto$AREA)
prim_cons_odonto <- select(prim_cons_odonto,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
prim_cons_odonto<-left_join(prim_cons_odonto,areas,by = "AREACS", all.x = T)
prim_cons_odonto <- select(prim_cons_odonto, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(prim_cons_odonto, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


