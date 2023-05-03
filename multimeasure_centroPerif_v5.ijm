// Central vs peripheral accumulation cuantification macros by Yuseff Lab
// Coded by Martina Alamo, Felipe Del Valle, Isidora Riobó 
run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction display redirect=None decimal=3");
close("*");
setOption("JFileChooser", true);
dir= getDirectory("Select the folder of your images");
setOption("JFileChooser", false);

setOption("JFileChooser", true);
dir_results= getDirectory("The folder of the results");
setOption("JFileChooser", false);

//loop setup
imagenames=getFileList(dir); /// directory of cells
nbimages=lengthOf(imagenames); 
image_save=getFileList(dir);

for(image=0; image<nbimages; image++) { 
	name=imagenames[image];
	totnamelength=lengthOf(name); 
	namelength=totnamelength-4;
	name1=substring(name, 0, namelength);
	extension=substring(name, namelength, totnamelength);

		
		if(extension==".tif" || extension==".nd2" || extension==".czi" ) { 
		
					close("*");
				
					roiManager("reset");
					open(dir+File.separator+name);
					Stack.setDisplayMode("composite");
					run("Brightness/Contrast...");
					run("Enhance Contrast", "saturated=0.35");
					lista = getList("image.titles");
					Array.print(lista);					
					getPixelSize (unit,pw,ph);
					slice_sinapsis = ""; 
					waitForUser("Look for the Z slice of interest");
					Dialog.create("Z slice");
					Dialog.addNumber("Z slice of interest", slice_sinapsis); //acá se almacena el Z 
					Dialog.show();
					slice_sinapsis = Dialog.getNumber();
					run("Duplicate...", "duplicate channels=1-5 slices=slice_sinapsis");
					waitForUser("Draw the cell outline and add to roi manager with CTL+T");
					roiManager("Add");
					roiManager("Select", 0);
					roiManager("Update");
					roiManager("Add");
					roiManager("Select", 1);
					RoiManager.scale(0.4, 0.4, true);
					roiManager("Select", 0);
					roiManager("Select", newArray(0,1));
					roiManager("XOR");
					roiManager("Add");
					roiManager("Select", 2);
					roiManager("Delete");
					roiManager("Select", newArray(0,1,2));
					roiManager("multi measure");

					saveAs("Results", dir_results+"results_"+name+".csv"); //
					roiManager("Save", dir_results+"roi_manager_"+name+".zip");
					roiManager("reset");
					
	}
}
