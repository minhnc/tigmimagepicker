/**
 * TiGMImagePicker
 *
 * Created by Minh Nguyen
 * Copyright (c) 2016 Your Company. All rights reserved.
 */

#import "TiGmimagepickerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

enum
{
    MediaModuleErrorUnknown,
    MediaModuleErrorBusy,
    MediaModuleErrorNoCamera,
    MediaModuleErrorNoVideo,
    MediaModuleErrorNoMusicPlayer
};


@interface TiGmimagepickerModule () <GMImagePickerControllerDelegate>
@end

@implementation TiGmimagepickerModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"db2c80c4-3948-4006-b3f7-b3c46dcde744";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.gmimagepicker";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
    [self destroyPicker];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

/// From Titanium.Media
-(void)openPhotoGallery:(id)args
{
    ENSURE_SINGLE_ARG_OR_NIL(args,NSDictionary);
    ENSURE_UI_THREAD(openPhotoGallery,args);

    [self showPicker:args isCamera:NO];
}


-(void)showPicker:(NSDictionary*)args isCamera:(BOOL)isCamera
{
    if (picker!=nil)
    {
        [self sendPickerError:MediaModuleErrorBusy];
        return;
    }
    
    picker = [[GMImagePickerController alloc] init];
    picker.delegate = self;
    
    if (args!=nil)
    {
        [self commonPickerSetup:args];
        
        picker.title = @"Photos";
        
//        picker.customDoneButtonTitle = @"Finished";
//        picker.customCancelButtonTitle = @"Nope";
//        picker.customNavigationBarPrompt = @"Take a new photo or select an existing one!";
        
        picker.colsInPortrait = 3;
        picker.colsInLandscape = 5;
        picker.minimumInteritemSpacing = 2.0;
        
        picker.allowsMultipleSelection = [TiUtils boolValue:@"allowMultiple" properties:args def:true];
        //    picker.confirmSingleSelection = YES;
        //    picker.confirmSingleSelectionPrompt = @"Do you want to select the image you have chosen?";
        
        //    picker.showCameraButton = YES;
        //    picker.autoSelectCameraImages = YES;
        
        picker.modalPresentationStyle = UIModalPresentationPopover;
        
        picker.mediaTypes = @[@(PHAssetMediaTypeImage)];
        
        //    picker.pickerBackgroundColor = [UIColor blackColor];
        //    picker.pickerTextColor = [UIColor whiteColor];
        //    picker.toolbarBackgroundColor = [UIColor darkGrayColor];
        //    picker.toolbarBarTintColor = [UIColor blackColor];
        //    picker.toolbarTextColor = [UIColor whiteColor];
        //    picker.toolbarTintColor = [UIColor redColor];
        //    picker.navigationBarBackgroundColor = [UIColor darkGrayColor];
        //    picker.navigationBarBarTintColor = [UIColor blackColor];
        //    picker.navigationBarTextColor = [UIColor whiteColor];
        //    picker.navigationBarTintColor = [UIColor redColor];
        //    picker.pickerFontName = @"Verdana";
        //    picker.pickerBoldFontName = @"Verdana-Bold";
        //    picker.pickerFontNormalSize = 14.f;
        //    picker.pickerFontHeaderSize = 17.0f;
        //    picker.pickerStatusBarStyle = UIStatusBarStyleLightContent;
        //    picker.useCustomFontForNavigationBar = YES;
        
        //    picker.arrangeSmartCollectionsFirst = YES;
        
        //    UIPopoverPresentationController *popPC = picker.popoverPresentationController;
        //    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //    popPC.sourceView = _gmImagePickerButton;
        //    popPC.sourceRect = _gmImagePickerButton.bounds;
        //    popPC.backgroundColor = [UIColor blackColor];
    }
    
    // [self showViewController:picker sender:nil];
    [[TiApp app] showModalController:picker animated:YES];
    
}

#pragma mark - From Titanium.Media

-(void)commonPickerSetup:(NSDictionary*)args
{
    if (args!=nil) {
        pickerSuccessCallback = [args objectForKey:@"success"];
        ENSURE_TYPE_OR_NIL(pickerSuccessCallback,KrollCallback);
        [pickerSuccessCallback retain];
        
        pickerErrorCallback = [args objectForKey:@"error"];
        ENSURE_TYPE_OR_NIL(pickerErrorCallback,KrollCallback);
        [pickerErrorCallback retain];
        
        pickerCancelCallback = [args objectForKey:@"cancel"];
        ENSURE_TYPE_OR_NIL(pickerCancelCallback,KrollCallback);
        [pickerCancelCallback retain];
    }
    
    maxSelectablePhotos = [TiUtils intValue:@"maxSelectablePhotos" properties:args def:-1];
}

-(void)destroyPicker
{
    RELEASE_TO_NIL(picker);
    RELEASE_TO_NIL(pickerSuccessCallback);
    RELEASE_TO_NIL(pickerErrorCallback);
    RELEASE_TO_NIL(pickerCancelCallback);
}

