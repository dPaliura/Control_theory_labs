# Variant number
.n <- 15

# List of values given as default - according to author's variant for lab work
# s0  - initial speed of stream
# v   - speed of boat
# l   - distance to target point
# phi - angle of direction from boat position to target
#       relative to stream vector
# f   - function of dependence stream speed multiplier of vertical coordinate y.
#       It defines stream speed via expression:
#           s(y) = s0 * f(y)
.default.input <- list(
    s0 = sqrt(.n),
    v = sqrt(.n),
    l = .n,
    phi = .n*pi/25,
    f = function(y) y
)



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
# Value - expression object evaluating as number
.read.num.expression <- function(prompt = '', finite.value=TRUE){
    read.line <- ..get.readline.method()
    while(TRUE){
        tryCatch(
            {
                expr <- parse(text = read.line(prompt))
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
# Value - function which expected to return numbers.
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


# Method for getting input for task of laboratory work
# including choose between use values according to variant (named as defaults)
# and hand input. In second case it is available to use R language expressions
# in terminal input for each numeric value.
# Example: default phi value would be written as '15*pi/25' in terminal.
get.model.input <- function(){
    read.line <- ..get.readline.method()

    while (TRUE) {
        answer <- read.line("Use default input? y/n/x: ")
        answer <- tolower(trimws(answer))
        if (answer == 'y') return(.default.input)
        if (answer == 'n') {
            return(
                list(
                    s0 = .read.num.expression('Enter s0 - initial spead of stream: '),
                    v = .read.num.expression('Enter v - spead of boat: '),
                    l = .read.num.expression('Enter l - distance to target: '),
                    phi = .read.num.expression(paste('Enter phi - angle of',
                                                     'direction to target from',
                                                     'initial boat position: ')),
                    f = .read.num.function(paste('Stream spead is s(y) = s0*f(y).',
                                                 'Using R language define f(y) = '),
                                           arguments = c('y'))
                )
            )
        }
        if (answer == 'x') return(NULL)
    }
}


# Provides question after working off model to restart program.
# Value - TRUE if user want to restart and FALSE otherwise.
ask.for.restart <- function(){
    read.answer <- ..get.readline.method()

    while (TRUE){
        answer <- read.answer("Restart program? y/n: ")
        answer <- tolower(trimws(answer))

        if (answer == 'y') return(TRUE)
        if (answer == 'n') return(FALSE)
    }
}
