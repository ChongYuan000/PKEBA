%_________________________________________________________________________%
%__________________________________________
%Here is the entry point for the run, you should adapt the algorithm for the run
%__________________________________________

clear all 
clc
rng('default')
Function_name='F1'; 

Max_iteration=1000; 
% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name); 
nPop = 50; %popultaion size

[Best_pos,Best_score,curve] =algorithmName(fobj,lb,ub,dim,nPop,Max_iteration);

figure('Position',[269   240   660   290])
%Draw search space
subplot(1,2,1);
func_plot(Function_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])

%Draw objective space
subplot(1,2,2);
plot(TSA_curve,'Color','r')
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');

axis tight
grid on
box on
%Your algorithm
legend('')




