#   System variables
# N - number of people
# i0 - part of Infected when t=0
# r0 - part of Recovered when t=0
# d0 - part of Dead when t=0
#   s0 = 1-(i0+r0+d0) >= 0. s0 - part of Susceptible when t=0 (calculated value)
#   Parameters
# r - mean number of contacts per day for any person
# c - mean probability to become infected per single contact with infected one
# alpha - probability to recover for a person per day
# beta  - probability to die for a person per day
#   it might be alpha + beta <= 1
#   Control
# u - function u(t) - number of vaccinated people per day
build.model <- function(input.obj, days=3650){
    N  <- input.obj$N

    S <- N - (I <- input.obj$I0) - (R <- input.obj$R0) - (D <- input.obj$D0)

    r  <- input.obj$r
    c  <- input.obj$c
    alpha <- input.obj$alpha
    beta  <- input.obj$beta

    u <- ifelse(is.null(input.obj$u), function(t) 0, input.obj$u)

    p <- function(I) -log(1-c)*r*I/N

    get.new.state <- function(state) c(
        (state['day'] -> day) + 1,
        (state['S'] -> S) - (S*p(I) -> S.p_I) - (S*u(day) -> S.u_t),
        (state['I'] -> I) + S.p_I - (alpha*I -> alpha.I) - (beta*I -> beta.I),
        (state['R'] -> R) + alpha.I + S.u_t,
        (state['D'] -> D) + beta.I
        )

    states <- rbind(tmp.state <- c(day=0, S=S, I=I, R=R, D=D))
    if (is.null(days)) repeat{
        states <- rbind(states,
                        (tmp.state <- get.new.state(tmp.state)))
        if (tmp.state['R'] + tmp.state['D'] == N) break
    }
    else for (day in 1:days){
        states <- rbind(states,
                        get.new.state(states[day,]))
    }
    return(list(
        input = input.obj,
        states = states))
}


