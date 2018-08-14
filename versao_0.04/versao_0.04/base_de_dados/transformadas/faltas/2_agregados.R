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
faltas <- read_csv("base_de_dados/transformadas/faltas/faltas_ajustada_utf8.csv")
faltas$DATA <- as.yearmon(paste(faltas$ANO, faltas$MES), "%Y %m") #converntendo em formato date
faltas$AREA <- as.character(faltas$AREA)

#Transformando ano e mês em trimestre
faltas$TRIMESTRE <- as.yearqtr(faltas$DATA, format = "%d-%b-%y")
faltas$TRIMESTRE <- as.character(faltas$TRIMESTRE)
faltas <- subset(faltas, faltas$TRIMESTRE != "2018 Q3")

############################################################
#Equipes
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
faltas_esf<-faltas[,c(1,2,5:11,13)]
faltas_esf<-aggregate(faltas_esf[,3:8], by = list(faltas_esf$DISTRITO, faltas_esf$UNIDADE,faltas_esf$AREA, faltas_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(faltas_esf)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")
#Criando variável percentual de faltas
faltas_esf$PERCENTUAL_FALTAS_ODONTO <- faltas_esf$FALTAS_ODO/faltas_esf$CONS_ODO *100
faltas_esf$PERCENTUAL_FALTAS_ENF <- faltas_esf$FALTAS_ENF/faltas_esf$CONS_ENF *100
faltas_esf$PERCENTUAL_FALTAS_MED <- faltas_esf$FALTAS_MED/faltas_esf$CONS_MED *100
faltas_esf <- faltas_esf[,-c(5:10)]
#Transformando em Tidy
faltas_esf <- melt(faltas_esf, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(faltas_esf)[5:6] <- c("TIPO", "VALOR")




############################################################
#CS
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
faltas_cs<-faltas[,c(1,2,5:10,13)]
faltas_cs<-aggregate(faltas_cs[,3:8], by = list(faltas_cs$DISTRITO, faltas_cs$UNIDADE, faltas_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(faltas_cs)[1:3] <- c("DISTRITO", "UNIDADE", "TRIMESTRE")
#Criando variável percentual de faltas
faltas_cs$PERCENTUAL_FALTAS_ODONTO <- faltas_cs$FALTAS_ODO/faltas_cs$CONS_ODO *100
faltas_cs$PERCENTUAL_FALTAS_ENF <- faltas_cs$FALTAS_ENF/faltas_cs$CONS_ENF *100
faltas_cs$PERCENTUAL_FALTAS_MED <- faltas_cs$FALTAS_MED/faltas_cs$CONS_MED *100
faltas_cs <- faltas_cs[,-c(4:9)]
#Transformando em Tidy
faltas_cs <- melt(faltas_cs, id.var = c("DISTRITO", "UNIDADE", "TRIMESTRE"))
colnames(faltas_cs)[4:5] <- c("TIPO", "VALOR")


############################################################
#Distrito
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
faltas_distrito<-faltas[,c(1,5:10,13)]
faltas_distrito<-aggregate(faltas_distrito[,2:7], by = list(faltas_distrito$DISTRITO, faltas_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(faltas_distrito)[1:2] <- c("DISTRITO", "TRIMESTRE")
#Criando variável percentual de faltas
faltas_distrito$PERCENTUAL_FALTAS_ODONTO <- faltas_distrito$FALTAS_ODO/faltas_distrito$CONS_ODO *100
faltas_distrito$PERCENTUAL_FALTAS_ENF <- faltas_distrito$FALTAS_ENF/faltas_distrito$CONS_ENF *100
faltas_distrito$PERCENTUAL_FALTAS_MED <- faltas_distrito$FALTAS_MED/faltas_distrito$CONS_MED *100
faltas_distrito <- faltas_distrito[,-c(3:8)]
#Transformando em Tidy
faltas_distrito <- melt(faltas_distrito, id.var = c("DISTRITO", "TRIMESTRE"))
colnames(faltas_distrito)[3:4] <- c("TIPO", "VALOR")

############################################################
#Florianópolis
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
faltas_florianopolis<-faltas[,c(5:10,13)]
faltas_florianopolis<-aggregate(faltas_florianopolis[,1:6], by = list(faltas_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(faltas_florianopolis)[1] <- c("TRIMESTRE")
#Criando variável percentual de faltas
faltas_florianopolis$PERCENTUAL_FALTAS_ODONTO <- faltas_florianopolis$FALTAS_ODO/faltas_florianopolis$CONS_ODO *100
faltas_florianopolis$PERCENTUAL_FALTAS_ENF <- faltas_florianopolis$FALTAS_ENF/faltas_florianopolis$CONS_ENF *100
faltas_florianopolis$PERCENTUAL_FALTAS_MED <- faltas_florianopolis$FALTAS_MED/faltas_florianopolis$CONS_MED *100
faltas_florianopolis <- faltas_florianopolis[,-c(2:7)]
#Transformando em Tidy
faltas_florianopolis <- melt(faltas_florianopolis, id.var = c("TRIMESTRE"))
colnames(faltas_florianopolis)[2:3] <- c("TIPO", "VALOR")



#Lendo as bases antigas
faltas_esf_old <- read_csv("base_de_dados/transformadas/faltas/faltas_esf.csv", 
                           col_types = cols(VALOR = col_double()))
faltas_cs_old <- read_csv("base_de_dados/transformadas/faltas/faltas_cs.csv", 
                          col_types = cols(VALOR = col_double()))
faltas_distrito_old <- read_csv("base_de_dados/transformadas/faltas/faltas_distrito.csv", 
                                col_types = cols(VALOR = col_double()))
faltas_florianopolis_old <- read_csv("base_de_dados/transformadas/faltas/faltas_florianopolis.csv", 
                                     col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(faltas_esf_old, "base_de_dados/transformadas/faltas/faltas_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_cs_old, "base_de_dados/transformadas/faltas/faltas_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_distrito_old, "base_de_dados/transformadas/faltas/faltas_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_florianopolis_old, "base_de_dados/transformadas/faltas/faltas_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
faltas_esf_new <- rbind(faltas_esf, faltas_esf_old) 
faltas_cs_new <- rbind( faltas_cs, faltas_cs_old) 
faltas_distrito_new <- rbind(faltas_distrito, faltas_distrito_old) 
faltas_florianopolis_new <- rbind(faltas_florianopolis,faltas_florianopolis_old) 


#Escrever bases atualizadas
write.csv(faltas_esf_new, "base_de_dados/transformadas/faltas/faltas_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_cs_new, "base_de_dados/transformadas/faltas/faltas_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_distrito_new, "base_de_dados/transformadas/faltas/faltas_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(faltas_florianopolis_new, "base_de_dados/transformadas/faltas/faltas_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




                   
