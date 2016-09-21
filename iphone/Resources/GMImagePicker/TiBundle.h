//
//  TiUtils.h
//  TiGMImagePicker
//
//  Created by Minh Nguyen on 9/20/16.
//
//

#ifndef TiBundle_h
#define TiBundle_h


#endif /* TiBundle_h */

#define TIBundle [[NSBundle alloc] initWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/modules/ti.gmimagepicker/"]]
#define TINSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) NSLocalizedStringFromTableInBundle(key, tbl, TIBundle, comment)
