# Special function which defines corner to place legend. It chooses such corner
# where number of points is the least.
# Value - string representation of legend position
define.legend.position <- function(xlim, ylim, pts){
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
    cat('\tInput\n')
    print(inp)
    if (run.X11) X11()
}

# Used after input get and before model built to indicate that program is
# calculating.
show.waiting <- function(){
    cat('\n\nWait...\n\n')
}
