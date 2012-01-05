// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
window.add(label);
window.open();

var zip = require('de.marcelpociot.zip');
Ti.API.info("module is => " + zip);

var zipFile = Ti.Filesystem.getFile('light.zip');

zip.unzip({
	filename: zipFile.nativePath, 
	target: Ti.Filesystem.applicationDataDirectory,
	success: function(e){
		alert("Done");
		var unzipped = Ti.Filesystem.getFile(Ti.Filesystem.applicationDataDirectory,'Light.jpg');
		alert(unzipped.exists());
		alert(e);
	},
	error: function(e){
		alert("error");
		alert(e);
	}
});