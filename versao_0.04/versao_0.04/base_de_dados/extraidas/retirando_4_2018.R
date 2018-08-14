library(readr)
atd_inad_upa <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/atd_inad_upa.csv")
citopatalogico <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/citopatalogico.csv")
citopatalogico_pop <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/citopatalogico_pop.csv")
demanda_consulta <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/demanda_consulta.csv")
encs_med <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/encs_med.csv")
faltas <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/faltas.csv")
gestantes <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/gestantes.csv")
odonto <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/odonto.csv")
pacientes_diferentes <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/pacientes_diferentes.csv")
proc_compl <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/proc_compl.csv")
sifilis <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/sifilis.csv")
testes_rapidos <- read_csv("C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/testes_rapidos.csv")



#Retirando mês e ano = 4/2018
atd_inad_upa <- subset(atd_inad_upa, atd_inad_upa$MES != "4")
citopatalogico$MES_ANO <- paste(citopatalogico$MES, citopatalogico$ANO)
citopatalogico <- subset(citopatalogico, citopatalogico$MES_ANO != "4 2018")
citopatalogico <- citopatalogico[,-7]
citopatalogico_pop$MES_ANO <- paste(citopatalogico_pop$MES, citopatalogico_pop$ANO)
citopatalogico_pop <- subset(citopatalogico_pop, citopatalogico_pop$MES_ANO != "4 2018")
citopatalogico_pop <- citopatalogico_pop[,-7]
demanda_consulta <- subset(demanda_consulta, demanda_consulta$MES != "4")
encs_med <- subset(encs_med, encs_med$MES != "4")
faltas$MES_ANO <- paste0(faltas$MES, "_", faltas$ANO)
faltas <- subset(faltas, faltas$MES_ANO != "4_2018")
gestantes <- subset(gestantes, gestantes$MES != "4")
odonto <- subset(odonto, odonto$MES != "4")
pacientes_diferentes$MES_ANO <- paste0(pacientes_diferentes$MES, "_", pacientes_diferentes$ANO)
pacientes_diferentes <- subset(pacientes_diferentes, pacientes_diferentes$MES_ANO != "4_2018")
sifilis <- subset(sifilis, sifilis$MES != "4")
testes_rapidos$MES_ANO <- paste(testes_rapidos$MES, testes_rapidos$ANO)
testes_rapidos <- subset(testes_rapidos, testes_rapidos$MES_ANO != "4 2018")
testes_rapidos <- testes_rapidos[,-8]
proc_compl$MES_ANO <- paste(proc_compl$MES, proc_compl$ANO)
proc_compl <- subset(proc_compl, proc_compl$MES_ANO != "4 2018")
proc_compl <- proc_compl[,-15]


#gravando bases
atd_inad_upa <- write.csv(atd_inad_upa, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/atd_inad_upa.csv", fileEncoding = "UTF-8")
citopatalogico <- write.csv(citopatalogico, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/citopatalogico.csv", fileEncoding = "UTF-8")
citopatalogico_pop <- write.csv(citopatalogico_pop, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/citopatalogico_pop.csv", fileEncoding = "UTF-8")
demanda_consulta <- write.csv(demanda_consulta, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/demanda_consulta.csv", fileEncoding = "UTF-8")
encs_med <- write.csv(encs_med, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/encs_med.csv", fileEncoding = "UTF-8")
faltas <- write.csv(faltas, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/faltas.csv", fileEncoding = "UTF-8")
gestantes <- write.csv(gestantes, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/gestantes.csv", fileEncoding = "UTF-8")
odonto <- write.csv(odonto, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/odonto.csv", fileEncoding = "UTF-8")
pacientes_diferentes <- write.csv(pacientes_diferentes, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/pacientes_diferentes.csv", fileEncoding = "UTF-8")
sifilis <- write.csv(sifilis, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/sifilis.csv", fileEncoding = "UTF-8")
testes_rapidos <- write.csv(testes_rapidos, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/testes_rapidos.csv", fileEncoding = "UTF-8")
proc_compl <- write.csv(proc_compl, "C:/Users/hp1806/Google Drive/RStudio/sala_situacao_aps/versoes/producao/producao/base_de_dados/extraidas/proc_compl.csv", fileEncoding = "UTF-8")
