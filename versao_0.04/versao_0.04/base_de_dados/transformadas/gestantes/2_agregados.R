setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(tidyverse)
library(readr)
library(data.table)
library(zoo)
library(Kmisc) #pacote para manipulação de string
library(lubridate)
library(dplyr)
library(reshape2)


#Dimensão longitudinalidade
#PREPARANDO A BASE
gestantes <- read_csv("base_de_dados/transformadas/gestantes/gestantes_ajustada_utf8.csv")
gestantes$DATA <- as.yearmon(paste(gestantes$ANO, gestantes$MES), "%Y %m") #converntendo em formato date
gestantes$AREA <- as.character(gestantes$AREA)

#Transformando ano e mês em trimestre
gestantes$TRIMESTRE <- as.yearqtr(gestantes$DATA, format = "%d-%b-%y")
gestantes$TRIMESTRE <- as.character(gestantes$TRIMESTRE)


############################################################
#Equipes
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
gestantes_esf<-gestantes[,c(1,2,5:7,9,11)]
gestantes_esf<-aggregate(gestantes_esf[,3:5], by = list(gestantes_esf$DISTRITO, gestantes_esf$UNIDADE,gestantes_esf$AREA, gestantes_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(gestantes_esf)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")
#Criando variável percentual de consultas
gestantes_esf$PERCENTUAL_GESTANTES_7_CONS <- gestantes_esf$GESTANTES_7_CONS/gestantes_esf$GESTANTES *100
gestantes_esf$PERCENTUAL_TODOS_TRI <- gestantes_esf$GEST_TODOS_TRI/gestantes_esf$GESTANTES *100
#Transformando em Tidy
gestantes_esf <- melt(gestantes_esf, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(gestantes_esf)[5:6] <- c("TIPO", "VALOR")



############################################################
#CS
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
gestantes_cs<-gestantes[,c(1,2,5:7,9,11)]
gestantes_cs<-aggregate(gestantes_cs[,3:5], by = list(gestantes_cs$DISTRITO, gestantes_cs$UNIDADE, gestantes_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(gestantes_cs)[1:3] <- c("DISTRITO", "UNIDADE", "TRIMESTRE")
#Criando variável percentual de consultas
gestantes_cs$PERCENTUAL_GESTANTES_7_CONS <- gestantes_cs$GESTANTES_7_CONS/gestantes_cs$GESTANTES *100
gestantes_cs$PERCENTUAL_TODOS_TRI <- gestantes_cs$GEST_TODOS_TRI/gestantes_cs$GESTANTES *100
#Transformando em Tidy
gestantes_cs <- melt(gestantes_cs, id.var = c("DISTRITO", "UNIDADE", "TRIMESTRE"))
colnames(gestantes_cs)[4:5] <- c("TIPO", "VALOR")


############################################################
#Distrito
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
gestantes_distrito<-gestantes[,c(1,5:7,9,11)]
gestantes_distrito<-aggregate(gestantes_distrito[,2:4], by = list(gestantes_distrito$DISTRITO, gestantes_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(gestantes_distrito)[1:2] <- c("DISTRITO", "TRIMESTRE")
#Criando variável percentual de consultas
gestantes_distrito$PERCENTUAL_GESTANTES_7_CONS <- gestantes_distrito$GESTANTES_7_CONS/gestantes_distrito$GESTANTES *100
gestantes_distrito$PERCENTUAL_TODOS_TRI <- gestantes_distrito$GEST_TODOS_TRI/gestantes_distrito$GESTANTES *100
#Transformando em Tidy
gestantes_distrito <- melt(gestantes_distrito, id.var = c("DISTRITO", "TRIMESTRE"))
colnames(gestantes_distrito)[3:4] <- c("TIPO", "VALOR")

############################################################
#Florianópolis
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
gestantes_florianopolis<-gestantes[,c(1,2,5:7,9,11)]
gestantes_florianopolis<-aggregate(gestantes_florianopolis[,3:5], by = list(gestantes_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(gestantes_florianopolis)[1] <- c("TRIMESTRE")
#Criando variável percentual de consultas
gestantes_florianopolis$PERCENTUAL_GESTANTES_7_CONS <- gestantes_florianopolis$GESTANTES_7_CONS/gestantes_florianopolis$GESTANTES *100
gestantes_florianopolis$PERCENTUAL_TODOS_TRI <- gestantes_florianopolis$GEST_TODOS_TRI/gestantes_florianopolis$GESTANTES *100
#Transformando em Tidy
gestantes_florianopolis <- melt(gestantes_florianopolis, id.var = c("TRIMESTRE"))
colnames(gestantes_florianopolis)[2:3] <- c("TIPO", "VALOR")



#Lendo as bases antigas
gestantes_esf_old <- read_csv("base_de_dados/transformadas/gestantes/gestantes_esf.csv", 
                              col_types = cols(VALOR = col_double()))
gestantes_cs_old <- read_csv("base_de_dados/transformadas/gestantes/gestantes_cs.csv", 
                             col_types = cols(VALOR = col_double()))
gestantes_distrito_old <- read_csv("base_de_dados/transformadas/gestantes/gestantes_distrito.csv", 
                                   col_types = cols(VALOR = col_double()))
gestantes_florianopolis_old <- read_csv("base_de_dados/transformadas/gestantes/gestantes_florianopolis.csv", 
                                        col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(gestantes_esf_old, "base_de_dados/transformadas/gestantes/gestantes_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_cs_old, "base_de_dados/transformadas/gestantes/gestantes_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_distrito_old, "base_de_dados/transformadas/gestantes/gestantes_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_florianopolis_old, "base_de_dados/transformadas/gestantes/gestantes_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
gestantes_esf_new <- rbind(gestantes_esf, gestantes_esf_old) 
gestantes_cs_new <- rbind( gestantes_cs, gestantes_cs_old) 
gestantes_distrito_new <- rbind(gestantes_distrito, gestantes_distrito_old) 
gestantes_florianopolis_new <- rbind(gestantes_florianopolis,gestantes_florianopolis_old) 


#Escrever bases atualizadas
write.csv(gestantes_esf_new, "base_de_dados/transformadas/gestantes/gestantes_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_cs_new, "base_de_dados/transformadas/gestantes/gestantes_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_distrito_new, "base_de_dados/transformadas/gestantes/gestantes_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(gestantes_florianopolis_new, "base_de_dados/transformadas/gestantes/gestantes_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)



