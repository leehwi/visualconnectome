function VisCon_ImportSurfDlg()

hFig = findobj('Tag','VisConFig');
FigPos = get(hFig,'Position');
DlgPos = [FigPos([1 2])+FigPos([3 4])/2-[170 0], 340, 170];

LSurfData = [];
RSurfData = [];

hImportSurfDlg = dialog('Name', 'Import Brain Surface ...',...
    'Units','Pixel','Position',DlgPos);

hImportLeftSurfBtn = uicontrol(...
    'Parent',hImportSurfDlg,...
    'Callback',@ImportLeftSurfBtnFcn,...
    'Position',[20 125 110 24],...
    'String','Import Left Surface');
    function ImportLeftSurfBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.lh;*.obj','Brain Surface File Format';...
            '*.*','All Files (*.*)'},...
            'Import Left Surface ...');
        if Type ~= 0
            try
                LSurf = SurfStatReadSurf(fullfile(Path,File));
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:unassignedOutputs')
                    errordlg(sprintf('%s is not a valid brain surface file!', File),...
                        'Import Left Surface');
                    return;
                end
            end
            LSurfData.Faces = LSurf.tri;
            LSurfData.Vertices = LSurf.coord.';
            set(hImportRightSurfBtn, 'Enable', 'on');
        end
        if ~isempty(LSurfData) && ~isempty(RSurfData)
            set(hImportSurfOKBtn, 'Enable', 'on');
        end
    end

hImportRightSurfBtn = uicontrol(...
    'Parent',hImportSurfDlg,...
    'Callback',@ImportRightSurfBtnFcn,...
    'Position',[20 70 110 24],...
    'String','Import Right Surface',...
    'Enable','off');
    function ImportRightSurfBtnFcn(Src, Evnt)
        [File,Path,Type] = uigetfile({'*.rh;*.obj','Brain Surface File Format';...
            '*.*','All Files (*.*)'},...
            'Import Right Surface ...');
        if Type ~= 0
            try
                RSurf = SurfStatReadSurf(fullfile(Path,File));
            catch Error
                if strcmpi(Error.identifier, 'MATLAB:unassignedOutputs')
                    errordlg(sprintf('%s is not a valid brain surface file!', File),...
                        'Import Right Surface');
                    return;
                end
            end
            RSurfData.Faces = RSurf.tri;
            RSurfData.Vertices = RSurf.coord.';
        end
        if ~isempty(LSurfData) && ~isempty(RSurfData)
            set(hImportSurfOKBtn, 'Enable', 'on');
        end
    end

hImportSurfOKBtn = uicontrol(...
    'Parent',hImportSurfDlg,...
    'Callback',@ImportSurfOKBtnFcn,...
    'Position',[105 15 60 24],...
    'String','OK',...
    'Enable','off');
    function ImportSurfOKBtnFcn(Src, Evnt)
        SetVisConData('LSurfData',LSurfData);
        SetVisConData('RSurfData',RSurfData);
        VisCon_SetEnable('VisConMenuLSurfVis','on');
        VisCon_SetEnable('VisConMenuRSurfVis','on');
        VisCon_SetEnable('VisConMenuBothSurfVis','on');
        VisCon_SetEnable('VisConTbarSurfVis','on');
        delete(hImportSurfDlg);
        BrainSurf on;
    end

uicontrol(...
    'Parent',hImportSurfDlg,...
    'Callback',@ImportSurfCancelBtnFcn,...
    'Position',[175 15 60 24],...
    'String','Cancel');
    function ImportSurfCancelBtnFcn(Src, Evnt)
        delete(hImportSurfDlg);
    end

uicontrol(...
    'Parent',hImportSurfDlg,...
    'HorizontalAlignment','left',...
    'Position',[140 121 185 30],...
    'String','FreeSurfer surface file format of left hemisphere (.lh), or obj file format',...
    'Style','text');

uicontrol(...
    'Parent',hImportSurfDlg,...
    'HorizontalAlignment','left',...
    'Position',[140 66 185 30],...
    'String','FreeSurfer surface file format of right hemisphere (.lh), or obj file format',...
    'Style','text');

end

