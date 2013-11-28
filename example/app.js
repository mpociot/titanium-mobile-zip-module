// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var statusLabel = Ti.UI.createLabel({
	layout: 'horizontal',
	text: 'Status'
})
window.add( statusLabel );
window.open();

var zip = require('de.marcelpociot.zip');
Ti.API.info("module is => " + zip);
zip.unzip({
	// TiFile object containing the zip file to open
	file: 		Ti.Filesystem.getFile('documentRoot.zip'),
	// Directory to extract the files to
	target: 	Ti.Filesystem.applicationDataDirectory,
	// OverWrite existing files? default: TRUE
	overwrite:	true,
	// Success callback
	success: function(e){
		// Returns unzipped files:
		statusLabel.text = 'Done';
	},
	// error callback
	error: function(e){
		statusLabel.text = 'Error';
	},
	progress:function(e)
	{
		var progress = Math.round( e.progress * 100 );
		statusLabel.text = progress + '%';
	}
});