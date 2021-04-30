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
  write.filename = file(filename, "wt")
  write.table(data,col.names = FALSE, row.names = FALSE, quote = FALSE, write.filename)
  close(write.filename)
  cmd = paste('python3',
              sep = ' ')
  args = paste('main.py',
               filename,
               out.filename,
               sep = ' ')
  system2(cmd, args)
  read.filename = file(out.filename, "rt")
  saucie.data = readBin(read.filename, double(), size=4, n = 2*ncol(data))
  close(read.filename)
  saucie.matrix = matrix(saucie.data, nrow = ncol(data), ncol = 3, byrow = TRUE)
  colnames(saucie.matrix) = c('SAUCIE1', 'SAUCIE2', "cluster")
  return(saucie.data)
}

ctx = tercenCtx()
df <- ctx  %>% 
  as.matrix(fill=0) %>% 
  do.saucie() %>%
  as.data.frame() %>% 
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save() 
