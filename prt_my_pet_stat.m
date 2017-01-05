%% prt_my_pet_stat
% Creates my_pet_stat.html 

%%
function prt_my_pet_stat(metaData, metaPar, par, destinationFolder)
% created 2016/03/30 Starrlight; modified 2016/09/23 Starrlight Augustine; 2016/11/05 Bas Kooijman

%% Syntax
% <../prt_my_pet_stat.m *prt_my_pet_stat*> (metaData, metaPar, par, destinationFolder) 

%% Description
% Read and writes my_pet_stat.html and write png files in current folder (irrespective of destinationFolder). 
% This pages contains a list of implied model properties of my_pet. 
% It calls entries_admin/get_statfields to see what statistics are printed in which order on the web.
%
% Input:
%
% * metaData: structure (output of <http://www.debtheory.org/wiki/index.php?title=Mydata_file *mydata_my_pet_par*> file)
% * metaPar: structure (output of <http://www.debtheory.org/wiki/index.php?title=Pars_init_file *pars_init_my_pet_par*> file)
% * par: structure (output of <http://www.debtheory.org/wiki/index.php?title=Pars_init_file *pars_init_my_pet_par*> file)
% * destinationFolder: optional string with destination folder to which my_pet_stat.html is printed (default: current folder)

%% Example of use
% load('results_my_pet.mat');
% prt_my_pet_stat(metaData, metaPar, par, destinationFolder)

% Removes underscores and makes first letter of english name be
% in capital:
speciesprintnm = strrep(metaData.species, '_', ' ');
speciesprintnm_en = strrep(metaData.species_en, '_', ' ');
if speciesprintnm_en(1)>='a' && speciesprintnm_en(1)<='z'
  speciesprintnm_en(1)=char(speciesprintnm_en(1)-32);
end

f = 1; % ad libitum feeding
[stat, txtStat] = statistics_st(metaPar.model, par, metaData.T_typical, f);
stat.z = par.z; txtStat.label.z = 'zoom factor'; txtStat.units.z = '-'; % add zoom factor to statistics which are to be printed 

pie_SGGJR(metaData.species, metaPar.model, par, stat, 1); % print 4 png-files for energy allocation to current folder

% flds = fieldnmnst_st(stat); % fieldnames of all statistics
[webStatFields, webColStat] = get_statfields(metaPar.model); % which statistics in what order should be printed in the table

if exist('destinationFolder','var')
fileName = [destinationFolder, metaData.species, '_stat.html'];
else
fileName = [metaData.species, '_stat.html'];    
end
oid = fopen(fileName, 'w+'); % % open file for writing, delete existing content

fprintf(oid, '<!DOCTYPE html>\n');
fprintf(oid, '<HTML>\n');
fprintf(oid, '<HEAD>\n');
fprintf(oid,['  <TITLE>',metaData.species,'</TITLE>\n']);
fprintf(oid, '  <link rel="stylesheet" type="text/css" href="../sys/style.css">\n'); 
fprintf(oid, '  <script src="../sys/dropdown.js"></script>\n');
fprintf(oid, '  <script src="../sys/w3data.js"></script>\n');
fprintf(oid, '</HEAD>\n\n');
fprintf(oid, '<BODY>\n\n');

fprintf(oid, '<div w3-include-html="../sys/wallpaper_entry.html"></div>\n');
fprintf(oid, '<div w3-include-html="../sys/toolbar_entry.html"></div>\n');
fprintf(oid, '<script>w3IncludeHTML();</script>\n\n');

fprintf(oid, '<!--------------------------------------------------------------->\n');
fprintf(oid, '<!-- PART menuBar                                              -->\n');
fprintf(oid, '<!-- TOP PART OF WEBPAGE IS FIXED                              -->\n');
fprintf(oid, '<!-- It has the logo and the menu with Javascript              -->\n');
fprintf(oid, '<!--   dropdown menus                                          -->\n');
fprintf(oid, '<!-- Please put in bold and in fancy the right links           -->\n');
fprintf(oid, '<!--------------------------------------------------------------->\n\n');

fprintf(oid, '<div id="top2">\n');
fprintf(oid, '  <h1 class="alignleft2"> &nbsp; &nbsp;\n');
% ---------- makes links to the wikipedia page if it exists
if isfield(metaData.biblist,'Wiki') %|| isfield(metaData.biblist,'wiki')
  url = eval(['metaData.biblist.', 'Wiki']);
  url(1: strfind(url, 'http') - 1) = [];
  url = url(1: strfind(url, '}') - 1);
  fprintf(oid,['    <A HREF = "',url,'" target = "_blank">',speciesprintnm,'</A> (',speciesprintnm_en,'): &nbsp;\n']);
elseif isfield(metaData.biblist,'wiki') %|| isfield(metaData.biblist,'wiki')
  url = eval(['metaData.biblist.', 'wiki']);
  url(1: strfind(url, 'http') - 1) = [];
  url = url(1: strfind(url, '}') - 1);
  fprintf(oid,['    <A HREF = "',url,'" target = "_blank">',speciesprintnm,'</A>(',speciesprintnm_en,'): &nbsp;\n']);
end
if isfield(metaData.biblist,'Wiki') ==0
  fprintf(oid, [speciesprintnm,'(',speciesprintnm_en,') &nbsp;\n']);
end
% ----------------------------------------------------------------------
fprintf(oid, '  </h1>\n\n');

fprintf(oid, '  <div id="navwrapper">\n');
prt_toolbar_species(oid, metaData.species)
fprintf(oid, '  </div><!-- end of navwrapper -->\n');
fprintf(oid, '</div><!-- end of top2 -->\n\n');

fprintf(oid, '<!--------------------------------------------------------------->\n');
fprintf(oid, '<!--   PART main                                               -->\n');
fprintf(oid, '<!--   Where all of the text is placed                         -->\n');
fprintf(oid, '<!--   use "contentFull" for 1 column                          -->\n');
fprintf(oid, '<!--   use "content" if you want two columns"                  -->\n');
fprintf(oid, '<!--------------------------------------------------------------->\n\n');

fprintf(oid, '<div id = "main">\n');
fprintf(oid, '  <div id = "main-wrapper">\n');
fprintf(oid, '    <div id="contentFull">\n');
fprintf(oid, '      <H1 id = "portaltop">Implied properties for this entry </H1>\n');	
			
% print out text before the tables
% fprintf(oid, '<H2>Implied properties for this entry</H2>');
fprintf(oid,['      <H2>Model: <a class="link" target = "_blank" href="http://www.debtheory.org/wiki/index.php?title=Typified_models" >&nbsp;', metaPar.model,' &nbsp;</a></H2>\n\n']);

% print SGJR pies
fprintf(oid, '      <H3>Energy investment, cumulated over the embryo period (left), and allocation during ontogeny</H3>\n');
fprintf(oid, '      <div>\n');
fprintf(oid,['        <img src="../entries/', metaData.species, '/', metaData.species, '_pie_SGJRb.png"  width="260px">\n']);
fprintf(oid,['        <img src="../entries/', metaData.species, '/', metaData.species, '_pie_pSGJRb.png" width="260px">\n']);
fprintf(oid,['        <img src="../entries/', metaData.species, '/', metaData.species, '_pie_pSGJRp.png" width="260px">\n']);
fprintf(oid,['        <img src="../entries/', metaData.species, '/', metaData.species, '_pie_pSGJRi.png" width="260px">\n']);
fprintf(oid, '      </div>\n\n');
fprintf(oid, '      <div class = "caption">   \n');
fprintf(oid, '        Exploding sectors mean dissipation; numbers denote fractions of mobilized reserve. \n');
fprintf(oid, '        Endpoints are somatic maintenance S, growth G, maturity maintenance J, maturity or reproduction R.\n'); 
fprintf(oid, '        The difference between assimilation p_A and mobilization p_C is used to increase reserve.\n');
fprintf(oid, '      </div>\n\n');
fprintf(oid, '      <p><p>\n');

% print the table with the properties :    
fprintf(oid, '      <TABLE id = "t01">\n');
fprintf(oid, '        <TR BGCOLOR = "#FFE7C6"><TH colspan="4">Implied properties at typical temperature (%g deg. C)</TH></TR>\n', K2C(metaData.T_typical));
fprintf(oid, '        <TR BGCOLOR = "#FFE7C6"><TH>symbol</TH><TH> value</TH><TH> units</TH><TH> description</TH></TR>\n');
for i = 1:length(webStatFields)
  fprintf(oid, '        <TR BGCOLOR = "%s"> <TD>%s</TD> <TD>%g</TD> <TD>%s</TD><TD>%s</TD></TR>\n',...
    webColStat.(webStatFields{i}), webStatFields{i}, stat.(webStatFields{i}), ...
    txtStat.units.(webStatFields{i}), txtStat.label.(webStatFields{i}));
end 
fprintf(oid, '      </TABLE>\n\n');

fprintf(oid, '    </div> <!-- end of content -->\n\n');

fprintf(oid, '    <div w3-include-html="../sys/footer_amp.html"></div>\n');
fprintf(oid, '    <script>w3IncludeHTML();</script>\n\n');

fprintf(oid, '  </div> <!-- main wrapper -->\n');
fprintf(oid, '</div> <!-- main -->\n');

fprintf(oid, '</BODY>\n');
fprintf(oid, '</HTML>\n');

fclose(oid);


