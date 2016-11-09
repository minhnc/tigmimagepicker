/**
 * TiGMImagePicker
 *
 * Created by Minh Nguyen
 * Copyright (c) 2016 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import "GMImagePickerController.h"


@interface TiGmimagepickerModule : TiModule
{
    @private
        NSUInteger maxSelectablePhotos;
        GMImagePickerController *picker;
        KrollCallback *pickerSuccessCallback;
        KrollCallback *pickerErrorCallback;
        KrollCallback *pickerCancelCallback;
//        KrollCallback *pickerReachMaxCallback;
}

@end
