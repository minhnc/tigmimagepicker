var picker = require('ti.gmimagepicker');
var sv;

(function() {
	var w = Ti.UI.createWindow({ layout: 'vertical' });
	
		var btn = Ti.UI.createButton({ title: 'Pick Photos', backgroundColor: 'blue', tintColor: 'white', width: 120, top: 60 });
			btn.addEventListener('click', showGMImagePicker);
		
		sv = Ti.UI.createScrollableView({ showPagingControl: true, backgroundColor: 'grey' });
		
	w.add(btn);
	w.add(sv);
	w.open();	
})();


function showGMImagePicker() {
	sv.removeAllChildren();
	
	picker.openPhotoGallery({
		maxSelectablePhotos: 10,
		// allowMultiple: false, // default is true
	    success: function (e) {
	        Ti.API.error('success: ' + JSON.stringify(e));
	        renderPhotos(e.media);
	    },
	    cancel: function (e) {
	    	Ti.API.error('cancel: ' + JSON.stringify(e));
	    },
	    error: function (e) {
	        Ti.API.error('error: ' + JSON.stringify(e));
	    }
	});
}

function renderPhotos(media) {
	var views = [];
    
    for (var i=0; i < media.length; i++) {
    	views.push( Ti.UI.createImageView({ image: media[i], width: '100%', height: Ti.UI.SIZE }) );
	};
	
	sv.setViews(views);
}