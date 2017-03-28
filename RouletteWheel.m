function j=RouletteWheel(P)

if all(P==0)
    P=P+rand;
end

P=P./sum(P);
P=cumsum(P);
j=find(rand<=P,1,'first');


end