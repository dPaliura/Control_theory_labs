# Special function which defines corner to place legend. It chooses such corner
# where number of points is the least.
# Value - string representation of legend position
..define.legend.position <- function(xlim, ylim, pts){
    x.mid <- mean(xlim)
    y.mid <- mean(ylim)

    positions <- c('topleft', 'topright', 'bottomright', 'bottomleft')

    topleft.count <- sum((xlim[1] <= pts[,1] & pts[,1] <=   x.mid) &
                         (y.mid   <= pts[,2] & pts[,2] <= ylim[2]))

    toprght.count <- sum((x.mid   <= pts[,1] & pts[,1] <= xlim[2]) &
                         (y.mid   <= pts[,2] & pts[,2] <= ylim[2]))

    botrght.count <- sum((x.mid   <= pts[,1] & pts[,1] <= xlim[2]) &
                         (ylim[1] <= pts[,2] & pts[,2] <=   y.mid))

    botleft.count <- sum((xlim[1] <= pts[,1] & pts[,1] <=   x.mid) &
                         (ylim[1] <= pts[,2] & pts[,2] <=   y.mid))

    return(positions[which.min(c(topleft.count, toprght.count,
                                 botrght.count, botleft.count))])
}


# Interprets model list got via build.model function from module model.R
# and prints all beneficial information about it. Draw plot if available.
# Input:
#   model - value of function build.model
#   run.X11 - logical, indicates whether it is need to open default R visual
#             device. It is important, when program run from terminal.
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

        states <- model$boat.states
        n <- nrow(states)

        xlim <- range(model$boat.states[,1], model$target[1])
        ylim <- range(model$boat.states[,2], model$target[2])
        leg.pos <- ..define.legend.position(xlim, ylim,
                                        rbind(states[,1:2], model$target))

        plot(x = model$target[1], y = model$target[2],
             col = 'red', pch = 4, lwd = 2,
             xlim = xlim, ylim = ylim,
             main = 'Boat trace to target',
             xlab = 'x', ylab = 'y')
        segments(x0 = states[1:(n-1),1], y0 = states[1:(n-1),2],
                 x1 = states[2:n,1], y1 = states[2:n,2])
        legend(leg.pos, legend = c('target', 'boat trace'),
               pch = c(4, NA), lwd=c(2, 1), lty = c(0, 1),
               col=c('red', 'black'))

    }
    else {
        cat('Plot not available', nl)
    }
}

# Used after input get and before model built to indicate that program is
# calculating.
show.waiting <- function(){
    cat('\n\nWait...\n\n')
}
