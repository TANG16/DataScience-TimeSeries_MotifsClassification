adjacency_graph=zeros(q);
for i = 1: q
   for j = i+1:q
       vec1=NodeIndex(i,:);
       vec2=NodeIndex(j,:);
       
       vec1(vec1 == 0) = [];
       vec2(vec2 == 0) = [];
       
       n1=length(vec1);
       n2=length(vec2);
       
       consecuence=0;
       for m =1:n1
           temp1=vec1(m);
           for n=1:n2
               temp2=vec2(n);
               
               Dis=abs(temp1-temp2);
               if (Dis<500) %we can change the defination to be co-occurance if necessary 
                   consecuence=consecuence+1;
                   break;
               end
               
           end
       end
       
      adjacency_graph(i,j)=consecuence/max(n1,n2);
      adjacency_graph(j,i)=adjacency_graph(i,j);
       
   end
end
