function handles=SimParam_Brain(h)

handles=h;

%tumor parameters
handles.maxSUV=7;
handles.maxCtrast=12.5;
handles.blurSize=4;

% counts parameters
handles.RF=0.4;
handles.SF=0.4;
handles.ScanTime=180;
handles.ActV=5;
handles.Se=6.5;
handles.overlap=0.23;

% scanner parameters

handles.tanBin=280;
handles.RingSize=700;
handles.PSF=4;

        % reconstruction parameters
handles.SimSize=256;
handles.postFilter=4;
handles.IterNum=4;
handles.SubNum=14;
handles.nRep=1;


handles.LOAD_ITER='false';
handles.LOAD_REPS='false';
handles.zFilterListboxVal=3;