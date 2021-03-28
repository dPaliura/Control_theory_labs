# Solves variation problem where
# func - function(t, x, dx) - underintegral function:
#        time t, value x (x=x(t)), and derivative dx (dx = dx/dt (t))
# t1, t2 - limits for integral
# x1, x2 - values for x at moments t1 and t2 (x1 = x(t1), x2 = x(t2))
# N - Number of intervals for splitting the time interval [t1, t2].
# lambda - regularization parameter. If not NULL, then problem solved
#          as regularized with value lambda >= 0
var.prb <- function(func, t1, t2, x1, x2, N=50, lambda = NULL, ...){
    dt <- (t2-t1)/N
    times <- (0:N)*dt + t1
    dx <- (x2-x1)/N
    X0 <- (1:(N-1))*dx + x1

    J <- if(is.null(lambda)) function(X){
        X <- c(x1, X, x2)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) func(times[i], X[i], dX[i]))
        return(sum(I)*dt)
    } else function(X){
        X <- c(x1, X, x2)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) func(times[i], X[i], dX[i]))
        return((sum(I) + lambda*sum(dX^2))*dt)
    }

    opt <- optim(X0, J)
    return(opt)
}
