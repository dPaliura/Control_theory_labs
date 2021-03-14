# Some big number to be used in aiming method
..N <- 1e3


# Returns list of:
# boat next position after current control
# vector of boat control in current point
..model.control <- function(boat, target, v, S.fun, tau){
    s <- S.fun(boat)
    x <- boat[1]
    y <- boat[2]
    x_t <- target[1]
    y_t <- target[2]

    v.tau <- v*tau
    v.tau.square <- v.tau^2
    s.tau <- s*tau

    lambda <- sqrt((x_t - x - s.tau)^2 + (y_t - y)^2)*v.tau - v.tau.square

    control.divider <- lambda + v.tau.square
    control <- c(x_t - x - s.tau, y_t-y)*v.tau/control.divider

    boat.new <- boat + v*control*tau + tau*c(s,0)

    return(list(
        boat.new = boat.new,
        control = control
    ))
}


# Returns Euclidean length of vector x
.euclidean.length <- function(x) sqrt(sum(x^2))


# Solves Navigation Problem of Speed for fixed target.
# Input:
#   input.obj - list of 5 problem parameters. Must be defined with names:
#       v - boat speed
#       s0 - initial stream speed
#       l - distance to target
#       phi - angle between x axis and vector from origin to target
#       f - function of variable y which is dependence of stream speed
#       v, s0, l, phi can be set as R expressions
#   maxiters - number of iterations after which algorithm stops without target
#              reach
# Value is list of 10:
#   input - parameter input.obj
#   target - numeric vector of target coordinates in x0y
#   boat.states - matrix of boat states through it's move to target.
#                 contains x, y, t in columns - coordinates and time when in it
#   target.achieved - logical, TRUE if algorithm stopped after boat achieved
#                     target.
#   control - matrix of controls spelled while move.
#             Controls by x and y in 2 columns.
#   time - whole time spent to reach target. If target not reached then time=Inf
#   iters - number of iterations made by algorithm
#   message - if something gone wrong, this variable contains message about it.
#   N - big number used
#   tau - small time interval got through division by big number N
build.model <- function(input.obj, maxiters = ..N*50){
    N <- ..N

    s0  <- eval(input.obj$s0)
    v   <- eval(input.obj$v)
    l   <- eval(input.obj$l)
    phi <- eval(input.obj$phi)
    f   <- input.obj$f

    boat <- c(x=0, y=0)
    target <- l*c(x=cos(phi), y=sin(phi))

    tau <- l/(v*N)

    S <- function(boat) s0 * f(boat[2])

    t=0
    boat.states <- c(boat, t=t)
    control  <- NULL

    result = list(
        input = input.obj,
        target = target,
        boat.states = NULL,
        target.achieved = FALSE,
        control = NULL,
        time = 0,
        iters = 0,
        message = NULL,
        N = ..N,
        tau = tau
    )

    for (iter in 1:maxiters){
        distance <- .euclidean.length(boat - target)

        boat.new.state <- ..model.control(boat, target, v, S, tau)
        boat.new <- boat.new.state$boat.new
        control <- rbind(control, boat.new.state$control)
        t <- t+tau

        distance.gone <- .euclidean.length(boat.new-boat)
        if (!is.finite(distance.gone)){
            result$boat.states <- NA
            result$target.achieved <- FALSE
            result$control <- control
            result$time <- NA
            result$iters <- iter
            result$message <- 'Non-finite values appeared while computing.'
            return(result)
        }
        if (distance.gone >= distance){
            boat.states <- rbind(boat.states, c(target, t=t))

            result$boat.states <- boat.states
            result$target.achieved <- TRUE
            result$control <- control
            result$time <- t
            result$iters <- iter
            return(result)
        }

        boat.states <- rbind(boat.states, c(boat.new, t=t))
        boat <- boat.new
    }

    result$boat.states <- boat.states
    result$control <- control
    result$time <- Inf
    result$iters <- iter
    result$message <- paste0('Max number of iterations (', maxiters,') ',
                              'achieved. ', 'Boat didn\'t reach the target.')
    return(result)
}


