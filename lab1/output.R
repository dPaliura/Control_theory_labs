display.model <- function(model, run.X11=FALSE){
    nl <- '\n'
    inp <- model$input
    cat('\tInput:\n',
        'Stream initial speed ', as.character(inp$s0), nl,
        'Speed of boat ', as.character(inp$v), nl,
        'Distance to target ', as.character(inp$l), nl,
        'The angle of course to target from initial point ',
                                as.character(inp$phi), nl,
        'Target is in point (', paste(model$target, collapse=', '), ')', nl,
        'Stream speed is s(y) = s0 * f(y),', nl,
        'where s0 - stream initial speed', nl,
        'f(y) = ', paste(deparse(body(inp$f)),
                         collapse=nl), nl,
        nl,
        sep='')

    cat('\tModel apply results', nl,
        'Target is ', ifelse(model$target.achieved, '', 'NOT '), 'achieved', nl,
        ifelse(model$target.achieved,
            paste0('Whole time spent by boat to reach target ', model$time, nl),
            ''),
        'Some big number N is ', model$N, nl,
        'Small time interval tau is ', model$tau, nl,
        'Model iterated ', model$iters, ' times', nl,
        ifelse(!is.null(model$message),
               paste0('Messages got while building model:', nl,
                     paste(model$messages, collapse = nl), nl),
               ''),
        sep = '')

    if (!is.na(model$boat.states[1])){
        cat('See \'plot\' window to view boat trace', nl)
        if (run.X11) X11()
        plot(model$boat.states[,1],model$boat.states[,2], type='l',
             xlim = range(model$boat.states[,1], model$target[1]),
             ylim = range(model$boat.states[,2], model$target[2]))
        points(x=model$target[1], y=model$target[2],
               col='red', pch=20)
    }

}


show.waiting <- function(){
    cat('\n\nWait...\n\n')
}
