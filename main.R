library(dplyr)
library(tercen)

do.saucie = function(data, lambda_b, lambda_c, lambda_d) {
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
  cmd = paste('python',
              sep = ' ')
  args = paste('main.py',
               filename,
               out.filename,
               lambda_b,
               lambda_c,
               lambda_d,
               sep = ' ')
  system2(cmd, args)
  read.filename = file(out.filename, "rt")
  saucie.data = read.table(read.filename)
  close(read.filename)
  colnames(saucie.data) = c('SAUCIE1', 'SAUCIE2', "cluster_id")
  saucie.data$cluster_id <- as.character(saucie.data$cluster_id)
  return(saucie.data)
}

ctx = tercenCtx()

lambda_b <- ifelse(
  is.null(ctx$op.value("lambda_b")),
  0.0,
  as.numeric(ctx$op.value("lambda_b"))
)
lambda_c <- ifelse(
  is.null(ctx$op.value("lambda_c")),
  0.0,
  as.numeric(ctx$op.value("lambda_c"))
)
lambda_d <- ifelse(
  is.null(ctx$op.value("lambda_d")),
  0.0,
  as.numeric(ctx$op.value("lambda_d"))
)

df <- ctx  %>% 
  as.matrix(fill = 0) %>% 
  t() %>%
  do.saucie(., lambda_b, lambda_c, lambda_d) %>%
  as.data.frame() %>% 
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save() 
