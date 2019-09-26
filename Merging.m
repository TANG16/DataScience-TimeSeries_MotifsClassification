function [SignalMotifInd]=Merging(motifIdxs10,subLen,threshold)
    [q1,~]=size(motifIdxs10);
    
    MaxMotifs=12;
     SignalMotifInd=zeros(q1,MaxMotifs);
     for m=1:q1
           temp1=cell2mat(motifIdxs10(m,1));
           temp2=cell2mat(motifIdxs10(m,2));
           temp3=[temp1,temp2];
                        
           SignalMotifInd(m,1:length(temp3))=temp3;
     end
     
     
     %merging
     n1=0;
     n2=0;
     
     loop1=1;
     loop2=1;
     
     while (loop1)
         n1= n1 +1;
         n2=n1;
         while (loop2)
             n2=n2+1;
                   
             vec1=SignalMotifInd(n1,:);
             vec2=SignalMotifInd(n2,:);
                       
             vec1(vec1 == 0) = [];
             vec2(vec2 == 0) = [];
                       
             acc=0;
             for m1=1:length(vec1) 
                 temp1=vec1(m1);
                 for m2=1:length(vec2)
                         temp2=vec2(m2);
                         if abs(temp1-temp2)<subLen
                              acc=acc+1;
                              break;
                         end
                 end
             end
                       
             Pr=acc/min(length(vec1),length(vec2));
             
             
             win=subLen;
             if Pr>threshold  %check if they are close enough, in that case merge them
                     vec3=union(vec1,vec2);
                     vec3=unique(vec3);
                     vec3=sort(vec3);
                     
                     vec4=vec3;
                     j=0;
                     for i=1:length(vec3)-1
                         if vec3(i+1)-vec3(i)<win
                            vec4(i-j)=[];
                            j=j+1;
                         end
                     end
                     
                     [~,q2]=size(SignalMotifInd);
                     SignalMotifInd(n1,:)=zeros(1,q2);
                     SignalMotifInd(n1,1:length(vec4))=vec4;
                     
                     SignalMotifInd(n2,:)=[];
                
             end
             
            [q2,~]=size(SignalMotifInd);
            if n2 >=q2
                loop2=0;
                break;
            end
                      
         end
         
        loop2=1;
        [q1,~]=size(SignalMotifInd);
        if n1>=q1-1
            loop1=0;
            break;
        end
    end
    
    
end
             