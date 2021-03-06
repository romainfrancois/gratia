##' Add fitted values from a model to a data frame
##'
##' @param data a data frame containing values for the variables used to fit the
##'   model. Passed to [stats::predict()] as `newdata`.
##' @param model a fitted model for which a [stats::predict()] method is
##'   available. S3 method dispatch is performed on the `model` argument.
##' @param value character; the name of the variable in which model predictions
##'   will be stored.
##' @param ... additional arguments passed to methods.
##'
##' @return A data frame (tibble) formed from `data` and fitted values from
##'   `model`.
##'
##' @export
`add_fitted` <- function(data, model, value = ".value", ...) {
    UseMethod("add_fitted", model)
}

##' Add fitted values from a GAM to a data frame
##' 
##' @param type character; the type of predictions to return. See
##'   [mgcv::predict.gam()] for options.
##' @param prefix character; string to prepend to names of predicted values when
##'   `type` is `"terms"`, `"iterms"`, `"lpmatrix"`. These prediction types result
##'   in a matrix of values being returned. `prefix` will be prepended to each of
##'   the names of columns returned by such prediction types.
##' @param ... additional arguments passed to [mgcv::predict.gam()].
##'
##' @return A data frame (tibble) formed from `data` and predictions from
##'   `model`.
##' 
##' @inheritParams add_fitted
##' 
##' @importFrom dplyr bind_cols
##' @importFrom stats predict
##' @importFrom rlang set_names !! :=
##' @importFrom tibble as_tibble add_column
##'
##' @export
##'
##' @examples
##'
##' load_mgcv()
##' set.seed(1)
##' df <- gamSim(eg = 1, verbose = FALSE)
##' df <- df[, c("y","x0","x1","x2","x3")]
##' m <-  gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = df, method = 'REML')
##'
##' ##
##' add_fitted(df, m)
##'
##' ## with type = "terms" or "iterms"
##' add_fitted(df, m, type = "terms")
`add_fitted.gam` <- function(data, model, value = ".value",
                             type = "response", prefix = ".",
                             ...) {
    ## coerce to tibble
    data <- as_tibble(data)
    
    ## predict using the predict method
    pred_vals <- predict(model, newdata = data, type = type, ...)

    ## check if pred_vals is a list
    if (is.list(pred_vals)) {
        pred_vals <- pred_vals[["fit"]]
    }

    ## having pruned off any standard errors, process the result
    if (is.array(pred_vals) && length(dim(pred_vals)) > 1L) {
        pred_vals <- as_tibble(pred_vals)
        pred_vals <- set_names(pred_vals, nm = paste0(prefix, names(pred_vals)))
        if (type %in% c("terms", "iterms")) {
            pred_vals <-
                add_column(pred_vals,
                           !!(paste0(prefix, "constant")) := coef(model)[1],
                           .before = 1L)
        }
        data <- bind_cols(data, pred_vals)
    } else {
        data <- add_column(data, !!value := drop(pred_vals),
                           .after = ncol(data))
    }

    data
}

##' Add residuals from a model to a data frame
##'
##' @param data a data frame containing values for the variables used to fit the
##'   model. Passed to [stats::residuals()] as `newdata`.
##' @param model a fitted model for which a [stats::residuals()] method is
##'   available. S3 method dispatch is performed on the `model` argument.
##' @param value character; the name of the variable in which model residuals
##'   will be stored.
##' @param ... additional arguments passed to methods.
##'
##' @return A data frame (tibble) formed from `data` and residuals from `model`.
##'
##' @export
`add_residuals` <- function(data, model, value = ".residual", ...) {
    UseMethod("add_residuals", model)
}

##' Add residuals from a GAM to a data frame
##' 
##' @param type character; the type of residuals to return. See
##'   [mgcv::residuals.gam()] for options.
##' @param ... additional arguments passed to [mgcv::residuals.gam()].
##'
##' @return A data frame (tibble) formed from `data` and residuals from `model`.
##' 
##' @inheritParams add_fitted
##' 
##' @importFrom dplyr bind_cols
##' @importFrom stats residuals
##' @importFrom rlang set_names !! :=
##' @importFrom tibble as_tibble add_column
##'
##' @export
##'
##' @examples
##'
##' load_mgcv()
##' set.seed(1)
##' df <- gamSim(eg = 1, verbose = FALSE)
##' df <- df[, c("y","x0","x1","x2","x3")]
##' m <-  gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = df, method = 'REML')
##'
##' ##
##' add_residuals(df, m)
`add_residuals.gam` <- function(data, model, value = ".residual",
                                type = "deviance", ...) {
    ## coerce to tibble
    data <- as_tibble(data)
    
    ## predict using the predict method
    resid_vals <- residuals(model, type = type, ...)

    ## check that the number of data rows equals length of residuals
    if (nrow(data) != length(resid_vals)) {
        stop("Length of model residuals does not equal number of rows in 'data'",
             call. = FALSE)
    }

    data <- add_column(data, !!value := drop(resid_vals), .after = ncol(data))

    data
}
