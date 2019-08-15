function MakeGiftiFromText(sample_gifti,text_file,output_file)
%MakeGiftiFromText is a simple hardcoded function to write GIFTI files
%using an input template gifti and a tab-delimited numerical text file.
if ~isdeployed
    addpath(genpath('/mnt/max/shared/code/external/utilities/gifti-1.6'));
end
gifti_object = gifti(sample_gifti);
gifti_data = dlmread(text_file);
gifti_data = single(gifti_data);
gifti_object.cdata = gifti_data;
save(gifti_object,output_file);
end

