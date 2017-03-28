clc
clear all
close all
format shortG

%% Insert Data

data=InsertData();


nvar=data.nvar; % number of variable
Dis=data.Dis; % Distance Matrix

n_ant=10;        % number of ant

maxiter=100;      % max of iteration


Snode=input('Start Node = ');
Fnode=input('Final Node = ');


%% initialization

tau0=1;
tau=tau0*ones(nvar,nvar);  % phromone matrix
tau=tau-diag(diag(tau));

etha=1./Dis;               % hueristic information matrix
etha=etha-diag(diag(etha));
etha(isinf(etha))=0;
etha(isnan(etha))=0;
Q=100;
alpha=2;
beta=1;

Roh=0.02;

U=reshape(1:nvar*nvar,nvar,nvar);

%% main loop
tic

emp.x=[];
emp.fit=[];

ant=repmat(emp,n_ant,1); % population

gant.x=[];               % global ant
gant.fit=inf;

BEST=zeros(maxiter,1);
MEAN=zeros(maxiter,1);



Route=[Snode Fnode];
URoute=U(Snode,Fnode);
ant(1).x=Route;
ant(1)=fitness(ant(1),data);
L=ant(1).fit;
tau(URoute)=tau(URoute)+(Q/L);
gant=ant(1);

for iter=1:maxiter
    
    for k=1:n_ant
        
        Route=Snode;
        URoute=zeros(1,nvar);
        
        for v=2:nvar
            i=Route(end);
            P=(tau(i,:).^alpha).*(etha(i,:).^beta);
            P(Route)=0;
            j=RouletteWheel(P);
            [Route]=[Route j];
            URoute(v-1)=U(i,j);
            
            if j==Fnode
                break
            end
            
        end
        
        
        ant(k).x=Route;
        ant(k)=fitness(ant(k),data);
        
        
        L=ant(k).fit;
        URoute(URoute==0)=[];
        tau(URoute)=tau(URoute)+(Q/L);
    end
    
    tau=tau*(1-Roh);
    
    
    [value,index]=min([ant.fit]);
    
    if value<gant.fit
        gant=ant(index);
    end
    
    
    
    
    %Update BEST Matrix
    BEST(iter)=gant.fit;
    
    disp([ ' iter = '  num2str(iter)   ' BEST = '  num2str(BEST(iter)) ])
    


    
end

%% results


disp('======================================================')
disp([ ' BEST solution = '   num2str(gant.x)]);
disp([ ' BEST fitness = ' num2str(gant.fit)]);
disp([ ' Time = '  num2str(toc)])



figure
semilogy(BEST,'r','LineWidth',2);


xlabel(' iteration ')
ylabel('fitness')
legend('BEST')
title(' ACO for SPP ')

