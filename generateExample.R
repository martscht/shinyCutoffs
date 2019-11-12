#### Code for the generation of lavaan example code ----

generateExample <- function(n_lv, n_ov, mod_type, mod_simple) {
  model <- NULL
  for (i in 1:n_lv) {
    model <- paste0(model, ifelse(i == 1, '# Factor loadings', ''),
      '\n',
      paste0('f', i, ' =~ ', paste0('y', i, 1:n_ov, collapse = ' + ')))
  }
  
  if (mod_type <= 2 & n_lv > 1) {
    for (i in 2:n_lv) {
      model <- paste0(model, '\n',
        ifelse(i == 2, '\n# Latent covariances\n', ''),
        paste0('f', i-1, ' ~~ ', 
          ifelse(mod_type == 2, '0*', ''), 
          'f', i))
    }
  }
  
  if (!mod_simple) {
    for (i in 1:n_lv) {
      model <- paste0(model, '\n',
        ifelse(i == 1, '\n# Latent variances\n', ''),
        paste0('f', i, ' ~~ ', 'f', i))
    }
    
    for (i in 1:n_lv) {
      model <- paste0(model, '\n',
        ifelse(i == 1, '\n# Residual variances\n', ''),
        paste0('y', i, 1:n_ov, ' ~~ ', 'y', i, 1:n_ov, collapse = '\n'))
    }
  }
  
  return(model)
}