-(void)dispatchCallback:(NSArray*)args
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *type = [args objectAtIndex:0];
    id object = [args objectAtIndex:1];
    id listener = [args objectAtIndex:2];
    // we have to give our modal picker view time to
    // dismiss with animation or if you do anything in a callback that
    // attempt to also touch a modal controller, you'll get into deep doodoo
    // wait for the picker to dismiss with animation
    [NSThread sleepForTimeInterval:0.5];
    [self _fireEventToListener:type withObject:object listener:listener thisObject:nil];
    [pool release];
}

-(void)sendPickerError:(int)code
{
    id listener = [[pickerErrorCallback retain] autorelease];
    [self destroyPicker];
    if (listener!=nil)
    {
        NSDictionary *event = [TiUtils dictionaryWithCode:code message:nil];
        
#ifdef TI_USE_KROLL_THREAD
        [NSThread detachNewThreadSelector:@selector(dispatchCallback:) toTarget:self withObject:[NSArray arrayWithObjects:@"error",event,listener,nil]];
#else
        [self dispatchCallback:@[@"error",event,listener]];
#endif
    }
}

-(void)sendPickerCancel
{
    id listener = [[pickerCancelCallback retain] autorelease];
    [self destroyPicker];
    if (listener!=nil)
    {
        NSMutableDictionary * event = [TiUtils dictionaryWithCode:-1 message:@"The user cancelled the picker"];
        
#ifdef TI_USE_KROLL_THREAD
        [NSThread detachNewThreadSelector:@selector(dispatchCallback:) toTarget:self withObject:[NSArray arrayWithObjects:@"cancel",event,listener,nil]];
#else
        [self dispatchCallback:@[@"cancel",event,listener]];
#endif
    }
}

-(void)sendPickerSuccess:(id)event
{
    id listener = [[pickerSuccessCallback retain] autorelease];
    [self destroyPicker];

    if (listener!=nil)
    {
#ifdef TI_USE_KROLL_THREAD
        [NSThread detachNewThreadSelector:@selector(dispatchCallback:) toTarget:self withObject:[NSArray arrayWithObjects:@"success",event,listener,nil]];
#else
        [self dispatchCallback:@[@"success",event,listener]];
#endif
    }
}


#pragma mark - GMImagePickerControllerDelegate

- (BOOL)assetsPickerController:(GMImagePickerController *)_picker shouldSelectAsset:(PHAsset *)asset
{    
    if (maxSelectablePhotos == -1) return true;
    
    // show alert gracefully
    if (_picker.selectedAssets.count >= maxSelectablePhotos)
    {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Sorry"
                                    message:[NSString stringWithFormat:@"You can select maximum %ld photos.", (long)maxSelectablePhotos]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alert addAction:action];
        
        [_picker presentViewController:alert animated:NO completion:nil];
    }
    
    // limit selection to max
    return (_picker.selectedAssets.count < maxSelectablePhotos);
}

- (void)assetsPickerController:(GMImagePickerController *)_picker didFinishPickingAssets:(NSArray *)assetArray
{
    // [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [[TiApp app] hideModalController:_picker animated:YES];
    [[TiApp controller] repositionSubviews];
    
    NSLog(@"GMImagePicker: User ended picking assets. Number of selected items is: %lu", (unsigned long)assetArray.count);
    
    ///
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeNone;
    requestOptions.networkAccessAllowed = YES; // Will download the image from iCloud, if necessary
    requestOptions.synchronous = NO;
    
    __block NSUInteger imagesCount = 0;
    NSUInteger assetsCount = assetArray.count;
    NSString *tmpDir = NSTemporaryDirectory();
    NSMutableArray *media = [NSMutableArray arrayWithCapacity:assetsCount];
    NSMutableDictionary *dictionary = [TiUtils dictionaryWithCode:0 message:nil];
    
    for (PHAsset *asset in assetArray) {
        
        // NSLog(@"%@", [asset valueForKey:@"filename"]);
        
        [manager requestImageForAsset:asset
                    targetSize:PHImageManagerMaximumSize
                    contentMode:PHImageContentModeDefault
                    options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                            
                        imagesCount++;
                        
                        if (assetsCount > 6) { // TODO: Make this configurable
                            
                            NSURL *url = [info objectForKey:@"PHImageFileURLKey"];
                            NSString *ext = [url pathExtension];
                            NSString *tmpFile = [tmpDir stringByAppendingPathComponent: [url lastPathComponent]];
                            
                            [media addObject:tmpFile];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                if ([ext isEqualToString:@"JPG"]) {
                                    [UIImageJPEGRepresentation(image, 1) writeToFile:tmpFile atomically:YES];
                                } else {
                                    [UIImagePNGRepresentation(image) writeToFile:tmpFile atomically:YES];
                                }
                            });
                            
                        } else {
                            [media addObject:[[TiBlob alloc] initWithImage:image]];
                        }
                            
                        if (imagesCount == assetsCount) {
                            [dictionary setObject:media forKey:@"media"];
                                
                            NSLog(@"GMImagePicker: User ended picking assets: %@", dictionary);
                            [self sendPickerSuccess:dictionary];
                        }
                    }];
    }
}

// Optional implementation:
-(void)assetsPickerControllerDidCancel:(GMImagePickerController *)picker
{
    NSLog(@"GMImagePicker: User pressed cancel button");
    [self sendPickerCancel];
}

@end
