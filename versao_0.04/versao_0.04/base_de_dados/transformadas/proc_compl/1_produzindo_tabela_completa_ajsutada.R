setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)
library(zoo)


#Dimensão integralidade

##proc_compl
proc_compl <- read_csv("base_de_dados/extraidas/proc_compl/proc_compl.csv")

#Trocando as áreas, para valores corretos
proc_compl$AREA<-as.character(proc_compl$AREA)
proc_compl$AREACS<-paste(proc_compl$UNIDADE, proc_compl$AREA)
proc_compl <- select(proc_compl,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
proc_compl<-left_join(proc_compl,areas,by = "AREACS", all.x = T)
proc_compl <- select(proc_compl, -AREACS)


#Escrevendo tabela pronta completa pronta
write.csv(proc_compl, "base_de_dados/transformadas/proc_compl/proc_compl_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


