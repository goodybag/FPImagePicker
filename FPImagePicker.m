//  FPImagePicker.m
//
//  Created by Geoff Parker on 3/13/13.
//  Copyright (c) 2013 Goodybag. All rights reserved.
//

#import "FPImagePicker.h"

@implementation FPImagePicker

- (id)init {
  self = [super init];
  if (self) {
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
  }
  return self;
}

- (id)initWithDelegate:(UIViewController<FPImagePickerDelegate> *)delegate {
  self = [self init];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

- (void)getImageFromSource:(UIImagePickerControllerSourceType)source {
  if (![UIImagePickerController isSourceTypeAvailable:source])
    return;
  [imagePicker setSourceType:source];
  [[self delegate] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSLog(@"didFinishPickingMediaWithInfo: %@", info);
  UIImage* thumbnail = [info valueForKey:UIImagePickerControllerEditedImage];

  NSString* filepickerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Filepicker API Key"];
  NSString* fn = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
  NSString* path = [NSString stringWithFormat:@"/api/store/S3?key=%@&filename=%@", filepickerKey, fn];

  AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.filepicker.io"]];

  [client setDefaultHeader:@"Accept" value:@"application/json"];
  [client registerHTTPOperationClass:[AFJSONRequestOperation class]];

  NSMutableURLRequest* request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:UIImageJPEGRepresentation(thumbnail, 1.0) name:@"fileUpload" fileName:fn mimeType:@"image/jpeg"];
  }];

  AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

  id<FPImagePickerDelegate> delegate = [self delegate]; // local vars work with blocks better than methods.
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (delegate != nil && [delegate respondsToSelector:@selector(FPImagePickerDidUploadImageWithUrl:)])
      [delegate FPImagePickerDidUploadImageWithUrl:[responseObject valueForKey:@"url"]];
  } failure:^(AFHTTPRequestOperation *operation, NSError *err) {
    NSLog(@"Image upload failed with error: %@", err);
    if (delegate != nil && [delegate respondsToSelector:@selector(FPImagePickerUploadDidFailWithError:)])
      [delegate FPImagePickerUploadDidFailWithError:err];
  }];

  [client enqueueHTTPRequestOperation:operation];


  [[self delegate] dismissViewControllerAnimated:YES completion:^{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(FPImagePickerDidGetImage:)])
      [[self delegate] FPImagePickerDidGetImage:thumbnail];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [[self delegate] dismissViewControllerAnimated:YES completion:^{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(FPImagePickerDidCancel)])
      [[self delegate] FPImagePickerDidCancel];
  }];
}

@end
