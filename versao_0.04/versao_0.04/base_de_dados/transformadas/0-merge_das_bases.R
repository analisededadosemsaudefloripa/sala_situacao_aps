library(readr)


#Importando base com dados antigos
atd_inad_upa <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/atd_inad_upa/atd_inad_upa.csv")
citopatalogico_pop <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/citopatologico/citopatologico.csv")
demanda_consulta <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/demanda_consulta/demanda_consulta.csv")
encs_med <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/encaminhamentos/encs_med.csv")
faltas <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/faltas/faltas.csv")
gestantes <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/gestantes/gestantes.csv")
odonto <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/odonto/odonto.csv")
pacientes_diferentes <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/pacientes_diferentes/pacientes_diferentes.csv")
proc_compl <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/proc_compl/proc_compl.csv")
sifilis <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/sifilis/sifilis.csv")
testes_rapidos <- read_csv("producao/base_de_dados/extraidas/bases_iniciais/testes_rapidos/testes_rapidos.csv")



#Importando base com dados novos
atd_inad_upa_novo <- read_csv("producao/base_de_dados/extraidas/atd_inad_upa.csv")
citopatalogico_pop_novo <- read_csv("producao/base_de_dados/extraidas/citopatalogico_pop.csv")
demanda_consulta_novo <- read_csv("producao/base_de_dados/extraidas/demanda_consulta.csv")
encs_med_novo <- read_csv("producao/base_de_dados/extraidas/encs_med.csv")
faltas_novo <- read_csv("producao/base_de_dados/extraidas/faltas.csv")
gestantes_novo <- read_csv("producao/base_de_dados/extraidas/gestantes.csv")
odonto_novo <- read_csv("producao/base_de_dados/extraidas/odonto.csv")
pacientes_diferentes_novo <- read_csv("producao/base_de_dados/extraidas/pacientes_diferentes.csv")
proc_compl_novo <- read_csv("producao/base_de_dados/extraidas/proc_compl.csv")
sifilis_novo <- read_csv("producao/base_de_dados/extraidas/sifilis.csv")
testes_rapidos_novo <- read_csv("producao/base_de_dados/extraidas/testes_rapidos.csv")




#Fazendo merge das bases
atd_inad_upa <- rbind(atd_inad_upa, atd_inad_upa_novo)
citopatalogico_pop  <- rbind(citopatalogico_pop, citopatalogico_pop_novo)
demanda_consulta  <- rbind(demanda_consulta, demanda_consulta_novo)
encs_med  <- rbind(encs_med,encs_med_novo)
faltas  <- rbind(faltas,faltas_novo)
gestantes  <- rbind(gestantes,gestantes_novo)
odonto  <- rbind(odonto,odonto_novo)
pacientes_diferentes  <- rbind(pacientes_diferentes,pacientes_diferentes_novo)
proc_compl  <- rbind(proc_compl,proc_compl_novo)
sifilis  <- rbind(sifilis,sifilis_novo)
testes_rapidos  <- rbind(testes_rapidos,testes_rapidos_novo)






#Escrevendo as bases atuais
atd_inad_upa <- write.csv(atd_inad_upa, "producao/base_de_dados/extraidas/bases_iniciais/atd_inad_upa/atd_inad_upa.csv", fileEncoding = "UTF-8")
#citopatalogico_pop <- write.csv(citopatalogico_pop, "producao/base_de_dados/extraidas/bases_iniciais/citopatologico/citopatologico.csv", fileEncoding = "UTF-8")
demanda_consulta <- write.csv(demanda_consulta, "producao/base_de_dados/extraidas/bases_iniciais/demanda_consulta/demanda_consulta.csv", fileEncoding = "UTF-8")
#retirar completo#encs_med <- write.csv(encs_med, "producao/base_de_dados/extraidas/bases_iniciais/encaminhamentos/encs_med.csv", fileEncoding = "UTF-8")
faltas <- write.csv(faltas, "producao/base_de_dados/extraidas/bases_iniciais/faltas/faltas.csv", fileEncoding = "UTF-8")
gestantes <- write.csv(gestantes, "producao/base_de_dados/extraidas/bases_iniciais/gestantes/gestantes.csv", fileEncoding = "UTF-8")
odonto <- write.csv(odonto, "producao/base_de_dados/extraidas/bases_iniciais/odonto/odonto.csv", fileEncoding = "UTF-8")
pacientes_diferentes <- write.csv(pacientes_diferentes, "producao/base_de_dados/extraidas/bases_iniciais/pacientes_diferentes/pacientes_diferentes.csv", fileEncoding = "UTF-8")
proc_compl <- write.csv(proc_compl, "producao/base_de_dados/extraidas/bases_iniciais/proc_compl/proc_compl.csv", fileEncoding = "UTF-8")
sifilis <- write.csv(sifilis, "producao/base_de_dados/extraidas/bases_iniciais/sifilis/sifilis.csv", fileEncoding = "UTF-8")
#retirar completo#testes_rapidos <- write.csv(testes_rapidos, "producao/base_de_dados/extraidas/bases_iniciais/testes_rapidos/testes_rapidos.csv", fileEncoding = "UTF-8")

