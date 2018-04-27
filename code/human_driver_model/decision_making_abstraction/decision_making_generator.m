% DECISION_MAKING_GENERATOR - File that generates the decision making table
% in terms of probability of changing lanes at certain points

% Author: Francisco Girbal Eiras, MSc Computer Science
% University of Oxford, Department of Computer Science
% Email: francisco.eiras@cs.ox.ac.uk
% 24-Apr-2018; Last revision: 24-Apr-2018

%------------- BEGIN CODE --------------

clc

% Possible initial distances between the vehicles
ds = linspace(1,80,80);

% Possible vehicle initial velocity
vs = linspace(15,34,20);

generated_table = zeros(3*length(ds)*length(vs) + 3*length(ds), 7);
display(sprintf('Generating table of %d entries', size(generated_table,1)))
t1 = cputime;

mean_dt = [0,2,4];
std_dt = [0.6,0.3,1];

exp_param_dt = [1,0.3,0.2];

% the model will have a parameter 'driver_type' which is equal to
% 1 if aggressive, 2 if average or 3 if conservative
for driver_i = 1:3
    for d_i = 1:length(ds)
        for v_i = 1:length(vs)

            d = ds(d_i);
            v = vs(v_i);

            delta_crash = d/v;
            
%             x = 0:0.1:4;
%             val1 = exp(-1*x);
%             val2 = exp(-0.3*x);
%             val3 = exp(-0.2*x);
%             
%             figure;
%             hold on;
%             plot(x,val1);
%             plot(x,val2);
%             plot(x,val3);
%             
%             pause
%             
%             return

%             plC = 2*std_dt(driver_i)*normpdf(delta_crash,mean_dt(driver_i),std_dt(driver_i));
            plC = exp(-exp_param_dt(driver_i)*delta_crash);

            idx = (driver_i - 1)*length(ds)*length(vs) + (d_i - 1)*length(vs) + v_i;

            generated_table(idx,:) = [1,driver_i,d,v,round(delta_crash,2),round(plC,2),1-round(plC,2)];
        end
    end
end

mean_dd = [10,40,70];
std_dd = [20,7,20];

exp_param_dd = [0.05,0.015,0.008];

for driver_i = 1:3
    for d_i = 1:length(ds)
        
        d = ds(d_i);
        
%         x = 0:1:80;
%         val1 = exp(-0.05*x);
%         val2 = exp(-0.015*x);
%         val3 = exp(-0.008*x);
% 
%         figure;
%         hold on;
%         plot(x,val1);
%         plot(x,val2);
%         plot(x,val3);
% 
%         pause
% 
%         return
        
%         plC = 2*std_dd(driver_i)*normpdf(d,mean_dd(driver_i),std_dd(driver_i));

        plC = exp(-exp_param_dd(driver_i)*d);
        
        idx = 3*length(ds)*length(vs) + (driver_i - 1)*length(ds) + d_i;

        generated_table(idx,:) = [2,driver_i,d,-1,0,round(plC,2),1-round(plC,2)];
    end
end

display(sprintf('Generated in %.3f seconds', cputime - t1))

% Display the table
header = {'lane','type','d','v','delta_crash','P_lC','P_nlC'};
xForDisplay = [header; num2cell(generated_table)];
disp(xForDisplay)

% Save the table generated to a CSV file with a header
cHeader = header;
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
textHeader = textHeader(1:end-1);

%write header to file
fid = fopen('data/dm_table.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

%write data to end of file
dlmwrite('data/dm_table.csv',generated_table,'-append');

%------------- END OF CODE --------------