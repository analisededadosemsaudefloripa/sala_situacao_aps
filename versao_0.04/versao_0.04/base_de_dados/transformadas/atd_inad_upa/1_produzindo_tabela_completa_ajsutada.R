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
atd_inad_upa <- read_csv("base_de_dados/extraidas/atd_inad_upa/atd_inad_upa.csv",
                         col_names = T)


names(atd_inad_upa) <- c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES", "QUANTIDADE")

#Trocando as áreas, para valores corretos
atd_inad_upa$AREA<-as.character(atd_inad_upa$AREA)
atd_inad_upa$AREACS<-paste(atd_inad_upa$UNIDADE, atd_inad_upa$AREA)
atd_inad_upa <- select(atd_inad_upa,-AREA)
areas <- read_csv("base_de_dados/extraidas/areas.csv")
atd_inad_upa<-left_join(atd_inad_upa,areas,by = "AREACS", all.x = T)
atd_inad_upa <- select(atd_inad_upa, -AREACS)

atd_inad_upa <- na.omit(atd_inad_upa)


#Escrevendo tabela pronta completa pronta
write.csv(atd_inad_upa, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


