# pacotes r community-sourced
pacotes <- c("readr", "data.table", "dplyr", "ggplot2","ggthemes","stringr","devtools", "lubridate")

lapply(pacotes, function(x){
  if(!require(x, character.only = TRUE)){
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

# pacotes git-hub
devtools::install_github("danicat/read.dbc",force = T)
library("read.dbc")

# get data
data.raw.lista <- list.files(path = '../data',recursive = T,full.names = T)

data.raw <- rbindlist(
  lapply(data.raw.lista,
         function(x){
  a = read.dbc(x) %>% setDT()
  b = a[,.(DTOBITO,IDADE,SEXO,CODMUNRES,CAUSABAS)]
  b
})
)


data.raw <- unique(data.raw) %>%
  .[,id:=1] %>%
  .[,idx := cumsum(id)]

saveRDS(data.raw,file = '../rdata/obitos.rds')


# produz relatorio de entrada
rmarkdown::render(input = './script/Agressoes.Rmd',
                  output_file = paste0('Agressoes_',Sys.Date(),'.nb.html'),
                  output_dir = './report')

# apaga arquivos temporarios
unlink('./*/*_files',recursive = T)
unlink('./*/*_cache',recursive = T)