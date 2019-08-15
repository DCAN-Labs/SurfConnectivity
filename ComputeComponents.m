function [dp_val,cc,rowind,blocklimits,dp_num] = ComputeComponents(faces,data,filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isdeployed
    addpath(genpath('/mnt/max/shared/code/external/utilities/Matlab_CIFTI'))
    addpath(genpath('/mnt/max/shared/code/internal/utilities/CIFTI/'))
    addpath(genpath('/mnt/max/shared/code/external/utilities/gifti-1.6'))
end
if ischar(faces)
        struct_file = gifti(faces);
        faces = struct_file.faces;
        vertices = struct_file.vertices;
        vertices = double(vertices);
        faces = double(faces);
else
    error('no structural file was specified to extract face and vertex information...aborting');
end
if min(size(faces)) == 1
    fac = zeros(length(faces)/3,3);
    fac(:,1) = faces(1:length(faces)/3);
    fac(:,2) = faces((length(faces)/3)+1:(2*length(faces)/3));
    fac(:,3) = faces((2*length(faces)/3)+1:length(faces));
else
    fac = faces;
end
if min(size(vertices)) == 1
    vtx = zeros(length(vertices)/3,3);
    vtx(:,1) = vertices(1:length(vertices)/3);
    vtx(:,2) = vertices((length(vertices)/3)+1:(2*length(vertices)/3));
    vtx(:,3) = vertices((2*length(vertices)/3)+1:length(vertices));
else
    vtx = vertices;
end
facvtx = [vtx(fac(:,1),:) vtx(fac(:,2),:), vtx(fac(:,3),:) ];
facvtx0(:,1:6) = facvtx(:,1:6) - [facvtx(:,7:9) facvtx(:,7:9)];
cp = cross(facvtx0(:,1:3),facvtx0(:,4:6),2);
A = sqrt(sum(cp.^2,2))./2;
apv = zeros(size(vtx,1),1);
A = A/3;
for curr_face = 1:size(fac,1)
    apv(fac(curr_face,:)) = apv(fac(curr_face,:)) + A(curr_face);
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
adj = (adj > 0) + speye(size(adj));
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
clusters = unique(dp_val);
clusters = clusters(2:end);
cluster_size = zeros(size(dp_val));
for curr_cluster = 1:length(clusters)
    cluster_size(dp_val==clusters(curr_cluster)) = sum(apv(dp_val==clusters(curr_cluster)));
end
dp_num = dp_val;
dp_val = cluster_size;
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

