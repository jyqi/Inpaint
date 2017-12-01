function [inpaintingImages] = getInpaintingImages( rootPath)

inpaintingImages = {};
userDirectoryContents = list_image_files(fullfile(rootPath));
imageIndex = 0;
if isempty(userDirectoryContents)
    error(['No image files were found! Check your paths; there should be images in ' fullfile(rootPath)]);
end
for fileIndex = 1:length(userDirectoryContents),
        imageName = userDirectoryContents{fileIndex};
        disp(['Using image file ' imageName '...']);

        imageIndex = imageIndex+1;

        imageFileName = fullfile(rootPath, imageName);
        inpaintingImages{imageIndex} = imageFileName;
end
return;