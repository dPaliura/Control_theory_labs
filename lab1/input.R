# Variant number
.n <- 15

.default.input <- list(
    s0 = sqrt(.n),
    v = sqrt(.n),
    l = .n,
    phi = .n*pi/25,
    f = function(y) y
)


# Do use this method to get function to read single line from terminal.
# It is needed when it is unknown whether run in interactive mode or interpreted
..get.readline.method <- function(){
    ifelse(interactive(),
           function(prompt='') return(readline(prompt)),
           function(prompt='') {
               cat(prompt)
               return(readLines(con='stdin', n=1))
           }
    )
}


.read.num.expression <- function(prompt = '',
                                finite.value=TRUE){
    read.line <- ..get.readline.method()
    while(TRUE){
        tryCatch(
            {
                expr <- parse(text = read.line(prompt))
                ev <- eval(expr)
                if (finite.value) {if (is.finite(ev) &
                                       !is.complex(ev)) return(expr)}
                else {if (is.numeric(ev)) return(expr)}

            },
            error = function(e){}
        )
    }
}


.read.num.function <- function(prompt = 'Write function f(x) body\n',
                              arguments = c('x'),
                              test.values = 1){
    read.line <- ..get.readline.method()
    f <- function() {}
    formals(f) <- eval(parse(
                        text=paste0('alist(',
                                    paste(arguments, '=', sep='', collapse=', '),
                                    ')')))
    f.call.expr <- parse(text = paste('f(',
                                      paste(arguments,
                                            '=',
                                            test.values),
                                      ')'))
    # DO NOT DELETE THIS LINE
    eval(f.call.expr)
    # It rises error when incorrect expression for f function call
    # Otherwise in such case it will occur infinite looping

    while(TRUE){
        tryCatch(
            {
                expr <- parse(text = read.line(prompt))
                body(f) <- expr
                ev <- eval(f.call.expr)
                if (is.numeric(ev) & length(ev)==1) return(f)
            },
            error = function(e){}
        )
    }
}


.get.model.input <- function(){
    read.line <- ..get.readline.method()

    answer <- read.line("Use default input? y/n/x: ")
    answer <- tolower(trimws(answer))
    if (answer == 'y') return(.default.input)
    if (answer == 'n') {
        return(
            list(
                s0 = eval(.read.num.expression('Enter s0 - initial spead of stream: ')),
                v = eval(.read.num.expression('Enter v -spead of boat: ')),
                l = eval(.read.num.expression('Enter l - distance to target: ')),
                phi = eval(.read.num.expression(
                    'Enter phi - angle of direction to target from initial boat position: ')),
                f = .read.num.function(
                        'Stream spead is s(y) = s0*f(y). Using R language define f(y) = ',
                        arguments = c('y'))
            )
        )
    }
    if (answer == 'x') return(NULL)
}


ask.for.restart <- function(){
    read.answer <- ..get.readline.method()

    while (TRUE){
        answer <- read.answer("Restart program? y/n: ")
        answer <- tolower(trimws(answer))

        if (answer == 'y') return(TRUE)
        if (answer == 'n') return(FALSE)
    }
}


