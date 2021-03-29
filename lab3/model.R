# Solves variation problem where
# I = function(t, x, dx) - underintegral function:
#        time t, value x (x=x(t)), and derivative dx (dx = dx/dt (t))
# t1, t2 - limits for integral
# x1, x2 - values for x at moments t1 and t2 (x1 = x(t1), x2 = x(t2))
# N - Number of intervals for splitting the time interval [t1, t2].
# lambda - regularization parameter. If not NULL, then problem solved
#          as regularized with value lambda >= 0
# method - optimization method passed to optim() function as cognominal argument
# ... - other arguments passed to optim() function,
#       for example, control=list(trace=3)
var.prb <- function(I, t0, t1, x0, x1, N=50, lambda = NULL,
                    ...,
                    method = 'BFGS'){
    dt <- (t1-t0)/N
    times <- (0:N)*dt + t0
    dx <- (x1-x0)/N
    X0 <- (1:(N-1))*dx + x0

    J <- if(is.null(lambda)) function(X){
        X <- c(x0, X, x1)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) I(times[i], X[i], dX[i]))
        return(sum(I)*dt)
    } else function(X){
        X <- c(x0, X, x1)
        dX <- (X[(1:N)+1] - X[1:N])/dt
        I <- sapply(1:N, function(i) I(times[i], X[i], dX[i]))
        return((sum(I) + lambda*sum(dX^2))*dt)
    }

    opt <- optim(X0, J, method=method, ...)
    res <- list(
        I = I, J = J,
        t0 = t0, t1 = t1,
        x0 = x0, x1 = x1,
        N = 50,
        lambda = lambda,
        method = method,
        times = times,
        opt = opt
    )
    class(res) <- 'VariationProblemSolution'
    return(res)
    print(opt)
}


plot.VariationProblemSolution <- function(obj, ...){
    plot(obj$times, c(obj$x0, obj$opt$par, obj$x1),
         type = 'l',
         xlab = 'time', ylab = 'x',
         ...)
}


summary.VariationProblemSolution <- function(obj){
    nl <- '\n'
    cat('\tVariatiion Problem solution', nl,
        'Integrate I(t, x, dx) dt from ', obj$t0, ' to ', obj$t1, nl,
        'Where I(t, x, dx) = ', deparse(body(obj$I)), nl,
        'x = x(t): x(',obj$t0,') = ',obj$x0, ', x(',obj$t1,') = ',obj$x1, nl,
        'Size of interval splitting N = ', obj$N, nl,
        'J(...) depends on ', obj$N-1, ' variables (inner points)', nl,
        ifelse(test = !is.null(obj$lambda),
               yes = paste('Regularized with lambda =', obj$lambda),
               no ='Regularization wasn\'t used'), nl,
        'Optimized via optim(par, fn, ...) with method=\'', obj$method, "'", nl,
        'Got J optimal value ', obj$opt$value, nl,
        'While optimization evaluated J - ', obj$opt$counts[1], ' times ',
        'and its gradient - ', ifelse(is.na(obj$opt$counts[2]),
                                'wasn\'t counted',
                                paste(obj$opt$counts[2],'times')), '.', nl,
        sep='')
}
