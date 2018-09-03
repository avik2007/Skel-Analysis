%%
figure()
hold on

cont_force_l = dlmread('linear_continuum.txt');
plot(cont_force_l(:,1),cont_force_l(:,2),'linewidth',4)

l_skel = dlmread('lslice_split9_new6.txt');
disps_l = l_skel(:,1);forces_l=l_skel(:,2);
plot(disps_l,forces_l,'linewidth',4,'linestyle',':');

cont_force_nl = dlmread('nonlinear_continuum.txt');
plot(cont_force_nl(:,1),cont_force_nl(:,2),'linewidth',4)

nl_skel = dlmread('nlslice_split9_new.txt');
disps_nl = nl_skel(:,1);forces_nl=nl_skel(:,2);
plot(disps_nl,forces_nl,'linewidth',4);

legend({'Continuum linear','Beam-element linear', 'Continuum nonlinear','Beam-element nonlinear'},'fontsize',20,'location','northwest');

xlabel('Displacement (mm)','fontsize',14)
ylabel('Reaction force (N)','fontsize',14)
set(gca,'fontsize',14)
xlim([0 0.4])