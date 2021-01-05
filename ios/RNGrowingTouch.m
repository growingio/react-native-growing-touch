
#import "RNGrowingTouch.h"

static NSString *const GTouchEventReminder = @"GTouchEventReminder";
static NSString *const GrowingTouchClass = @"GrowingTouch";

@interface RNGrowingTouch ()
@property(nonatomic, assign) bool hasListeners;
@end

@implementation RNGrowingTouch

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(setEventPopupEnable:(BOOL) enable) {
    NSLog(@"RNGrowingTouch setEventPopupEnable: enable = %d", enable);
    Class clazz = NSClassFromString(GrowingTouchClass);
    BOOL responds = [clazz respondsToSelector:@selector(setEventPopupEnable:)];
    
    if (!clazz || !responds) {
        NSLog(@"RNGrowingTouch do not found GrowingTouch");
        return;
    }
    [clazz performSelector:@selector(setEventPopupEnable:) withObject:@(enable)];
}

RCT_REMAP_METHOD(isEventPopupEnabled,
                 isEventPopupEnabledWithResolver:(RCTPromiseResolveBlock) resolve
                 rejecter:(RCTPromiseRejectBlock) reject) {
    Class clazz = NSClassFromString(GrowingTouchClass);
    BOOL responds = [clazz respondsToSelector:@selector(isEventPopupEnabled)];
    
    if (!clazz || !responds) {
        NSLog(@"RNGrowingTouch do not found GrowingTouch");
        return;
    }
    bool enable = [clazz performSelector:@selector(isEventPopupEnabled)];

    NSLog(@"RNGrowingTouch isEventPopupEnabled: enable = %d", enable);
    NSDictionary *data = @{@"popupEnabled": @(enable)};
    resolve(data);
}

RCT_EXPORT_METHOD(enableEventPopupAndGenerateAppOpenEvent) {
    NSLog(@"RNGrowingTouch enableEventPopupAndGenerateAppOpenEvent");
    Class clazz = NSClassFromString(GrowingTouchClass);
    BOOL responds = [clazz respondsToSelector:@selector(enableEventPopupAndGenerateAppOpenEvent)];
    
    if (!clazz || !responds) {
        NSLog(@"RNGrowingTouch do not found GrowingTouch");
        return;
    }
    
    [clazz performSelector:@selector(enableEventPopupAndGenerateAppOpenEvent)];
}

RCT_REMAP_METHOD(isEventPopupShowing,
                 isEventPopupShowingWithResolver:(RCTPromiseResolveBlock) resolve
                 rejecter:(RCTPromiseRejectBlock) reject) {
    Class clazz = NSClassFromString(GrowingTouchClass);
    BOOL responds = [clazz respondsToSelector:@selector(isEventPopupShowing)];
    
    if (!clazz || !responds) {
        NSLog(@"RNGrowingTouch do not found GrowingTouch");
        return;
    }
    bool isShowing = [clazz performSelector:@selector(isEventPopupShowing)];
    
    NSLog(@"RNGrowingTouch isEventPopupShowing: isShowing = %d", isShowing);
    NSDictionary *data = @{@"popupShowing": @(isShowing)};
    resolve(data);
}

RCT_EXPORT_METHOD(setEventPopupListener) {
    NSLog(@"RNGrowingTouch setEventPopupListener");
    Class clazz = NSClassFromString(GrowingTouchClass);
    BOOL responds = [clazz respondsToSelector:@selector(setEventPopupDelegate:)];
    
    if (!clazz || !responds) {
        NSLog(@"RNGrowingTouch do not found GrowingTouch");
        return;
    }
    [clazz performSelector:@selector(setEventPopupDelegate:) withObject:self];
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
/**
 * 触达弹窗消费时（待展示时）
 * @param popup 待展示的弹窗数据
 *
 * @param action 弹窗绑定的操作行为
 *
 * @return true：自定义展示该弹窗，触达SDK不在处理；false：由触达来展示该弹窗，
 * @discussion 在 popup.rule.target 数据中可以取出配置的 target 数据，比如一张图片的链接或其他参数，进行自定义的弹窗展示
 */
- (BOOL)popupEventDecideShowPopupView:(GrowingPopupWindowEvent *)popup decisionAction:(GrowingEventPopupDecisionAction *)action {
    return NO;
}
@end

