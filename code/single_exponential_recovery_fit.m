function error = single_exponential_recovery_fit(p,x,y)

fit=p(1)*(1.0-exp(-p(2)*x));

error=dot(fit-y,fit-y);
