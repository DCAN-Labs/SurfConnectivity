function MakeCiftiFromText(sample_cifti,text_file,output_file,wb_command_file)
%MakeCiftiFromText is a simple hardcoded function to write CIFTI files
%using an input template cifti and a tab-delimited numerical text file.
if ~isdeployed
    addpath(genpath('/mnt/max/shared/code/external/utilities/gifti-1.6'));
    addpath(genpath('/mnt/max/shared/code/external/utilities/Matlab_CIFTI'));
end
cifti_object = ciftiopen(sample_cifti,wb_command_file);
file_ending = sample_cifti(strfind(sample_cifti,'.pconn.nii'):end);
if isempty(file_ending)
    file_ending = sample_cifti(strfind(sample_cifti,'.dscalar.nii'):end);
end
if isempty(file_ending)
    file_ending = sample_cifti(strfind(sample_cifti,'.pscalar.nii'):end);
end
output_file = strcat(output_file,file_ending);
cifti_data = dlmread(text_file);
cifti_data = single(cifti_data);
cifti_object.cdata = cifti_data;
ciftisave(cifti_object,output_file,wb_command_file);
end

