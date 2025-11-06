FolderName = 'HeadToTail_Diff';

dirPath = fullfile('..', 'figures', FolderName);
if ~exist(dirPath, 'dir')
    mkdir(dirPath); % Create the directory if it does not exist
end
counter = 0;

FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  counter = counter +1;
  FigHandle = FigList(iFig);
  FigName   = num2str(counter);

  % FigName   = num2str(get(FigHandle, 'Name'));
  set(0, 'CurrentFigure', FigHandle);
  saveas(FigHandle, fullfile(dirPath,strcat(FigName, '.png')));
  % saveas(FigHandle, fullfile(dirPath,strcat(FigName, '.fig'))); % specify the full path
end