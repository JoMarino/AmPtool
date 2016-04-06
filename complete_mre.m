%% complete_mre
% gives COMPLETE, and MRE 

%%
function CM = complete_mre
%% created 2016/02/21 by Bas Kooijman

%% Syntax
% CM = <../complete_mre.m *complete_mre*>

%% Description
% COMPLETE and MRE in the sequence of select('Animalia')
%
%
% Output: 
% 
% * CM: (n,2)-matrix with COMPLETE, MRE for all n entries in the collection

%% Remarks
% The sequence of rows in CM is select('Animalia') 
% about_add_my_pet make a plot of this

%% Example of use
% complete_mre

  entries = select('Animalia');
  n = length(entries);
  CM = zeros(n,2);
   
  WD = pwd;                % store current path
  cd(['../entries/',entries{1}]) % goto entries

    for i = 1:n
        
      try
      cd (['../', entries{i}])
      load (['results_', entries{i}])
      CM(i,:) = [metaData.COMPLETE, metaPar.MRE]; 
      
      catch 
          fprintf('%s is not in the entries directory \n',entries{i})
          CM(i,:) = [NaN, NaN];
      end
      
    end
   
  cd(WD)  % goto original path



end
