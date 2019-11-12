//
// Created by xiangyang on 2018/12/18.
// Copyright (c) 2018 growingio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrowingTouchEventPopupDelegate <NSObject>
@optional
/**
 * 触达弹窗显示成功
 *
 * @param trackEventId 埋点事件名称
 * @param eventType 事件类型，system(触达SDK内置的事件)或custom(用户自定义的埋点事件)
 */
- (void)onEventPopupLoadSuccess:(NSString *)trackEventId eventType:(NSString *)eventType;

/**
 * 触达弹窗加载失败
 *
 * @param trackEventId 埋点事件名称
 * @param eventType 事件类型，system(触达SDK内置的事件)或custom(用户自定义的埋点事件)
 * @param error 发生的错误
 */
- (void)onEventPopupLoadFailed:(NSString *)trackEventId eventType:(NSString *)eventType withError:(NSError *)error;

/**
 * 用户点击了触达弹窗的有效内容。触达SDK现在只提供跳转APP内部界面和H5界面两种处理方式。
 * 您可以在这里接管跳转事件，处理需要跳转的url。您也可以自定义Url协议，实现更多业务和交互功能。
 *
 * @param trackEventId 埋点事件名称
 * @param eventType 事件类型，system(触达SDK内置的事件)或custom(用户自定义的埋点事件)
 * @param openUrl 跳转的url
 * @return true：点击事件被消费，触达SDK不在处理；false：由触达SDK处理点击事件
 */
- (BOOL)onClickedEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType openUrl:(NSString *)openUrl;

/**
 * 用户关闭了触达弹窗
 *
 * @param trackEventId 埋点事件名称
 * @param eventType 事件类型，system(触达SDK内置的事件)或custom(用户自定义的埋点事件)
 */
- (void)onCancelEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType;

/**
 *  触达弹窗显示超时
 *
 * @param trackEventId 埋点事件名称
 * @param eventType 事件类型，system(触达SDK内置的事件)或custom(用户自定义的埋点事件)
 */
- (void)onTrackEventTimeout:(NSString *)trackEventId eventType:(NSString *)eventType;
@end