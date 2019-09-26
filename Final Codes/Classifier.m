
clear all

close all

%select a test data
action_test="jumping";
sensor_test=["acc"];
position_test=["shin"];


%select a train data
action=["climbingdown","running","walking","sitting","climbingup","jumping"];

%action=["climbingdown","climbingup","running","jumping","walking"];
%action=["jumping","walking"];
sensor=["acc"];
position=["shin"];


subLen=200;

%%%%%%%%%%%%%

Distance_Action=zeros(length(action),1);

for i1=1:length(action)
    sourcedata = "Cliques_"+action(i1);
    Cliques = xlsread(sourcedata+".xls");
    
    sourcedata = "MotifIndex_"+action(i1);
    MotifIndex = xlsread(sourcedata+".xls");
    
    sourcedata = "SignalMotifsNum_"+action(i1);
    SignalMotifsNum = xlsread(sourcedata+".xls");
    AccuMotifNum = cumsum(SignalMotifsNum);
    
    [q1,~]=size(Cliques);
    
    Action_Dis=0;
    for i2=1:q1
        Cli=Cliques(i2,:);
        Cli(Cli == 0) = [];
        
        q2=length(Cli);
        
        Clique_Dis=0;
        for i3=1:q2
           Node=Cli(i3);  % with node of the graph
           
           temp=find(AccuMotifNum >= Node);
           Signal_num=min(temp); % number of Signal that we want to choose
           
           %%% read the trainig string %Generelized that part later (now only for one sesor with three axises)
           source_file=sensor+"_"+action(i1)+"_"+position;
           M = csvread("S1\"+source_file+".csv",1,2);
           Signal=M(:,Signal_num);
            
           %%%
           loop1=1;
           j=0;
           while(loop1)  % choose an index that is not in beginning or end of the time series
               j=j+1;
               Index=MotifIndex(Node,j);
               if (Index >subLen/2 && Index <length(Signal)-subLen/2  )
                  break; 
               end
           end
           
           inquiry=Signal(Index-subLen/2+1:Index+subLen/2);
           
           Inq1 = reshape(zscore(inquiry(:)),size(inquiry,1),size(inquiry,2));
           
           source_file=sensor_test+"_"+action_test+"_"+position_test;  %read that signal of Test Data
           M = csvread("S3\"+source_file+".csv",1,2);
           Signal_test=M(:,Signal_num);
           
           Dist=Inf;
           for i4 = subLen/2+1:length(Signal_test)-subLen/2
               inquiry2=Signal_test(i4-subLen/2+1:i4+subLen/2);
               
               Inq2 = reshape(zscore(inquiry2(:)),size(inquiry2,1),size(inquiry2,2));
               
               D = norm(Inq1 - Inq2);
               %D = DNorm2(inquiry); %Faster
               
               Dist=min(Dist,D);                
           end           
           Clique_Dis=Clique_Dis+Dist;           
        end
        
        Distance_Clique=Clique_Dis/q2; 
        Action_Dis=Action_Dis+ Distance_Clique;
       
        
    end
    
    Distance_Action(i1)=Action_Dis/q1;    
end

[Value,Act]=min(Distance_Action);
Distance_Action
"Action is more likely to be "+string(action(Act))+" with distance "+string(Value)
