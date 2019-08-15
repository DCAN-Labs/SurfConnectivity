%compiling MakeCiftiFromText code
addpath(genpath('/mnt/max/shared/code/external/utilities/Matlab_CIFTI'))
addpath(genpath('/mnt/max/shared/code/internal/utilities/CIFTI/'))
addpath(genpath('/mnt/max/shared/code/external/utilities/gifti-1.6'))
mcc -v -m -d /mnt/max/shared/projects/FAIR_users/Feczko/code_in_dev/SurfConnectivity -o MakeCiftiFromText /mnt/max/shared/projects/FAIR_users/Feczko/code_in_dev/SurfConnectivity/MakeCiftiFromText.m
