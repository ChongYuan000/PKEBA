% Main programs starts here
function [best,Convergence_curve]=PKEBA(SearchAgents_no,MaxFEs,lb,ub,dim,fobj)
%% parameters settings
% population size
n=SearchAgents_no;
% Dimension of the search variables
d=dim;
% Lower limit/bounds/ a vector
Lb=lb.*ones(1,d);
% Upper limit/bounds/ a vector
Ub=ub.*ones(1,d);

% Inherent components of BA, no user specification required
v=zeros(n,d);   % Velocities
A=rand(1,n)+ones(1,n);      % Loudness  (constant or decreasing)
r=rand(1,n);      % Pulse rate (constant or decreasing)
% This frequency range determines the scalings
% These parameter belongs to the origin BA 
% Qmin=0;          % Frequency minimum
% Qmax=2;         % Frequency maximum
% Q=zeros(n,1);   % Frequency
FEs=0;
%% parameters  settings end

% Initialize the population/solutions
for i=1:n,
    Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
    %Projection
    p= (cos(pi*randn(1,n))+1)/2;
    NewSol(i,:)=Sol(i,:).*p;
end
Hce=[Sol;NewSol];
for i=1:size(Hce,1)
    Hce(i,:)=simplebounds(Hce(i,:),Lb,Ub);
    FitnessHce(i)=fobj(Hce(i,:));
    FEs = FEs +1;
end
[FitnessHce2,index] = sort(FitnessHce);
Fitness = FitnessHce2(1:n);
Sol = Hce(index,:);
Sol = Sol(1:n,:);

%% Find the initial best solution
[fmin,I]=min(Fitness);
best=Sol(I,:);
Convergence_curve=[];

t=1;
%% Main loop
while  FEs < MaxFEs
    c= ((cos(pi*(FEs/MaxFEs))+1)*(1-FEs/MaxFEs))/2;
    %  d 
    de=(0.5)*exp(1/(1+5*FEs/MaxFEs));
    for i=1:n
        %%
        v(i,:)=de*v(i,:)+c*(best-Sol(i,:));
        S=Sol(i,:)+v(i,:);
        % Pulse rate
        if rand>r(i)
            T=randperm(n);
            T(T==i)=[];
            a=T(1);
            b=T(2);
            R=rand;
            y=Sol(a,:)+R.*(best-Sol(b,:));
            y=max(y,lb);
            y=min(y,ub);
            
            z=zeros(size(S));
            for j=1:dim
                if rand<=0.2 
                    z(j)=y(j); 
                else
                    z(j)=S(j);
                end
            end
            S=z;
        else
            S=best+A(i)*randn(1,d);
        end
        % Evaluate new solutions
        S=simplebounds(S,Lb,Ub);
        FEs=FEs+1;
        Fnew=fobj(S);
        % Update if the solution improves, or not too loud
        if (Fnew<=Fitness(i))
            Sol(i,:)=S;
            Fitness(i)=Fnew;
        end
    end
    for i=1:n,
        if ( Fitness(i)<fmin) && (rand<A(i))
            A(i) = 0.9*A(i);
            r(i) = r(i)*(1-exp((-0.9)*t));
        end
        if  Fitness(i)<=fmin
            best=Sol(i,:);
            fmin= Fitness(i);
        end
        %%
    end
    Convergence_curve(t)=fmin;
    t=t+1;
end
end

