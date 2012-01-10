// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
window.open();

var zip = require('de.marcelpociot.zip');
Ti.API.info("module is => " + zip);

zip.unzip({
	// TiFile object containing the zip file to open
	file: 		Ti.Filesystem.getFile('light.zip'),
	// Directory to extract the files to
	target: 	Ti.Filesystem.applicationDataDirectory,
	// OverWrite existing files? default: TRUE
	overwrite:	true,
	// Success callback
	success: function(e){
		// Returns unzipped files:
		alert(e.files);
	},
	// error callback
	error: function(e){}
});

// Zip files
var zipFiles = [];
// Just create random files to add
for( var i=0;i<10;i++ ){
	var f = Ti.Filesystem.getFile('file_'+i+'.txt');
	f.write('File '+i);
	var zipFile = {
		name: 'filename_'+i+'.txt',	// Filename inside the zip file
		file: f 					// File content
	};
	zipFiles.push(zipFile);
}

var newZip = Ti.Filesystem.getFile('created.zip');
zip.zip({
	// TiFile object containing the zip file to create
	file:		newZip,
	// Array with objects (name/file) for the files to add
	files:		zipFiles,
    // success callback function
	success:	function(e){
		// unzip just to check
		zip.unzip({
			file: 	newZip,
			target:	Ti.Filesystem.applicationDataDirectory,
			success: function(e){
				alert("unzip successful");
			}
		});
	}
});