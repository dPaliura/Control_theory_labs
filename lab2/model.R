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
build.model <- function(input.obj, days=NULL){
    require('deSolve')
    N  <- input.obj$N

    init.state <-  c(S = N - input.obj$I0, I = input.obj$I0,
                     J = 0, R = 0, D = 0)

    r  <- input.obj$r
    c  <- input.obj$c

    alpha <- input.obj$alpha
    beta  <- input.obj$beta
    a <- input.obj$a
    b <- input.obj$b


    v <- ifelse(is.null(input.obj$v), function(t) 0, input.obj$v)
    u <- ifelse(is.null(input.obj$u), function(t) 0, input.obj$u)

    p <- function(I) -log(1-c)*r*I/N


    derivate <- function(t, y, parms){
        return(list(c(
            - ((S <- y['S']) * p((I <- y['I'])) -> SpI) - (S*u(t) -> Sut),
            SpI - (alpha*I -> alphaI) - (beta*I -> betaI) - (I*v(t) -> Ivt),
            Ivt - (a*(J <- y['J']) -> aJ) - (b*J -> bJ),
            alphaI + aJ + Sut,
            betaI + bJ
        )))
    }

    sol <- if (is.null(days)) {
        day <- 0
        states <- NULL
        penalty <- 0
        repeat {
            cur.sol <- ode(init.state, seq(day, (day <- day+10)), derivate)
            n <- nrow(cur.sol)
            states <- rbind(states, cur.sol[-n,])
            init.state <- cur.sol[n,-1]
            if (init.state['S'] + init.state['I'] + init.state['J'] < 0.5) break
            if (sd(cur.sol[n,-1]-init.state) < 1e-3) {
                if (penalty > 4) break
                else penalty <- penalty+1
            }
        }
        rbind(states, cur.sol[n,])
    }
    else ode(init.state, 0:days, derivate)

    sol[, 2:3] <- round(sol[, 2:3])
    sol[, -(1:4)] <- floor(sol[, -(1:4)])
    sol[, 4] <- N - rowSums(sol[, -c(1,4)])

    return(list(
        input = input.obj,
        states = sol
    ))
}
