function [dp_val,cc,rowind,blocklimits] = ComputeComponents(faces,data,filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isdeployed
    addpath(genpath('/mnt/max/shared/code/external/utilities/Matlab_CIFTI'))
    addpath(genpath('/mnt/max/shared/code/internal/utilities/CIFTI/'))
    addpath(genpath('/mnt/max/shared/code/external/utilities/gifti-1.6'))
end
if ischar(faces)
    if faces(1) ~= '['
        struct_file = gifti(faces);
        faces = struct_file.faces;
        faces = double(faces);
    else
        faces = str2num(faces);
    end
end
if min(size(faces)) == 1
    fac = zeros(length(faces)/3,3);
    fac(:,1) = faces(1:length(faces)/3);
    fac(:,2) = faces((length(faces)/3)+1:(2*length(faces)/3));
    fac(:,3) = faces((2*length(faces)/3)+1:length(faces));
else
    fac = faces;
end
if ischar(data)
    if data(1) ~= '['
        dpx_file = gifti(data);
        dpx = dpx_file.cdata;
    else
        dpx = str2num(data);
    end
else
    dpx = data;
end
if isnumeric(dpx)
    if length(unique(dpx)) > 2
        dpx = dpx ~= 0;
    elseif length(unique(dpx)) == 2
        dpx = logical(dpx);
    elseif unique(dpx) == 0
    else
        error(strcat('Gifti data input error: data are numeric but do not contain 2 or more unique values or entirely zeros','| unique_values = ',num2str(unique(dpx)),'| length = ',num2str(length(unique(dpx)))));
    end
elseif islogical(dpx)
else
    error('Gifti data input error: data are not in a logical nor numeric format...aborting');
end
adj = sparse([fac(:,1);fac(:,1);fac(:,2);fac(:,2);fac(:,3);fac(:,3)],[fac(:,2);fac(:,3);fac(:,1);fac(:,3);fac(:,1);fac(:,2)],1,max(max(fac)),max(max(fac)));
adj(~ dpx,:) = [];
adj(:,~ dpx) = [];
[rowind,~,blocklimits] = dmperm(adj);
cc = zeros(size(adj,1),1);
for curr_comp = 1:numel(blocklimits)-1
    cc(rowind(blocklimits(curr_comp):blocklimits(curr_comp+1)-1)) = curr_comp;
end
dp_val = zeros(size(dpx));
if unique(dpx) == 0
display('no clusters detected')
else
    dp_val(dpx) = cc;
end
if isdeployed
    if(size(dp_val,2) > 1)
        dp_val = transpose(dp_val);
        display(dp_val)
    else
        display(dp_val)
    end
end
if exist('filename','var')
    save(filename,'dp_val','-v7.3');
end
end

