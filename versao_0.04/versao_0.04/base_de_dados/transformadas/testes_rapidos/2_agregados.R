setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
testes_rapidos <- read_csv("base_de_dados/transformadas/testes_rapidos/testes_rapidos_ajustada_utf8.csv")
testes_rapidos$DATA <- as.yearmon(paste(testes_rapidos$ANO, testes_rapidos$MES), "%Y %m") #converntendo em formato date
testes_rapidos$AREA <- as.character(testes_rapidos$AREA)

#Transformando ano e mês em trimestre
testes_rapidos$TRIMESTRE <- as.yearqtr(testes_rapidos$DATA, format = "%d-%b-%y")
testes_rapidos$TRIMESTRE <- as.character(testes_rapidos$TRIMESTRE)

#Substituindo QTDE por QUANTIDADE E NM_PROC por PROCEDIMENTO
colnames(testes_rapidos)[6] <- "QUANTIDADE"
colnames(testes_rapidos)[5] <- "PROCEDIMENTO"

#Códigos de procedimentos
#0214010040 = TESTE RAPIDO PARA DETECÇAO DE HIV EM GESTANTE
#0214010058 = TESTE RAPIDO PARA DETECÇÃO DE INFECÇÃO PELO HIV
#0214010074 = TESTE RÁPIDO PARA SÍFILIS
#0214010082 = TESTE RÁPIDO PARA SÍFILIS EM GESTANTE
#0214010090 = TESTE RÁPIDO PARA DETECÇÃO DE HEPATITE C
#0214010104 = TESTE RÁPIDO PARA DETECÇÃO DE INFECÇÃO PELO HBV

#Unindo testes de gestantes com testes de não gestantes e substituindo o número pelo nome do procedimento
testes_rapidos$NM_PROCEDIMENTO <- NA
for(i in 1:nrow(testes_rapidos)){
      if(testes_rapidos$PROCEDIMENTO[i] == "0214010040" |testes_rapidos$PROCEDIMENTO[i] == "0214010058"){
           testes_rapidos$NM_PROCEDIMENTO[i] <- "TESTE RÁPIDO PARA DETECÇÃO DE INFECÇÃO PELO HIV"
      }else if(testes_rapidos$PROCEDIMENTO[i] == "0214010074" |testes_rapidos$PROCEDIMENTO[i] == "0214010082"){
           testes_rapidos$NM_PROCEDIMENTO[i] <- "TESTE RÁPIDO PARA SÍFILIS"    
      }else if(testes_rapidos$PROCEDIMENTO[i] == "0214010090"){
           testes_rapidos$NM_PROCEDIMENTO[i] <- "TESTE RÁPIDO PARA DETECÇÃO DE HEPATITE C"
      }else{
           testes_rapidos$NM_PROCEDIMENTO[i] <- "TESTE RÁPIDO PARA DETECÇÃO DE INFECÇÃO PELO HBV"
      }
}

#Retirando coluna do código do proce e renomeando a de nome do processo
testes_rapidos <- testes_rapidos[,-5]
colnames(testes_rapidos)[9] <- "PROCEDIMENTO"


############################################################
#Equipes
############################################################
testes_rapidos_esf<-testes_rapidos[,c(1,2,5,6,8,9)]
testes_rapidos_esf<-aggregate(testes_rapidos_esf$QUANTIDADE, by = list(testes_rapidos_esf$DISTRITO, testes_rapidos_esf$UNIDADE,testes_rapidos_esf$AREA, testes_rapidos_esf$TRIMESTRE, testes_rapidos_esf$PROCEDIMENTO), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(testes_rapidos_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE","PROCEDIMENTO", "VALOR")
testes_rapidos_esf[,is.na(testes_rapidos_esf$VALOR)] <- 0


############################################################
#CS
############################################################
testes_rapidos_cs<-testes_rapidos[,c(1,2,5,8,9)]
testes_rapidos_cs<-aggregate(testes_rapidos_cs$QUANTIDADE, by = list(testes_rapidos_cs$DISTRITO, testes_rapidos_cs$UNIDADE, testes_rapidos_cs$TRIMESTRE, testes_rapidos_cs$PROCEDIMENTO), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(testes_rapidos_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "PROCEDIMENTO", "VALOR")
testes_rapidos_cs[,is.na(testes_rapidos_cs$VALOR)] <- 0

############################################################
#Distrito
############################################################
testes_rapidos_distrito<-testes_rapidos[,c(1,5,8,9)]
testes_rapidos_distrito<-aggregate(testes_rapidos_distrito$QUANTIDADE, by = list(testes_rapidos_distrito$DISTRITO, testes_rapidos_distrito$TRIMESTRE, testes_rapidos_distrito$PROCEDIMENTO), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(testes_rapidos_distrito) <- c("DISTRITO", "TRIMESTRE", "PROCEDIMENTO", "VALOR")
testes_rapidos_distrito[,is.na(testes_rapidos_distrito$VALOR)] <- 0

############################################################
#Florianópolis
############################################################
testes_rapidos_florianopolis<-testes_rapidos[,c(5,8,9)]
testes_rapidos_florianopolis<-aggregate(testes_rapidos_florianopolis$QUANTIDADE, by = list( testes_rapidos_florianopolis$TRIMESTRE, testes_rapidos_florianopolis$PROCEDIMENTO), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(testes_rapidos_florianopolis) <- c("TRIMESTRE", "PROCEDIMENTO", "VALOR")
testes_rapidos_florianopolis[,is.na(testes_rapidos_florianopolis$VALOR)] <- 0


#Lendo as bases antigas
testes_rapidos_esf_old <- read_csv("base_de_dados/transformadas/testes_rapidos/testes_rapidos_esf.csv", 
                                   col_types = cols(VALOR = col_double()))
testes_rapidos_cs_old <- read_csv("base_de_dados/transformadas/testes_rapidos/testes_rapidos_cs.csv", 
                                  col_types = cols(VALOR = col_double()))
testes_rapidos_distrito_old <- read_csv("base_de_dados/transformadas/testes_rapidos/testes_rapidos_distrito.csv", 
                                        col_types = cols(VALOR = col_double()))
testes_rapidos_florianopolis_old <- read_csv("base_de_dados/transformadas/testes_rapidos/testes_rapidos_florianopolis.csv", 
                                             col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(testes_rapidos_esf_old, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_cs_old, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_distrito_old, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_florianopolis_old, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
testes_rapidos_esf_new <- rbind(testes_rapidos_esf, testes_rapidos_esf_old) 
testes_rapidos_cs_new <- rbind( testes_rapidos_cs, testes_rapidos_cs_old) 
testes_rapidos_distrito_new <- rbind(testes_rapidos_distrito, testes_rapidos_distrito_old) 
testes_rapidos_florianopolis_new <- rbind(testes_rapidos_florianopolis,testes_rapidos_florianopolis_old) 


#Escrever bases atualizadas
write.csv(testes_rapidos_esf_new, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_cs_new, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_distrito_new, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(testes_rapidos_florianopolis_new, "base_de_dados/transformadas/testes_rapidos/testes_rapidos_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)





                   
