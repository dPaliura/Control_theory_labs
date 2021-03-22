get.model.input <- function(){
    return(list(
        N = 5e5,
        I0 = 1,
        R0 = 0,
        D0 = 0,
        r = 10,
        c = 0.5,
        alpha = 0.1,
        beta = 0.04
    ))
}


ask.for.restart <- function(){
    ifelse(read.option.choose(c('y', 'n'), 'Restart programm? y/n: ') == 'y',
           TRUE, FALSE)
}