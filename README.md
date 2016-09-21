GMImagePicker module for Appcelerator Titanium
==============================================

Photo Picker supporting multiple selections and UI customizations. Designed for iOS 8 with Photo framework ( PhotoKit )

https://github.com/guillermomuntaner/GMImagePicker
 
### Screenshots

![Screenshot](GMImagePickerDemo.gif "Screenshot")  

### Features
1. Allows selection of multiple photos and videos, even from different albums.
2. Optional single selection mode.
3. Optional camera access.
4. Optional bottom toolbar with information about users selection.
5. Full and customizable acces to smart collections(**Favorites**, **Slo-mo** or **Recently deleted**). 
6. Filter by collections & albums.
7. Filter by media type.
8. Customizable colors, fonts and labels to ease branding of the App.
9. By default mimics UIImagePickerController in terms of features, appearance and behaviour.
10. Dynamically sized grid view, easy to customize and fully compatible with iPhone 6/6+ and iPad.
11. Works in landscape orientation and allow screen rotation!
12. It can be used as Popover on iPad, with customizable size.
13. Fast & small memory footprint powered by PHCachingImageManager.
14. Full adoption of new iOS8 **PhotoKit**. Returns and array of PHAssets.


## Usage

```xml
<ios>
    <plist>
        <dict>
            <key>NSPhotoLibraryUsageDescription</key>
            <string>Access media in Photos</string>
        </dict>
    </plist>
</ios>
```

```javascript

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

```

#### Minimum Requirement
Xcode 6 and iOS 8.


### License

Copyright (c) 2016 Minh Nguyen
