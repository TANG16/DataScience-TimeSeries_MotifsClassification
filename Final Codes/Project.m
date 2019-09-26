
clear all

close all


action='jumping';
%sensor=["acc","Gyroscope"];
sensor=["acc"];
position=["shin"];

subLen=200;

dataName=string([]);
Time_Series=string([]);

SignalMotifsNum=[];
MotifIndex=[];

for i=1:length(sensor)
    for j=1:length(position)
        source_file=sensor(i)+"_"+action+"_"+position(j);
        dataName((i-1)*length(position)+j)=source_file;
        %Data wrapping
        
        %To deal with different time tag, find max start tag and maximum
        %finish tag here, then we need to go with either smoothing or
        %linear interpoltation, all will do that later
         M = csvread("S1\"+source_file+".csv",1,2);
        [~,q]=size(M);
        %check the lenght of data here, it bigger than what we need, prone
        %it
            for n=1:q
                Time_Series=[Time_Series;source_file+"_"+string(n)];
                data=M(:,n);
                [matrixProfile, profileIndex, motifIndex, discordIndex,motifIdxs10] = interactiveMatrixProfileVer2(data, subLen);
                %[matrixProfile, profileIndex, motifIndex, discordIndex] = interactiveMatrixProfileVer2(data, subLen);
                
                threshold=1.2;
                SignalMotifInd=Merging2(motifIdxs10,subLen,threshold,data);
                
                [q1,q2]=size(SignalMotifInd);
                SignalMotifsNum=[SignalMotifsNum,q1];
                
                [q3,q4]=size(MotifIndex);
                if (q4~=0 && q4<q2)
                    MotifIndex=[MotifIndex,zeros(q3,q2-q4)];
                elseif (q4~=0 && q4>q2)
                    SignalMotifInd=[SignalMotifInd,zeros(q1,q4-q2)];
                 end
                
                MotifIndex=[MotifIndex;SignalMotifInd];


            end
        
    end
end



% Construct the co-occurance matrix
[q,~]=size(MotifIndex);
adjacency_graph=zeros(q);
for i = 1: q
   for j = i+1:q
       vec1=MotifIndex(i,:);
       vec2=MotifIndex(j,:);
       
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
               if (Dis<subLen/2) %we can change the defination to be co-occurance if necessary 
                   % Here we can define another kind of distance
                   consecuence=consecuence+1;
                   break;
               end
               
           end
       end
       
      adjacency_graph(i,j)=consecuence/max(n1,n2);
      adjacency_graph(j,i)=adjacency_graph(i,j);
       
   end
end

if exist("adjacency_graph_"+action+".xls", 'file')==2
  delete("adjacency_graph_"+action+".xls");
end

if exist("SignalMotifsNum_"+action+".xls", 'file')==2
  delete("SignalMotifsNum_"+action+".xls");
end

if exist("MotifIndex_"+action+".xls", 'file')==2
  delete("MotifIndex_"+action+".xls");
end


xlswrite("adjacency_graph_"+action,adjacency_graph)
xlswrite("SignalMotifsNum_"+action,SignalMotifsNum)
xlswrite("MotifIndex_"+action,MotifIndex)



GraphSparse = sparse(adjacency_graph);
[S,C] = graphconncomp(GraphSparse,'Directed', false);
