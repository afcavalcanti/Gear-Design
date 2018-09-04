//This code plots an involute spur gear.
//INPUT
n=15;//number of teeth
d=100;//pitch diamter
phi_d=20;//pressure angle in degrees
r_fillet=0.05;//radius of fillet
//------------------------------------
pd=n/d;//diametral pitch
phi=phi_d*%pi/180;//pressure angle in radians
db=d*cos(phi);//diameter of base circle
d0=d+2/pd;//addendum diameter
tt=%pi/(2*pd);//tooth thickness at the pitch circle
dr=d-2*1.25/pd;//dedendum diameter
//-------------------------------------
n1=10;
n2=5;
n3=3;
n4=n1+(3*n2)+n3;
xp=zeros(n1,1);yp=zeros(n1,1);
xo=zeros(n2,1);yo=zeros(n2,1);
xr=zeros(n3,1);yr=zeros(n3,1);
xro=zeros(n2,1);yro=zeros(n2,1);
xf=zeros(n2,1);yf=zeros(n2,1);
theta=zeros(n1,1);
f=zeros(2,n4);
M=[];c=[];e=[];g=[];h=[];
//-------------------------------------
//To calculate the coordinates of the involute profile
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
//-------------------------------------
//To calculate the addendum circle
for i=1:n2;
    theta_o=theta(1)*(i-1)/(n2-1);
    xo(i)=(d0/2)*sin(theta_o);
    yo(i)=(d0/2)*cos(theta_o);
end
xo=xo';yo=yo';
//--------------------------------------------------
//To calculate the non-involute portion of the curve
for i=1:3;
    theta0=asin((xp(1,n1)+r_fillet)/(dr/2));  
    xr(i)=xp(1,10);
    yr(i)=yp(1,10)-(yp(1,10)-r_fillet-(dr/2)*cos(theta0))*i/3;
end
xr=xr';yr=yr';
//------------------------------------------------------
//To calculate the dedendum circle
for i=1:n2;
   thetar=theta0+(%pi/n-theta0)*(i-1)/(n2-1);
   xro(i)=dr*sin(thetar)/2;
    yro(i)=dr*cos(thetar)/2;
end
xro=xro';yro=yro';
//------------------------------------------------------
//To calculate fillet
for i=1:n2;
   xf(i)=xro(1)-r_fillet*cos((i-1)*%pi/(2*n2-2));
   yf(i)=yro(1)+r_fillet*(1-sin((i-1)*%pi/(2*n2-2)));
end
xf=xf';yf=yf';
//-------------------------------------------------------
//To append each piece of curve to generate one-half of a tooth profile
c=[c,xo,xp,xr,xf,xro];
e=[e,yo,yp,yr,yf,yro];
g=[c',e'];
g=g';//the one-half  tooth profile
//----------------------------------------------------------------------
//To reflecte the involute curve about y axis to get the whole tooth
ff=[-1 0;0 1]*g;//reflection 
for i=1:n4;
    f(1,i)=ff(1,n4+1-i);
    f(2,i)=ff(2,n4+1-i);
end
h=[h,f,g];//the whole tooth profile
//-------------------------------------------------------------
//To rotate and append the tooth to generate the gear
for i=1:n;
    kk=[cos(2*%pi*(i-1)/n) sin(2*%pi*(i-1)/n);-sin(2*%pi*(i-1)/n) cos(2*%pi*(i-1)/n)];
    mm=kk*h;
    M=[M,mm];
end
M=[M,h(:,1)];
//plot one-half tooth, the involute curve part is red
plot (g(1,:),g(2,:),'-.b',xp,yp,'-r', 'linewidth',4);
//plot the whole gear
plot (M(1,:),M(2,:));
isoview
M=M';
