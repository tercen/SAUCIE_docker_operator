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
  write.filename = file(filename, "wb")
  writeBin(as.vector(data), write.filename, size=4)
  close(write.filename)
  cmd = paste('python3 main.py',
               filename,
               out.filename,
               sep = ' ')
  args = paste(filename,
               out.filename,
               sep = ' ')
  system2(cmd, args)
  read.filename = file(out.filename, "rb")
  saucie.data = readBin(read.filename, double(), size=4, n = 2*ncol(data))
  close(read.filename)
  saucie.matrix = matrix(saucie.data, nrow = ncol(data), ncol = 3, byrow = TRUE)
  colnames(saucie.matrix) = c('SAUCIE1', 'SAUCIE2', "cluster")
  return(saucie.data)
}

ctx = tercenCtx()
ctx  %>% 
  as.matrix(fill=0) %>% 
  do.saucie() %>%
  as.data.frame() %>% 
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save() 
