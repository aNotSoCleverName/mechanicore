extends Node

### This function adds the contents of inDir to inArr
### If the array is already initiated (size > 0), immediately stop the function
### inExtension determines what file type to look for
### inIsLoad determines if the file should be loaded (false if we only want the file paths in the array)
### inIsInstantiate determines if the resource should be instantiated.
func InitArrayFromFiles(inArr: Array, inDir: String, inExtension: String, inIsLoad: bool, inIsInstantiate: bool):
	if (inArr.size() > 0):
		return;
	
	for fileName: String in DirAccess.open(inDir).get_files():
		fileName = fileName.split(".remap")[0];
		print(inDir + fileName);
		if (!fileName.ends_with(inExtension)):
			continue;
		
		var fullPath: String = inDir + fileName;
		
		if (!inIsLoad):
			inArr.append(fullPath);
			continue;
		
		var resource: Resource = load(fullPath);
		if (!inIsInstantiate):
			inArr.append(resource);
			continue;
		
		inArr.append(resource.instantiate());
