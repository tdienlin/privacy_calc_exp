library(tidyverse)

set.seed(42)

results <- tibble(
  iteration = c(),
  raw_cor = c(),
  raw_p = c(),
  div_cor = c(),
  div_p = c()
)

for (run in 1:1e4){
  dat <- 
    tibble(
      pp = 1:323,
      estimated = rnorm(323),
      actual = rnorm(323),
      divergence = abs(actual - estimated)
    )
  
  raw_correlation <- with(dat, cor.test(actual, estimated))
  
  divergence_correlation <- with(dat, cor.test(actual, divergence))
  
  run_results <- 
    tibble(
      iteration = run,
      raw_cor = raw_correlation$estimate,
      raw_p = raw_correlation$p.value,
      div_cor = divergence_correlation$estimate,
      div_p = divergence_correlation$p.value
    )
  
  results <- 
    bind_rows(
      results,
      run_results
    )
}

mean(results$div_p < .05)
mean(results$raw_p < .05)