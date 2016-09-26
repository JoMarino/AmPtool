%% shprimpar
% generates survivor plots for primary parameters

%%
function shprimpar
%% created 2016/04/25 by Bas Kooijman

%% Syntax
% <../shprimpar *shprimpar*>

%% Description
% generates survivor plots for primary parameters
%
% Output: 
%
% * 12 png-files written in ../img: 
%
%    - Fm.png kapX.png pAm.png, v.png, kap.png, pM.png, EG.png, kJ.png, EHb.png, EHp.png, ha.png, sG.png

%% Remarks
% For presentation on the web, copy png files to 
% /home/websites/www.bio.vu.nl/webroot/thb/deb/deblab/add_my_pet/img

close all
shstat_options('y_label', 'on');

figure(1) % {F_m}, max spec searching rate
shstat_options('x_transform', 'log10');
Hfig = shstat({'F_m'}, [], '\{F_m\} at T_{ref}', 1);
xlabel('_{10}log \{F_m\}, dm^3/d.cm^2') % overwrite for better DEB notation
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca,'../img/Fm.png')

figure(2) % kappa_X, digestion efficiency
shstat_options('x_transform', 'none');
Hfig = shstat({'kap_X'}, [], [], 2);
xlabel('\kappa_X, -')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/kapX.png')

figure(3) % {p_Am}/z, scaled specific assimilation
shstat_options('x_transform', 'log10');
pAmz = read_allStat('p_Am','z','s_M');
Hfig = shstat(pAmz(:,1) ./ pAmz(:,2), [], '\{p_{Am}\} at T_{ref}', 3);
xlabel('_{10}log \{p_{Am}\}/z, J/d.cm^2')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/pAm.png')

figure(4) % v, energy conductance
shstat_options('x_transform', 'log10');
vsM = read_allStat('v', 's_M'); v = vsM(:,1); vj = prod(vsM,2);
shstat(vj, {'r', 'r'}, 'v at T_{ref}, before and after acceleration', 4);
Hfig = shstat(v,  {'b', 'b'}, [], 4);
xlabel('_{10} log v, cm/d')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/v.png')

figure(5) % kappa, allocation fraction to soma
shstat_options('x_transform', 'none');
Hfig = shstat({'kap'}, [], [], 5);
xlabel('\kappa, -') % overwrite for better DEB notation
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/kap.png')

figure(6) % [p_M], specific somatic maintenance
shstat_options('x_transform', 'log10');
Hfig = shstat({'p_M'}, [], '[p_M] at T_{ref}', 6);
xlabel('_{10}log [p_M], J/d') % overwrite for better DEB notation
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/pM.png')

figure(7) % [E_G] d_V, cost for structure
%shstat_options('x_transform', 'none');
shstat_options('x_transform', 'log10');
EGdV = read_allStat('E_G','d_V'); 
Hfig = shstat(EGdV(:,1) ./ EGdV(:,2), [], [], 7);
xlabel('[E_G]/ d_V, J/g')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/EG.png')

figure(8) % k_J, maturity maintenance rate coefficient
shstat_options('x_transform', 'none');
Hfig = shstat({'k_J'}, [], 'k_J at T_{ref}', 8);
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/kJ.png')

figure(9) % E_Hb/z^3, scaled maturity at birth
shstat_options('x_transform', 'log10');
EHbz = read_allStat('E_Hb','z'); 
Hfig = shstat(EHbz(:,1) ./ EHbz(:,2).^3, [], [], 9);
xlabel('_{10}log E_H^b/ z^3, J')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/EHb.png')

figure(10) % E_Hp/z^3, scaled maturity at puberty
shstat_options('x_transform', 'log10');
EHpz = read_allStat('E_Hp','z'); 
Hfig = shstat(EHpz(:,1) ./ EHpz(:,2).^3, [], [], 10);
xlabel('_{10}log E_H^p/ z^3, J')
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/EHp.png')

figure(11) % h_a, ageing acceleration
shstat_options('x_transform', 'log10');
Hfig = shstat({'h_a'}, [], 'h_a at T_{ref}', 11);
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/ha.png')

figure(12) % s_G, Gompertz stress coefficient
shstat_options('x_transform', 'none');
Hfig = shstat({'s_G'}, [], [], 12);
set(gca, 'FontSize', 15, 'Box', 'on')
saveas(gca, '../img/sG.png')
