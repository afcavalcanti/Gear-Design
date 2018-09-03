n=10;
pd=6;
phi_d=20;
r_fillet=0.05;
xp=zeros(10,1);yp=zeros(10,1);
xo=zeros(5,1);yo=zeros(5,1);
xr=zeros(3,1);yr=zeros(3,1);
xro=zeros(5,1);yro=zeros(5,1);
xf=zeros(5,1);yf=zeros(5,1);
theta=zeros(10,1);
f=zeros(2,28);
M=[];c=[];e=[];g=[];h=[];
d=n/pd;
phi=phi_d*%pi/180;
db=d*cos(phi);
d0=d+2/pd;
tt=%pi/(2*pd);
dr=d-2*1.25/pd;
n1=10;
tp=%pi*d/(2*n);
for i=1:n1;
    r=d0/2-(d0-db)*(i-1)/(2*(n1-1));
    pha=acos(db/(2*r));
    t=2*r*(tp/d+(tan(phi)-phi)-(tan(pha)-pha));
    theta(i)=t/(2*r);
    xp(i)=r*sin(theta(i));
    yp(i)=r*cos(theta(i));
end
xp=xp';yp=yp';
n2=5;
for i=1:n2;
    theta_o=theta(1)*(i-1)/(n2-1);
    xo(i)=(d0/2)*sin(theta_o);
    yo(i)=(d0/2)*cos(theta_o);
end
xo=xo';yo=yo';
for i=1:3;
    theta0=asin((xp(1,n1)+r_fillet)/(dr/2)); 
    xr(i)=xp(1,10);
    yr(i)=yp(1,10)-(yp(1,10)-r_fillet-(dr/2)*cos(theta0))*i/3;
end
xr=xr';yr=yr';
n3=5;
for i=1:n3;
   thetar=theta0+(%pi/n-theta0)*(i-1)/(n3-1);
   xro(i)=dr*sin(thetar)/2;
    yro(i)=dr*cos(thetar)/2;
end
xro=xro';yro=yro';
n4=5;
for i=1:n4;
   xf(i)=xro(1)-r_fillet*cos((i-1)*%pi/(2*n4-2));
   yf(i)=yro(1)+r_fillet*(1-sin((i-1)*%pi/(2*n4-2)));	%yf(5)=yro(1)-r_fillet*sin(4*%pi/8)
end
xf=xf';yf=yf';
c=[c,xo,xp,xr,xf,xro];
e=[e,yo,yp,yr,yf,yro];
g=[c',e'];
g=g';
ff=[-1 0;0 1]*g;
n5=n1+n2+n3+n4+3;
for i=1:n5;
    f(1,i)=ff(1,n5+1-i);
    f(2,i)=ff(2,n5+1-i);
end
h=[h,f,g];
for i=1:n;
    kk=[cos(2*%pi*(i-1)/n) sin(2*%pi*(i-1)/n);-sin(2*%pi*(i-1)/n) cos(2*%pi*(i-1)/n)];
    mm=kk*h;
    M=[M,mm];
end
M=[M,h(:,1)];
plot (g(1,:),g(2,:),'-.b',xp,yp,'-r', 'linewidth',4);
plot (M(1,:),M(2,:));
axis('equal');
M=M';
