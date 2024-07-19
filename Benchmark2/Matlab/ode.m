function dtds = ode(s,t,lambda,drive,t0)
h=t0*(1-sin(s/1.5*pi/2));
dtds = [t(2)
       -lambda*(sin(t(1))+sin(h))];