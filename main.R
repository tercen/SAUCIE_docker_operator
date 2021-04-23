library(dplyr)
library(tercen)

do.saucie = function(data) {
  filename = tempfile()
  out.filename = tempfile()
  on.exit({
    if (file.exists(filename)){
      file.remove(filename);
    }
    if (file.exists(out.filename)){
      file.remove(out.filename);
    }
  })
  write.table(data, file = filename, col.names = FALSE, row.names = FALSE, quote = FALSE, sep="\t")
  cmd = paste('python3 main.py',
               filename,
               out.filename,
               sep = ' ')
  system(cmd)
  saucie.data = read.table(out.filename)
  colnames(saucie.data) = c('SAUCIE1', 'SAUCIE2', "cluster")
  return(saucie.data)
}

(ctx = tercenCtx())  %>% 
  as.matrix(fill=0) %>% 
  do.saucie() %>%
  as.data.frame() %>% 
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save() 