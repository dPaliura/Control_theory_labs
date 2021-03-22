# Do use this method to get proper function to read single line from terminal.
# It is needed when it is unknown whether run in interactive mode or interpreted
..get.readline.method <- function(){
    ifelse(interactive(),
           function(prompt='') {
               cat(prompt)
               return(readline())
           },
           function(prompt='') {
               cat(prompt)
               return(readLines(con='stdin', n=1))
           }
    )
}


# Provides mechanism to read from terminal an numeric expression.
# It does read from terminal while written expression not evaluated as numeric.
#   prompt       - text written each time before inputting text in terminal
#   finite.value - logical. Determines whether got expression must be evaluated
#                  as finite number. If FALSE, values NaN, NA and Inf allowed.
#   cancel, exit - character values. If entered then function stops with
#                  corresponding value returned. Returned NA if entered
#                  cancel, returned NULL if entered exit.
#   ignore.case  - logical, TRUE by default. Says whether need to ignore case for
#                  cancel and exit commands.
# Value - expression object evaluating as number
read.num.expression <- function(prompt = '', finite.value=TRUE,
                                cancel = 'c', exit = 'x', ignore.case=TRUE){
    if (any(!is.character(cancel), length(cancel) != 1)) {
        stop('Parameter cancel must be a character of length 1')
    } else {cancel<- ifelse(ignore.case,tolower(trimws(cancel)),trimws(cancel))}
    if (any(!is.character(exit), length(exit) != 1)){
        stop('Parameter exit must be a character of length 1')
    } else {exit <- ifelse(ignore.case,tolower(trimws(exit)),trimws(exit))}

    read.line <- ..get.readline.method()
    while(TRUE){
        tryCatch(
            {
                text <- read.line(prompt)
                txt <- ifelse(ignore.case, tolower(trimws(text)), trimws(text))
                if (txt == cancel) return(NA)
                if (txt == exit) return(NULL)

                expr <- parse(text = text)
                ev <- eval(expr)
                if (length(ev)==1){
                    if (finite.value) {if (is.finite(ev) &
                                           !is.complex(ev)) return(expr)}
                    else {if (is.numeric(ev)) return(expr)}
                }
            },
            error = function(e){}
        )
    }
}


# Provides mechanism to read from terminal the numerical function giving it's
# body expression. For example, on call with no arguments, if write in terminal
# 'sqrt(x+log(x+1))' it will return object:
#                               function(x) sqrt(x+log(x+1))
#   prompt      - text prompted to user before writing in terminal.
#                 It repeats on incorrect inputs.
#   arguments   - character vector of arguments' names for obtained function.
#   test.values - numeric vector with values of argument which substitute to
#                 test obtained function whether it's result numeric.
#   cancel,exit - character values. If entered then function stops with
#                 corresponding value returned. Returned NA if entered
#                 cancel, returned NULL if entered exit.
#   ignore.case - logical, TRUE by default. Says whether need to ignore case for
#                 cancel and exit commands.
# Value - function which expected to return numbers.
read.num.function <- function(prompt = 'Write function f(x) body\n',
                              arguments = c('x'), test.values = 1,
                              cancel = 'cancel', exit = 'exit',
                              ignore.case = TRUE){
    if (any(!is.character(cancel), length(cancel) != 1)) {
        stop('Parameter cancel must be a character of length 1')
    } else {cancel<- ifelse(ignore.case,tolower(trimws(cancel)),trimws(cancel))}
    if (any(!is.character(exit), length(exit) != 1)){
        stop('Parameter exit must be a character of length 1')
    } else {exit <- ifelse(ignore.case,tolower(trimws(exit)),trimws(exit))}

    read.line <- ..get.readline.method()
    f <- function() {}
    formals(f) <- eval(parse(
        text=paste0('alist(',
                    paste(arguments, '=', sep='', collapse=', '),
                    ')')))
    f.call.expr <- parse(text = paste('f(',
                                      paste(arguments,
                                            '=',
                                            test.values,
                                            collapse = ', '),
                                      ')'))
    # DO NOT DELETE THIS LINE
    eval(f.call.expr)
    # It rises error when incorrect expression for f function call
    # Otherwise in such case it will occur infinite looping

    while(TRUE){
        tryCatch(
            {
                text <- read.line(prompt)
                txt <- ifelse(ignore.case, tolower(trimws(text)), trimws(text))
                if (txt == cancel) return(NA)
                if (txt == exit) return(NULL)

                expr <- parse(text = text)
                body(f) <- expr
                ev <- eval(f.call.expr)
                if (is.numeric(ev) & length(ev)==1) return(f)
            },
            error = function(e){}
        )
    }
}


# Provides choose of one option through terminal.
#   options - character vector of available options that expected to be entered.
#   prompt  - As always
#   cancel, exit - special options, identified by values NA for cancel
#                  and NULL for exit
#   ignore.case  - logical, says whether need to ignore case of entered values
#                  when compare with options
# Value - character corresponding to option (if ignore.case then brought to
# lower case), whitespaces trimmed with trimws(). NOTE! It returns NA value for
# chosen option cancel and NULL for chosen exit.
read.option.choose <- function(options, prompt = '',
                               cancel = 'c', exit = 'x', ignore.case = TRUE){
    if (any(!is.character(options), length(options) < 1)){
        stop('Parameter options must be a character of length greater than 0')
    }
    if (any(!is.character(cancel), length(cancel) != 1)) {
        stop('Parameter cancel must be a character of length 1')
    } else {cancel<- ifelse(ignore.case,tolower(trimws(cancel)),trimws(cancel))}
    if (any(!is.character(exit), length(exit) != 1)){
        stop('Parameter exit must be a character of length 1')
    } else {exit <- ifelse(ignore.case,tolower(trimws(exit)),trimws(exit))}

    if (ignore.case){
        options <- tolower(trimws(options))
        cancel <- tolower(trimws(cancel))
        exit <- tolower(trimws(exit))
    }
    else {
        options <- trimws(options)
        cancel <- trimws(cancel)
        exit <- trimws(exit)
    }

    if (any(c(cancel, exit) %in% options)){
        stop('Parameter options must not contain cancel or exit')
    }

    read.line <- ..get.readline.method()
    while(TRUE){
        text <- read.line(prompt)
        text <- ifelse(ignore.case, tolower(trimws(text)), trimws(text))
        if (text == cancel) return(NA)
        if (text == exit) return(NULL)
        if (text %in% options) return(text)

    }
}

# Read sequential inputs means chain of inputs probably of different types
# Returns values for all of them in corresponding order, or with names
# Write exactly calls instead of ...
# Example:
#   read.seq.inputs(
#       x = read.num.expression('Write number x'),
#       y = read.num.expression('Write number y'),
#       f = read.num.function('Write function f(x, y) = ',
#                             arguments = c('x', 'y')),
#       ev = read.option.choose('Evaluate f(x, y)? y/n')
#   )
# It's available to use call for read.seq.inputs as parameter of read.seq.inputs
# And it's available to build tree structures via ifelse()
read.seq.inputs <- function(...){
    l = ...length()
    if (!l) return()

    calls <- as.list(match.call())[-1]
    res <- calls
    i = 1

    while(i <= l){
        val = eval(calls[[i]])

        if (any(is.expression(val), is.function(val),
                is.character(val), is.list(val))){
            res[[i]] <- val
            i <- i+1
        }
        else if (is.null(val)) return(NULL)
        else if (is.na(val)){
            if (i > 1) i <- i -1
            else return(NA)
        }
    }
    return(res)

}