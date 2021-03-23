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
    N  <- input.obj$N

    S0 <- N - (I0 <- input.obj$I0) - (J0 <- input.obj$J0) -
              (R0 <- input.obj$R0) - (D0 <- input.obj$D0)

    r  <- input.obj$r
    c  <- input.obj$c

    alpha <- input.obj$alpha
    beta  <- input.obj$beta
    a <- input.obj$a
    b <- input.obj$b


    v <- ifelse(is.null(input.obj$v), function(t) 0, input.obj$v)
    u <- ifelse(is.null(input.obj$u), function(t) 0, input.obj$u)

    p <- function(I) -log(1-c)*r*I/N

    init.state <-  c(S=S0, I=I0, J=J0, R=R0, D=D0)

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
        repeat {
            cur.sol <- ode(init.state, seq(day, (day <- day+10)), derivate)
            n <- nrow(cur.sol)
            states <- rbind(states, cur.sol[-n,])
            init.state <- cur.sol[n,-1]
            if (init.state['S'] + init.state['I'] + init.state['J'] < 0.5) break
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


inp <- list(
    N = 5e5,

    I0 = 1,
    J0 = 0,
    R0 = 0,
    D0 = 0,

    r = 1,
    c = 0.2,

    alpha = 1e-3,
    beta = 2e-5,
    a = 3e-3,
    b = 1e-5,

    # v is testing, u is vaccination
    v = function(t) {
        if (t > 0) {
            if (t <= 180)  c(rep(0,30), 1:50,
                            rep(49:40, each=2), rep(39:30, each=3),
                            rep(29:25, each=4), rep(24:20, each=6))[t]/2e3
            else 0.01
        }
        else 0
    }
)
