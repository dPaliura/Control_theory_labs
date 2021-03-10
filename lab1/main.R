ez.csf <- function() {
    # http://stackoverflow.com/a/32016824/2292993
    cmdArgs = commandArgs(trailingOnly = FALSE)
    needle = "--file="
    match = grep(needle, cmdArgs)

    ret <- list(
        path='',
        method=''
    )

    if (length(match) > 0) {
        # Rscript via command line
        ret$path <- normalizePath(sub(needle, "", cmdArgs[match]))
        ret$method <- 'terminal'
        return(ret)
    } else {
        ls_vars = ls(sys.frames()[[1]])
        if ("fileName" %in% ls_vars) {
            # Source'd via RStudio
            ret$path <- normalizePath(sys.frames()[[1]]$fileName)
            ret$method <- 'RStudio-source'
            return(ret)
        } else {
            if (!is.null(sys.frames()[[1]]$ofile)) {
                # Source'd via R console
                ret$path <- normalizePath(sys.frames()[[1]]$ofile)
                ret$method <- 'R-source'
                return(ret)
            } else {
                # RStudio Run Selection
                # http://stackoverflow.com/a/35842176/2292993
                tryCatch(
                    {library(rstudioapi)},
                    error = function(e) {
                        install.packages('rstudioapi')
                        library(rstudioapi)
                        }
                    )
                pth = rstudioapi::getActiveDocumentContext()$path
                if (pth!='') {
                    ret$path <- normalizePath(pth)
                    ret$method <- 'RStudio-run'
                    return(ret)
                } else {
                    # RStudio Console
                    tryCatch({
                        pth = rstudioapi::getSourceEditorContext()$path
                        pth = normalizePath(pth)
                    }, error = function(e) {
                        # normalizePath('') issues warning/error
                        pth = ''
                    }
                    )
                    ret$path <- pth
                    ret$method <- 'RStudio-console'
                    return(ret)
                }
            }
        }
    }
}


run <- ez.csf()
path <- sub('main.R', '', run$path)

source(paste0(path, 'input.R'), echo = FALSE)
source(paste0(path, 'model.R'), echo = FALSE)
source(paste0(path, 'output.R'), echo = FALSE)


main <- function(){
    while (TRUE){
        tryCatch(
            {
                model.input <- get.model.input()
                if (is.null(model.input)) break()

                show.waiting()

                model <- build.model(model.input)
                display.model(model, run.X11=ifelse(run$method=='terminal',T,F))
            },
            condition = function(con){
                print(con)
            }
        )
        need.restart <- ask.for.restart()
        if (!need.restart) break()
    }
}


main()
