#FPImagePicker
Upload images from the iPhone camera or photo library to filepicker.io.  That's it.

## Installation

Drop the two files in your project.  Set the `Filepicker API Key` in your plist file, exactly the same as the [official Filepicker sdk](https://developers.filepicker.io/docs/ios/).

## Use

1. Make your view controller conform to the `FPImagePickerDelegate` protocol.  All methods are optional.

2. Create an FPImagePicker instance:
   ```Objective-C
   imgGetter = [[FPImagePicker alloc] initWithDelegate:self];
   ```
   Make sure you store it somewhere it won't be deallocated until you're done with it (e.g. instance variable, not local).

3. Pick an image.
   ```Objective-C
   [imgGetter getImageFromSource:UIImagePickerControllerSourceTypeCamera];
   ```
   Use the standard `UIImagePickerController` source types.
   At this point, the image is uploaded to Filepicker as an uncompressed jpg.

4. Get the image back.  If your delegate has implemented the `FPImagePickerDidGetImage:` method, it will be called with the image taken as soon as the upload starts.

5. Get the Filepicker url.  As soon as the upload completes, the delegate method `FPImagePickerDidUploadImageWithUrl:` will be called with the Filepicker url.

## Dependencies

[AFNetworking](https://github.com/AFNetworking/AFNetworking)