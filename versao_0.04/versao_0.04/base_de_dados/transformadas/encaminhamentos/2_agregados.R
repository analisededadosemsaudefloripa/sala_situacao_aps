setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
encam_med <- read_csv("base_de_dados/transformadas/encaminhamentos/encs_med_ajustada_utf8.csv")
encam_med$DATA <- as.yearmon(paste(encam_med$ANO, encam_med$MES), "%Y %m") #converntendo em formato date
encam_med$AREA <- as.character(encam_med$AREA)



#Transformando mês em trimestre
encam_med$TRIMESTRE <- as.yearqtr(encam_med$DATA, format = "%d-%b-%y")
encam_med$TRIMESTRE <- as.character(encam_med$TRIMESTRE)
encam_med <- subset(encam_med, encam_med$TRIMESTRE != "2018 Q3")

encam_med <- encam_med[,-c(3,4,10)] #Retirando as colunas de ANO, MÊS, DATA

#Contar por área e TRIMESTRE
encam_med_esf<-encam_med
encam_med_esf<-aggregate(encam_med_esf[,c(3:6)], by = encam_med_esf[,c(1,2,7,8)], FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
#Calculando a porcentagem de encaminhamentos
encam_med_esf$PORCENT_ENCAMINHAMENTOS_MED <- round(encam_med_esf$ENCS_MED/encam_med_esf$CONSULTA_MED *100, 2)
encam_med_esf$PORCENT_ENCAMINHAMENTOS_ODO <- round(encam_med_esf$ENCS_ODO/encam_med_esf$CONSULTA_ODO *100, 2)
#Transformando em tidy
encam_med_esf <- melt(encam_med_esf, id.vars = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"), measure.vars = c("CONSULTA_MED", "CONSULTA_ODO","ENCS_MED","ENCS_ODO",
                                            "PORCENT_ENCAMINHAMENTOS_MED","PORCENT_ENCAMINHAMENTOS_ODO"))
colnames(encam_med_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE","TIPO", "VALOR")

#Contar por centro de saúde e TRIMESTRE
encam_med_cs<-encam_med
encam_med_cs<-aggregate(encam_med_cs[,c(3:6)], by = encam_med_cs[,c(1,2,8)], FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
#Calculando a porcentagem de encaminhamentos
encam_med_cs$PORCENT_ENCAMINHAMENTOS_MED <- round(encam_med_cs$ENCS_MED/encam_med_cs$CONSULTA_MED *100, 2)
encam_med_cs$PORCENT_ENCAMINHAMENTOS_ODO <- round(encam_med_cs$ENCS_ODO/encam_med_cs$CONSULTA_ODO *100, 2)
#Transformando em tidy
encam_med_cs <- melt(encam_med_cs, id.vars = c("DISTRITO", "UNIDADE", "TRIMESTRE"), measure.vars = c("CONSULTA_MED", "CONSULTA_ODO","ENCS_MED","ENCS_ODO",
                                            "PORCENT_ENCAMINHAMENTOS_MED","PORCENT_ENCAMINHAMENTOS_ODO"))
colnames(encam_med_cs) <- c("DISTRITO", "UNIDADE",  "TRIMESTRE","TIPO", "VALOR")





#Contar por distrito e TRIMESTRE
encam_med_distrito<-encam_med
encam_med_distrito<-aggregate(encam_med_distrito[,c(3:6)], by = encam_med_distrito[,c(1,8)], FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
#Calculando a porcentagem de encaminhamentos
encam_med_distrito$PORCENT_ENCAMINHAMENTOS_MED <- round(encam_med_distrito$ENCS_MED/encam_med_distrito$CONSULTA_MED *100, 2)
encam_med_distrito$PORCENT_ENCAMINHAMENTOS_ODO <- round(encam_med_distrito$ENCS_ODO/encam_med_distrito$CONSULTA_ODO *100, 2)
#Transformando em tidy
encam_med_distrito <- melt(encam_med_distrito, id.vars = c("DISTRITO", "TRIMESTRE"), measure.vars = c("CONSULTA_MED", "CONSULTA_ODO","ENCS_MED","ENCS_ODO",
                                            "PORCENT_ENCAMINHAMENTOS_MED","PORCENT_ENCAMINHAMENTOS_ODO"))
colnames(encam_med_distrito) <- c("DISTRITO", "TRIMESTRE","TIPO", "VALOR")




#Contar por Florianópolis e TRIMESTRE
encam_med_florianopolis<-encam_med
encam_med_florianopolis<-aggregate(encam_med_florianopolis[,c(3:6)], by = encam_med_florianopolis[,c(8)], FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
#Calculando a porcentagem de encaminhamentos
encam_med_florianopolis$PORCENT_ENCAMINHAMENTOS_MED <- round(encam_med_florianopolis$ENCS_MED/encam_med_florianopolis$CONSULTA_MED *100, 2)
encam_med_florianopolis$PORCENT_ENCAMINHAMENTOS_ODO <- round(encam_med_florianopolis$ENCS_ODO/encam_med_florianopolis$CONSULTA_ODO *100, 2)
#Transformando em tidy
encam_med_florianopolis <- melt(encam_med_florianopolis, id.vars = c("TRIMESTRE"), measure.vars = c("CONSULTA_MED", "CONSULTA_ODO","ENCS_MED","ENCS_ODO",
                                            "PORCENT_ENCAMINHAMENTOS_MED","PORCENT_ENCAMINHAMENTOS_ODO"))
colnames(encam_med_florianopolis) <- c("TRIMESTRE","TIPO", "VALOR")


#Lendo as bases antigas
encam_med_esf_old <- read_csv("base_de_dados/transformadas/encaminhamentos/encam_med_esf.csv", 
                              col_types = cols(VALOR = col_double()))
encam_med_cs_old <- read_csv("base_de_dados/transformadas/encaminhamentos/encam_med_cs.csv", 
                             col_types = cols(VALOR = col_double()))
encam_med_distrito_old <- read_csv("base_de_dados/transformadas/encaminhamentos/encam_med_distrito.csv", 
                                   col_types = cols(VALOR = col_double()))
encam_med_florianopolis_old <- read_csv("base_de_dados/transformadas/encaminhamentos/encam_med_florianopolis.csv", 
                                        col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(encam_med_esf_old, "base_de_dados/transformadas/encaminhamentos/encam_med_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_cs_old, "base_de_dados/transformadas/encaminhamentos/encam_med_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_distrito_old, "base_de_dados/transformadas/encaminhamentos/encam_med_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_florianopolis_old, "base_de_dados/transformadas/encaminhamentos/encam_med_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
encam_med_esf_new <- rbind(encam_med_esf, encam_med_esf_old) 
encam_med_cs_new <- rbind( encam_med_cs, encam_med_cs_old) 
encam_med_distrito_new <- rbind(encam_med_distrito, encam_med_distrito_old) 
encam_med_florianopolis_new <- rbind(encam_med_florianopolis,encam_med_florianopolis_old) 


#Escrever bases atualizadas
write.csv(encam_med_esf_new, "base_de_dados/transformadas/encaminhamentos/encam_med_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_cs_new, "base_de_dados/transformadas/encaminhamentos/encam_med_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_distrito_new, "base_de_dados/transformadas/encaminhamentos/encam_med_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(encam_med_florianopolis_new, "base_de_dados/transformadas/encaminhamentos/encam_med_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




                   
