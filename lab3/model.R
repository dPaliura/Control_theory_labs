# Solves variation problem where
# func - function(t, x, dx) - underintegral function:
#        time t, value x (x=x(t)), and derivative dx (dx = dx/dt (t))
# t1, t2 - limits for integral
# x1, x2 - values for x at moments t1 and t2 (x1 = x(t1), x2 = x(t2))
# N - Number of intervals for splitting the time interval [t1, t2].
# lambda - regularization parameter. If not NULL, then problem solved
#          as regularized with value lambda >= 0
var.prb <- function(func, t0, t1, x0, x1, N=50, lambda = NULL,
                    ...,
                    method = 'BFGS'){
    dt <- (t1-t0)/N
    times <- (0:N)*dt + t0
    dx <- (x1-x0)/N
    X0 <- (1:(N-1))*dx + x0

    J <- if(is.null(lambda)) function(X){
        X <- c(x0, X, x1)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) func(times[i], X[i], dX[i]))
        return(sum(I)*dt)
    } else function(X){
        X <- c(x0, X, x1)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) func(times[i], X[i], dX[i]))
        return((sum(I) + lambda*sum(dX^2))*dt)
    }

    opt <- optim(X0, J, method=method, ...)
    return(opt)
}
