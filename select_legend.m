%% select_marker
% graphical user interface for setting marker

%%
function legend = select_legend(legend)
%% created 2016/02/28 by Bas Kooijman

%% Syntax
% legend = <../select_legend.m *select_legend*> (legend)

%% Description
% Select or edit a legend; the active row is indicated and can be changed with button #. 
% Edit maker specs with button marker and taxon name with button taxon.
% Edit the sequence with buttons v and ^, insert with >, remove with x. 
% The sequence matters if taxa are not mutually exclusive and some markers will be plotted on top of each other.
%
% Input:
%
% * legend: optional (n,2)-matrix with markers (5-vector of cells) and taxa (string)
%
% Output: 
% 
% * legend: (m,2)-matrix with markers (5-vector of cells) and taxa (string)

%% Remarks
% Complete marker specs edit by pressing Esc.
% Press Esc when done with editing ledend specs.

%% Example of use
% legend = select_legend;

  global legend_local i_legend Hlegend
  
  if ~exist('legend', 'var')
    legend_local = {{'.', 10, 4, [0 0 0], [0 0 0]}, 'Animalia'; ...
                    {'o', 10, 4, [1 0 0], [1 0 0]}, 'Chordata'; ...
                    {'o', 10, 4, [0 0 1], [0 0 1]}, 'Aves';};
  else
    legend_local = legend;
  end

  n = size(legend_local,1); i_legend = n;
  x = 30; y = 10; % lower-left corner of botton block
  dx = 60;        % width of botton
  HFig_legend = figure('Position', [500, 800, 8*dx, dx]);
  
  % Component
  Hnr     = uicontrol('Style','pushbutton',...
           'String', '#',...
           'Position',[x,y,.9*dx,.5*dx], ...
           'Callback', @nr_Callback);
  Hmarker = uicontrol('Style','pushbutton',...
           'String', 'marker',...
           'Position',[x+dx,y,.9*dx,.5*dx], ...
           'Callback', @marker_Callback);
  Htaxon   = uicontrol('Style','pushbutton',...
           'String', 'taxon', ...
           'Position',[x+2*dx,y, .9*dx,.5*dx], ...
           'Callback', @taxon_Callback);
  Hup   = uicontrol('Style','pushbutton',...
           'String', '^', ...
           'Position',[x+3*dx,y,.9*dx,.5*dx], ...
           'Callback', @up_Callback);    
  Hdown  = uicontrol('Style','pushbutton', ...
           'String','v',...
           'Position',[x+4*dx,y,.9*dx,.5*dx], ...
           'Callback', @down_Callback);
  Hinsert  = uicontrol('Style','pushbutton', ...
           'String','<',...
           'Position',[x+5*dx,y,.9*dx,.5*dx], ...
           'Callback', @insert_Callback);
  Hremove  = uicontrol('Style','pushbutton', ...
           'String','x',...
           'Position',[x+6*dx,y,.9*dx,.5*dx], ...
           'Callback', @remove_Callback);
        
  Hlegend = shlegend(legend_local,[],[],i_legend);
  pause
 
  close (HFig_legend)
  legend = legend_local; % export to output
end

%% subfunctions
    function C = nr_Callback(source, eventdata) 
      global legend_local i_legend Hlegend
      list = {num2str((1:size(legend_local,1))')};
      i_legend = listdlg('PromptString', 'Select #', 'ListString', list, 'Selectionmode', 'single', 'InitialValue', i_legend);
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = marker_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      legend_local(i_legend,1) = {select_marker(legend_local{i_legend,1})}; 
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = taxon_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      legend_local(i_legend,2) = {select_taxon};
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = up_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      if i_legend > 1
        legend_local([i_legend-1, i_legend],:) = legend_local([i_legend, i_legend-1],:);
        i_legend = i_legend - 1; 
     end
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = down_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      if i_legend < size(legend_local,1)
        legend_local([i_legend, i_legend+1],:) = legend_local([i_legend+1, i_legend],:);
        i_legend = i_legend + 1; 
      end
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = insert_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      n = size(legend_local,1); N = (1:n)'; new = {{'.', 12, 4, [0 0 0], [0 0 0]}, 'Animalia'};
      legend_local = [legend_local(N<i_legend,:); new; legend_local(N>=i_legend,:)];
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end
    function C = remove_Callback(source, eventdata) 
      global legend_local  i_legend Hlegend
      n = size(legend_local,1); N = (1:n)'; 
      legend_local = legend_local(~(N==i_legend),:);
      close(Hlegend); Hlegend = shlegend(legend_local,[],[],i_legend);
    end