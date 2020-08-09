function [varargout]= vdynblksmdlWSconfig(varargin)
%   Copyright 2018 The MathWorks, Inc.
block = varargin{1};
if nargin >1
    userDef = varargin{2};
else
    userDef = true;
end
varargout{1} = {};
simStopped = autoblkschecksimstopped(block,true);
if simStopped
%     rootModel = bdroot(block);
%     ws = get_param(rootModel, 'modelworkspace');
%     VEH = getVariable(ws,'VEH');
    myDictionaryObj = Simulink.data.dictionary.open('SystemDD.sldd');
    dDataSectObj = getSection(myDictionaryObj,'Design Data');
    vehObj = getEntry(dDataSectObj,'VEH');
    tempveh = getValue(vehObj);
    if userDef
        ParamList={'X_o',[1,1],{};'Y_o',[1,1],{};'Z_o',[1,1],{};'phi_o',[1,1],{'gte',-pi/2;'lte',pi/2};'theta_o',[1,1],{'gte',-pi/2;'lte',pi/2};'psi_o',[1,1],{'gte',-2*pi;'lte',2*pi}};
        paramStruct = autoblkscheckparams(block, '3D Engine',ParamList);
    else
        paramStruct = vdynblks3Dsceneconfig(block);
    end
    tempveh.InitialLongPosition = paramStruct.X_o;
    tempveh.InitialLatPosition = paramStruct.Y_o;
    tempveh.InitialVertPosition = paramStruct.Z_o;
    tempveh.InitialRollAngle = paramStruct.phi_o;
    tempveh.InitialPitchAngle = paramStruct.theta_o;
    tempveh.InitialYawAngle = paramStruct.psi_o;    
    setValue(vehObj,tempveh);
    saveChanges(myDictionaryObj);
%     assignin(ws,'VEH',VEH);
%     modelList = {'PassVeh14DOF','PassVeh7DOF'};
%     for idx =1:length(modelList)
%         load_system(modelList{idx});
%         ws = get_param(modelList{idx}, 'modelworkspace');
%         assignin(ws,'VEH',VEH);
%         save_system(modelList{idx});
%         close_system(modelList{idx});
%     end
%     disp('Model workspaces updated.')
end



