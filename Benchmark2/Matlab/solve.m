clear all;

%Imperfection
t0 = 0.001;

%Half of a strut
length = 0.477*pi;

%Define the length
a=0;
b=length;
s = linspace(a,b,15);

%Initial value of the load
EI=1660000;
lambda = 0.001;
pcr=pi^2*EI/b^2;

%initial guess of the solution for the first step
options = bvpset('RelTol',1e-6,'AbsTol',1e-6,'NMax',10000);
tDrive = 0.005*pi/8;
numberOfStepsOne = 1000;
%Loop in which the theta at the first point of the beam is increased
for i=1:numberOfStepsOne;
    drive = t0+i*tDrive;
    driveVector(i) = drive;
    if i==1
      solinit = bvpinit(s,@init,lambda);
    else
      solinit = bvpinit(s,@(x)deval(sol,x),lambda(i-1));  
    end
    sol = bvp4c(@ode,@bc,solinit,options,drive,t0);
    fprintf('The load parameter lambda is %7.3f.\n',...
            sol.parameters)
    lambda(i) = sol.parameters;
    x = 0:length/15:length;
    y = deval(sol,x);
    plotdata(i,:) = y(1,:);
end 
%save data to file
save plotData.dat plotdata -ASCII

%Plot the deformed shape of half the strut
figure(1)
hold on;
x = 0:length/15:length;
y = deval(sol,s);
%plot(s,t(1,:))
plot(x,plotdata(10,:));

%Plot the load-displacement curve
figure(2)
x = 0:numberOfStepsOne;
plot(driveVector,lambda*0.9118)
