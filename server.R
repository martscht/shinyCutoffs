#### Server Side of shinyCutoffs ----
library(shiny)
library(ezCutoffs)
library(semPlot)
library(lavaan)

# Outsourced generation of lavaan examples
source('generateExample.R')


server <- function(input, output, session) {
  
  # Generate lavaan example model
  observeEvent(input$example, 
    updateTextAreaInput(session, "model", 
      value = generateExample(input$n_lv, input$n_ov, input$mod_type, input$mod_simple))
  )
  
  dats <- NULL
  observeEvent(input$upload, {
    dats <- try(readRDS(input$data$datapath), silent = TRUE)
    if (class(dats)!="try-error") {
      updateNumericInput(session, "n_obs", value = nrow(dats))
      shinyjs::disable("n_obs")
      var_names <- matrix(names(dats), ncol = 4, byrow = TRUE)
      output$var_names_head <- renderText(paste0("Names of observed variables in your data set."))
      output$var_names <- renderTable(var_names, colnames = FALSE)
    }
  }
  )
  
  output$path <- renderPlot({
    tmp_fit <- try(lavaan::sem(input$model, do.fit = FALSE), silent = TRUE)
    if (class(tmp_fit) != "try-error") semPlot::semPaths(tmp_fit, what = "std)
  })
 
  observeEvent(input$run, {
    # sanity check
    sane <- TRUE
    
    if (is.null(dats)) {
      if (input$n_obs <= 0) {
        sane <- FALSE
        output$sanity <- renderText(paste0("Please set a positive value for the number of observations or provide a dataset."))
      }
    }
    
    if (sane) {
      shinyjs::hide("sanity")
      shinyjs::hide("summy")
      shinyjs::show("running")
      output$running <- renderText(paste("Running simulation with", input$n_rep, "replications."))
      normy <- ifelse(input$skew, "empirical", "assumed")
      missy <- ifelse(input$missing, "missing", "complete")
      res <- suppressMessages(ezCutoffs::ezCutoffs(
        model = input$model,
        data = dats,
        n_obs = input$n_obs,
        n_rep = input$n_rep,
        fit_indices = input$fit_indices,
        alpha_level = input$alpha_level,
        normality = normy,
        missing_data = missy,
        bootstrapped_ci = FALSE,
        n_boot = 1000,
        boot_alpha = 0.05,
        boot_internal = FALSE,
        n_cores = input$n_cores))
      output$summy <- renderTable(summary(res), rownames = TRUE)
      shinyjs::hide("running")
      shinyjs::show("summy")
    }
  }
  )
   
}
