setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)
library(zoo)


#Dimensão acesso

##unindo as duas tabelas
citopatologico <- read_csv("base_de_dados/extraidas/citopatologico/citopatalogico.csv")
citopatologico_pop <- read_csv("base_de_dados/extraidas/citopatologico/citopatalogico_pop.csv")
citopatologico <- merge(citopatologico, citopatologico_pop, by = c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES"), all.x = T)


#Trocando as áreas, para valores corretos
citopatologico$AREA<-as.character(citopatologico$AREA)
citopatologico$AREACS<-paste(citopatologico$UNIDADE, citopatologico$AREA)
citopatologico <- select(citopatologico,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
citopatologico<-left_join(citopatologico,areas,by = "AREACS", all.x = T)
citopatologico <- select(citopatologico, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(citopatologico, "base_de_dados/transformadas/citopatologico/citopatologico_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


