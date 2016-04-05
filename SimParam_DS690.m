function handles=SimParam_DS690(h)


handles=h;

%tumor parameters
handles.maxSUV=0;
handles.maxCtrast=12.5;
handles.blurSize=4.9;

% counts parameters
handles.RF=0.0717;
handles.SF=0.34375;
handles.ScanTime=180;
handles.ActV=7.26;
handles.Se=6.5;
handles.overlap=0.23;

% scanner parameters
handles.tanBin=288;
handles.RingSize=700;
handles.PSF=4.9;

        % reconstruction parameters
handles.SimSize=256;
handles.postFilter=6.4;
handles.IterNum=2;
handles.SubNum=24;
handles.zFilterListboxVal=3;
handles.nRep=1;


handles.LOAD_ITER='false';
handles.LOAD_REPS='false';
