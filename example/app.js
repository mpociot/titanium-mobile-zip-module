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
		alert("done");
	},
	// error callback
	error: function(e){
		alert("error");
	}
});