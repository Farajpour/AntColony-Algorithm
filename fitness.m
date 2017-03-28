function sol=fitness(sol,data)

x=sol.x;
Dis=data.Dis;
N=numel(x);

Z=0;
for k=1:N-1
    i=x(k);
    j=x(k+1);
    Z=Z+Dis(i,j);
end


sol.fit=Z;



end
