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
odonto_gestantes <- read_csv("base_de_dados/transformadas/odonto_gestantes/odont_gestantes_ajustada_utf8.csv")
odonto_gestantes$DATA <- as.yearmon(paste(odonto_gestantes$ANO, odonto_gestantes$MES), "%Y %m") #converntendo em formato date
odonto_gestantes$AREA <- as.character(odonto_gestantes$AREA)

#Transformando ano e mês em trimestre
odonto_gestantes$TRIMESTRE <- as.yearqtr(odonto_gestantes$DATA, format = "%d-%b-%y")
odonto_gestantes$TRIMESTRE <- as.character(odonto_gestantes$TRIMESTRE)
odonto_gestantes <- subset(odonto_gestantes, odonto_gestantes$TRIMESTRE != "2018 Q3")

############################################################
#Equipes
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
odonto_gestantes_esf<-odonto_gestantes[,c(1,2,5,8,9,11)]
odonto_gestantes_esf<-aggregate(odonto_gestantes_esf[,3:4], by = list(odonto_gestantes_esf$DISTRITO, odonto_gestantes_esf$UNIDADE,odonto_gestantes_esf$AREA, odonto_gestantes_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(odonto_gestantes_esf)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")
#Criando variável percentual de consultas
odonto_gestantes_esf$PERCENTUAL_GEST_ODONTO <- odonto_gestantes_esf$GEST_ODONTO/odonto_gestantes_esf$GESTANTES *100
#Transformando em Tidy
odonto_gestantes_esf <- melt(odonto_gestantes_esf, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(odonto_gestantes_esf)[5:6] <- c("TIPO", "VALOR")



############################################################
#CS
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
odonto_gestantes_cs<-odonto_gestantes[,c(1,2,5,8,9,11)]
odonto_gestantes_cs<-aggregate(odonto_gestantes_cs[,3:4], by = list(odonto_gestantes_cs$DISTRITO, odonto_gestantes_cs$UNIDADE, odonto_gestantes_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(odonto_gestantes_cs)[1:3] <- c("DISTRITO", "UNIDADE", "TRIMESTRE")
#Criando variável percentual de consultas
odonto_gestantes_cs$PERCENTUAL_GEST_ODONTO <- odonto_gestantes_cs$GEST_ODONTO/odonto_gestantes_cs$GESTANTES *100
#Transformando em Tidy
odonto_gestantes_cs <- melt(odonto_gestantes_cs, id.var = c("DISTRITO", "UNIDADE", "TRIMESTRE"))
colnames(odonto_gestantes_cs)[4:5] <- c("TIPO", "VALOR")


############################################################
#Distrito
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
odonto_gestantes_distrito<-odonto_gestantes[,c(1,2,5,8,9,11)]
odonto_gestantes_distrito<-aggregate(odonto_gestantes_distrito[,3:4], by = list(odonto_gestantes_distrito$DISTRITO, odonto_gestantes_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(odonto_gestantes_distrito)[1:2] <- c("DISTRITO", "TRIMESTRE")
#Criando variável percentual de consultas
odonto_gestantes_distrito$PERCENTUAL_GEST_ODONTO <- odonto_gestantes_distrito$GEST_ODONTO/odonto_gestantes_distrito$GESTANTES *100
#Transformando em Tidy
odonto_gestantes_distrito <- melt(odonto_gestantes_distrito, id.var = c("DISTRITO", "TRIMESTRE"))
colnames(odonto_gestantes_distrito)[3:4] <- c("TIPO", "VALOR")

############################################################
#Florianópolis
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
odonto_gestantes_florianopolis<-odonto_gestantes[,c(1,2,5,8,9,11)]
odonto_gestantes_florianopolis<-aggregate(odonto_gestantes_florianopolis[,3:4], by = list(odonto_gestantes_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(odonto_gestantes_florianopolis)[1] <- c("TRIMESTRE")
#Criando variável percentual de consultas
odonto_gestantes_florianopolis$PERCENTUAL_GEST_ODONTO <- odonto_gestantes_florianopolis$GEST_ODONTO/odonto_gestantes_florianopolis$GESTANTES *100
#Transformando em Tidy
odonto_gestantes_florianopolis <- melt(odonto_gestantes_florianopolis, id.var = c("TRIMESTRE"))
colnames(odonto_gestantes_florianopolis)[2:3] <- c("TIPO", "VALOR")


#Lendo as bases antigas
odonto_gestantes_esf_old <- read_csv("base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_esf.csv", 
                                     col_types = cols(VALOR = col_double()))
odonto_gestantes_cs_old <- read_csv("base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_cs.csv", 
                                    col_types = cols(VALOR = col_double()))
odonto_gestantes_distrito_old <- read_csv("base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_distrito.csv", 
                                          col_types = cols(VALOR = col_double()))
odonto_gestantes_florianopolis_old <- read_csv("base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_florianopolis.csv", 
                                               col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(odonto_gestantes_esf_old, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_cs_old, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_distrito_old, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_florianopolis_old, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
odonto_gestantes_esf_new <- rbind(odonto_gestantes_esf, odonto_gestantes_esf_old) 
odonto_gestantes_cs_new <- rbind( odonto_gestantes_cs, odonto_gestantes_cs_old) 
odonto_gestantes_distrito_new <- rbind(odonto_gestantes_distrito, odonto_gestantes_distrito_old) 
odonto_gestantes_florianopolis_new <- rbind(odonto_gestantes_florianopolis,odonto_gestantes_florianopolis_old) 


#Escrever bases atualizadas
write.csv(odonto_gestantes_esf_new, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_cs_new, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_distrito_new, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(odonto_gestantes_florianopolis_new, "base_de_dados/transformadas/odonto_gestantes/odonto_gestantes_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




                   
