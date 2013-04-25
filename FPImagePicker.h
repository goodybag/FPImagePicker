//  FPImagePicker.h
//
//  Created by Geoffrey Parker on 3/13/13.
//  Copyright (c) 2013 Goodybag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol FPImagePickerDelegate <NSObject>

@optional
- (void)FPImagePickerDidGetImage:(UIImage*)image;
- (void)FPImagePickerDidUploadImageWithUrl:(NSString *)url;
- (void)FPImagePickerDidCancel;
- (void)FPImagePickerUploadDidFailWithError:(NSError*) error;

@end

@interface FPImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImagePickerController* imagePicker;
}

@property (nonatomic, assign) UIViewController<FPImagePickerDelegate>* delegate;

- initWithDelegate:(UIViewController<FPImagePickerDelegate>*)delegate;

- (void)getImageFromSource:(UIImagePickerControllerSourceType)source;

@end
