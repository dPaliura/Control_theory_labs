ez.csf <- function() {
    # http://stackoverflow.com/a/32016824/2292993
    cmdArgs = commandArgs(trailingOnly = FALSE)
    needle = "--file="
    match = grep(needle, cmdArgs)
    if (length(match) > 0) {
        # Rscript via command line
        return(normalizePath(sub(needle, "", cmdArgs[match])))
    } else {
        ls_vars = ls(sys.frames()[[1]])
        if ("fileName" %in% ls_vars) {
            # Source'd via RStudio
            return(normalizePath(sys.frames()[[1]]$fileName))
        } else {
            if (!is.null(sys.frames()[[1]]$ofile)) {
                # Source'd via R console
                return(normalizePath(sys.frames()[[1]]$ofile))
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
                    return(normalizePath(pth))
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
                    return(pth)
                }
            }
        }
    }
}


path <- sub('main.R', '', ez.csf())

source(paste0(path, 'input.R'), echo = FALSE)
source(paste0(path, 'model.R'), echo = FALSE)
source(paste0(path, 'output.R'), echo = FALSE)


main <- function(){
    while (TRUE){
        model.input <- get.model.input()
        if (is.null(model.input)) break()

        model <- build.model(model.input)
        display.model(model)

        need.restart <- ask.for.restart()
        if (!need.restart) break()
    }
}


main()
