function [SignalMotifInd]=Merging(motifIdxs10,subLen,threshold,data)
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
             
             
             [AveVec1,AveDis1]=CheckMotif(vec1,subLen,data);
             [AveVec2,AveDis2]=CheckMotif(vec2,subLen,data);
             
             Dis= max(xcov(AveVec1,AveVec1));
             
             Pr= Dis^2/(AveDis1*AveDis2);
             

             
             win=subLen/3;
             if Dis <= max(AveDis1,AveDis2)%Pr<threshold  %check if they are close enough
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


function [AveVec1,AveDis1]=CheckMotif(vec1,subLen,data)
             vec11=vec1;
             for i=1:length(vec1)
                if (vec1(i)> subLen/2+1 && vec1(i) < length(data)+subLen/2-1)
                   vec11(i)=[]; 
                   break;
                end
             end
             
             temp1=data(vec1(i)-floor(subLen/2):vec1(i)+floor(subLen/2)-1);
             AveVec1=temp1;
             SumDis1=0;
             for m1=2:length(vec11)
                startInx= max(1,vec11(m1)-floor(subLen/2));
                stopInx=min(length(data),vec11(m1)+floor(subLen/2)-1);
                 
                temp2=data(startInx:stopInx);
                
                temp3=max(xcov(temp1,temp2));
                SumDis1=SumDis1+temp3;
                    
                if temp2(1)==data(1)
                    str=1;
                    spt=length(temp2);
                    AveVec1(str:spt)=AveVec1(str:spt)+1/(m1+1)*(temp2(str:spt)-AveVec1(str:spt));
                elseif temp2(length(temp2))==data(length(data))
                    str=length(temp1)-length(temp2)+1;
                    spt=length(temp1);
                    AveVec1(str:spt)=AveVec1(str:spt)+1/(m1+1)*(temp2(str:spt)-AveVec1(str:spt));
                else
                  AveVec1=AveVec1+1/(m1+1)*(temp2-AveVec1);
                end
                
             end
             
             AveDis1=SumDis1/length(vec1);
end