function tinit = init(s)
%l = 8.5*pi;
tinit = [  0.003*(1-sin(s/1.5*pi/2))
            -0.003*cos(s/1.5*pi/2)];