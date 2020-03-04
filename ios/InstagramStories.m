//
//  InstagramStories.m
//  RNShare
//
//  Created by Nikita Logachev on 13.02.2019.
//  link: https://github.com/loga4
//

// import RCTLog
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import "React/RCTLog.h"   // Required when used as a Pod in a Swift project
#endif

#import "InstagramStories.h"

@implementation InstagramStories
RCT_EXPORT_MODULE();

- (void)backgroundImage:(NSData *)backgroundImage
        attributionURL:(NSString *)attributionURL
        failureCallback:(RCTResponseErrorBlock)failureCallback
        successCallback:(RCTResponseSenderBlock)successCallback {
    // Verify app can open custom URL scheme, open if able

    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {
        // Assign background image asset and attribution link URL to pasteboard
        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage, @"com.instagram.sharedSticker.contentURL" : attributionURL}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
        successCallback(@[]);
    } else { // Handle older app versions or app not installed case
        [self fallbackInstagram:failureCallback];
    }
}

- (void)backgroundVideo:(NSData *)backgroundVideo
         attributionURL:(NSString *)attributionURL
        failureCallback:(RCTResponseErrorBlock)failureCallback
        successCallback:(RCTResponseSenderBlock)successCallback {
    // Verify app can open custom URL scheme, open if able

    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {
        // Assign background image asset and attribution link URL to pasteboard
        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundVideo" : backgroundVideo, @"com.instagram.sharedSticker.contentURL" : attributionURL}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
        successCallback(@[]);
    } else { // Handle older app versions or app not installed case
        [self fallbackInstagram:failureCallback];
    }
}

- (void)stickerImage:(NSData *)stickerImage
  backgroundTopColor:(NSString *)backgroundTopColor
backgroundBottomColor:(NSString *)backgroundBottomColor
      attributionURL:(NSString *)attributionURL
     failureCallback:(RCTResponseErrorBlock)failureCallback
     successCallback:(RCTResponseSenderBlock)successCallback
{
    // Verify app can open custom URL scheme. If able,
    // assign assets to pasteboard, open scheme.

    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {

        // Assign sticker image asset and attribution link URL to pasteboard

        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.stickerImage" : stickerImage, @"com.instagram.sharedSticker.backgroundTopColor" : backgroundTopColor, @"com.instagram.sharedSticker.backgroundBottomColor" : backgroundBottomColor, @"com.instagram.sharedSticker.contentURL" : attributionURL}];

        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};

        // This call is iOS 10+, can use 'setItems' depending on what versions you support

        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
        successCallback(@[]);

    } else { // Handle older app versions or app not installed case
        [self fallbackInstagram:failureCallback];
    }
}

- (void)backgroundImage:(NSData *)backgroundImage
           stickerImage:(NSData *)stickerImage
         attributionURL:(NSString *)attributionURL
        failureCallback:(RCTResponseErrorBlock)failureCallback
        successCallback:(RCTResponseSenderBlock)successCallback {
    // Verify app can open custom URL scheme. If able,
    // assign assets to pasteboard, open scheme.
    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {
        // Assign background and sticker image assets and
        // attribution link URL to pasteboard
        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage, @"com.instagram.sharedSticker.stickerImage" : stickerImage, @"com.instagram.sharedSticker.contentURL" : attributionURL}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
        successCallback(@[]);

    } else { // Handle older app versions or app not installed case
        [self fallbackInstagram:failureCallback];
    }
}


- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {

    NSString *attrURL = [RCTConvert NSString:options[@"attributionURL"]];
    if (attrURL == nil) {
        attrURL = @"";
    }

    NSString *method = [RCTConvert NSString:options[@"method"]];
    if (method) {
        if([method isEqualToString:@"shareBackgroundImage"]) {

            NSURL *URL = [RCTConvert NSURL:options[@"backgroundImage"]];
            if (URL == nil) {
                RCTLogError(@"key 'backgroundImage' missing in options");
            } else {
                UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:URL]];

                [self backgroundImage:UIImagePNGRepresentation(image)
                    attributionURL:attrURL
                    failureCallback:failureCallback
                    successCallback:successCallback];
            }
        } else if([method isEqualToString:@"shareStickerImage"]) {
            RCTLog(@"method shareStickerImage");

            NSString *backgroundTopColor = [RCTConvert NSString:options[@"backgroundTopColor"]];
            if (backgroundTopColor == nil) {
                backgroundTopColor = @"#906df4";
            }
            NSString *backgroundBottomColor = [RCTConvert NSString:options[@"backgroundBottomColor"]];
            if (backgroundBottomColor == nil) {
                backgroundBottomColor = @"#837DF4";
            }

            NSURL *URL = [RCTConvert NSURL:options[@"stickerImage"]];
            if (URL == nil) {
                RCTLogError(@"key 'stickerImage' missing in options");
            } else {
                UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:URL]];

                [self stickerImage:UIImagePNGRepresentation(image)
                    backgroundTopColor:backgroundTopColor
                    backgroundBottomColor:backgroundBottomColor
                    attributionURL:attrURL
                    failureCallback:failureCallback
                    successCallback:successCallback];
            }
        } else if([method isEqualToString:@"shareBackgroundAndStickerImage"]) {
            RCTLog(@"method shareBackgroundAndStickerImage");

            NSURL *backgroundURL = [RCTConvert NSURL:options[@"backgroundImage"]];
            NSURL *sticketURL = [RCTConvert NSURL:options[@"stickerImage"]];

            if (backgroundURL == nil || sticketURL == nil) {
                RCTLogError(@"key 'backgroundImage' or 'stickerImage' missing in options");
            } else {
                UIImage *backgroundImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:backgroundURL]];
                UIImage *stickerImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:sticketURL]];

                [self backgroundImage:UIImagePNGRepresentation(backgroundImage)
                    stickerImage:UIImagePNGRepresentation(stickerImage)
                    attributionURL:attrURL
                    failureCallback:failureCallback
                    successCallback:successCallback];
            }
        } else if([method isEqualToString:@"shareBackgroundVideo"]) {
            NSString *URL = [RCTConvert NSString:options[@"backgroundVideo"]];
            if (URL == nil) {
                RCTLogError(@"key 'backgroundVideo' missing in options");
            } else {
                NSData *video = [NSData dataWithContentsOfURL:URL];
                [self backgroundVideo:video
                    attributionURL:attrURL
                    failureCallback:failureCallback
                    successCallback:successCallback];
            }
        }
    } else {
        RCTLogError(@"key 'method' missing in options");
    }
}

- (void)fallbackInstagram {
    // Cannot open instagram
    NSString *stringURL = @"http://itunes.apple.com/app/instagram/id389801252";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];

    NSString *errorMessage = @"Not installed";
    NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)};
    NSError *error = [NSError errorWithDomain:@"com.rnshare" code:1 userInfo:userInfo];

    NSLog(errorMessage);
}
@end

