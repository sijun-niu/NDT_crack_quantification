%%% Add dummy data point in experimental signal to match simulation %%%
clc
clear all
close all

experiment = xlsread('../Xometry new samples/top_left.xlsx');
simulation_data1 = xlsread('../Experimental_signal/Sample6_sim.xlsx');

%% A loop to find the best signal
start_indices = 2;
end_indices = 3375;
scaling = 2;

%%
% Choose a signal to use
column = 1;
experiment_data = experiment(:,column);

experiment_data = experiment_data + 10;
time = [0:2e-9:8e-6];

start_index = start_indices;
end_index = end_indices;
useful_len = end_index - start_index;
target_len = length(time);

dummy = round(start_index:(target_len - start_index)/(4000-(end_index-start_index)):4001);

new_signal = linspace(0,0,target_len);
new_signal(dummy) = 1;

j = start_index;
for i = 1:target_len
    if new_signal(i) == 0
        new_signal(i) = experiment_data(j);
        j = j + 1;
    else
        new_signal(i) = new_signal(i-1);
    end
end

experiment_data = experiment_data - 10;
new_signal = new_signal - 10;

final_signal = linspace(0,0,target_len);
end_index = 3400;
offset = 10;
start_index = target_len - end_index;
final_signal(start_index:end) = new_signal(offset:end_index+offset);

simulation_data1(1:600) = 0;
final_signal(1:600) = 0;

exp_out = 'C:\Users\sniu3\Documents\python_work\ellip_3D_CNN\exp_final_model5\';
writematrix(final_signal/10^12/scaling, [exp_out,'top_right.txt']);

%%
% figure
% plot(time,final_signal/10^12/2,'linewidth',3)
% xlim([0,10^-5])
% hold on
% plot(time,abs(simulation_data1),'linewidth',3)
% box on
% ylabel('Displacement (m)')
% xlabel('Time (s)')
% legend('Experiment','Simulation')
% set(gca,'FontSize',44)
% set(gca,'YColor','k')
% set(gca,'LineWidth',2);
% set(gcf,'Units','Inches');
% set(gcf,'Position',[2 0.2 1.5*10. 1.37*7.5])