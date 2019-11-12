
#import "RNGrowingTouch.h"
#import <GrowingTouchKit/GrowingTouch.h>
#import <GrowingTouchKit/GrowingTouchEventPopupDelegate.h>

@interface RNGrowingTouch () <GrowingTouchEventPopupDelegate>
@property(nonatomic, assign) bool hasListeners;
@end

@implementation RNGrowingTouch
static NSString *const GTouchEventReminder = @"GTouchEventReminder";

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(setEventPopupEnable:(BOOL) enable) {
    NSLog(@"RNGrowingTouch setEventPopupEnable: enable = %d", enable);
    [GrowingTouch setEventPopupEnable:enable];
}

RCT_REMAP_METHOD(isEventPopupEnabled,
                 isEventPopupEnabledWithResolver:(RCTPromiseResolveBlock) resolve
                 rejecter:(RCTPromiseRejectBlock) reject) {
    bool enable = [GrowingTouch isEventPopupEnabled];
    NSLog(@"RNGrowingTouch isEventPopupEnabled: enable = %d", enable);
    NSDictionary *data = @{@"popupEnabled": @(enable)};
    resolve(data);
}

RCT_EXPORT_METHOD(enableEventPopupAndGenerateAppOpenEvent) {
    NSLog(@"RNGrowingTouch enableEventPopupAndGenerateAppOpenEvent");
    [GrowingTouch enableEventPopupAndGenerateAppOpenEvent];
}

RCT_REMAP_METHOD(isEventPopupShowing,
                 isEventPopupShowingWithResolver:(RCTPromiseResolveBlock) resolve
                 rejecter:(RCTPromiseRejectBlock) reject) {
    bool isShowing = [GrowingTouch isEventPopupShowing];
    NSLog(@"RNGrowingTouch isEventPopupShowing: enable = %d", isShowing);
    NSDictionary *data = @{@"popupShowing": @(isShowing)};
    resolve(data);
}

RCT_EXPORT_METHOD(setEventPopupListener) {
    NSLog(@"RNGrowingTouch setEventPopupListener");
    [GrowingTouch setEventPopupDelegate:self];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[GTouchEventReminder];
}

// 在添加第一个监听函数时触发
- (void)startObserving {
    self.hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
- (void)stopObserving {
    self.hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (void)onEventPopupLoadSuccess:(NSString *)trackEventId eventType:(NSString *)eventType {
    NSLog(@"RNGrowingTouch %s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
    if (self.hasListeners) {
        [self sendEventWithName:GTouchEventReminder body:@{
                                                           @"method": @"onLoadSuccess",
                                                           @"eventId": trackEventId,
                                                           @"eventType": eventType}];
    }
}

- (void)onEventPopupLoadFailed:(NSString *)trackEventId eventType:(NSString *)eventType withError:(NSError *)error {
    NSLog(@"RNGrowingTouch %s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
    if (self.hasListeners) {
        [self sendEventWithName:GTouchEventReminder body:@{
                                                           @"method": @"onLoadFailed",
                                                           @"eventId": trackEventId,
                                                           @"eventType": eventType,
                                                           @"errorCode": [NSNumber numberWithInteger:error.code],
                                                           @"description": error.description}];
    }
}

- (BOOL)onClickedEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType openUrl:(NSString *)openUrl {
    NSLog(@"RNGrowingTouch %s trackEventId = %@, openUrl = %@", __func__, trackEventId, openUrl);
    if (self.hasListeners) {
        [self sendEventWithName:GTouchEventReminder body:@{
                                                           @"method": @"onClicked",
                                                           @"eventId": trackEventId,
                                                           @"eventType": eventType,
                                                           @"openUrl": openUrl}];
    }
    return YES;
}

- (void)onCancelEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType {
    NSLog(@"RNGrowingTouch %s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
    if (self.hasListeners) {
        [self sendEventWithName:GTouchEventReminder body:@{
                                                           @"method": @"onCancel",
                                                           @"eventId": trackEventId,
                                                           @"eventType": eventType}];
    }
}

- (void)onTrackEventTimeout:(NSString *)trackEventId eventType:(NSString *)eventType {
    NSLog(@"RNGrowingTouch %s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
    if (self.hasListeners) {
        [self sendEventWithName:GTouchEventReminder body:@{
                                                           @"method": @"onTimeout",
                                                           @"eventId": trackEventId,
                                                           @"eventType": eventType}];
    }
}
@end

