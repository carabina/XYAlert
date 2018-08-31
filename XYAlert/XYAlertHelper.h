//
//  XYAlertHelper.h
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#ifndef XYAlertHelper_h
#define XYAlertHelper_h

FOUNDATION_EXPORT double XYAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char XYAlertVersionString[];

@class XYAlert , XYAlertConfig , XYAlertConfigModel , XYAlertWindow , XYAction , XYItem , XYCustomView;

typedef NS_ENUM(NSInteger, XYScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    XYScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    XYScreenOrientationTypeVertical
};

typedef NS_ENUM(NSInteger, XYAlertType) {
    /** 弹窗的类型 alert */
    XYAlertTypeAlert,
    /** 弹窗的类型 actionSheet */
    XYAlertTypeActionSheet
};

typedef NS_ENUM(NSInteger, XYActionType) {
    /** 默认 */
    XYActionTypeDefault,
    /** 取消 */
    XYActionTypeCancel,
    /** 销毁 */
    XYActionTypeDestructive
};

typedef NS_OPTIONS(NSInteger, XYActionBorderPosition) {
    /** Action边框位置 上 */
    XYActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    XYActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    XYActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    XYActionBorderPositionRight    = 1 << 3
};

typedef NS_ENUM(NSInteger, XYItemType) {
    /** 标题 */
    XYItemTypeTitle,
    /** 内容 */
    XYItemTypeContent,
    /** 输入框 */
    XYItemTypeTextField,
    /** 自定义视图 */
    XYItemTypeCustomView,
};

typedef NS_ENUM(NSInteger, XYCustomViewPositionType) {
    /** 居中 */
    XYCustomViewPositionTypeCenter,
    /** 靠左 */
    XYCustomViewPositionTypeLeft,
    /** 靠右 */
    XYCustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, XYAnimationStyle) {
    /** 动画样式方向 默认 */
    XYAnimationStyleOrientationNone    = 1 << 0,
    /** 动画样式方向 上 */
    XYAnimationStyleOrientationTop     = 1 << 1,
    /** 动画样式方向 下 */
    XYAnimationStyleOrientationBottom  = 1 << 2,
    /** 动画样式方向 左 */
    XYAnimationStyleOrientationLeft    = 1 << 3,
    /** 动画样式方向 右 */
    XYAnimationStyleOrientationRight   = 1 << 4,
    
    /** 动画样式 淡入淡出 */
    XYAnimationStyleFade               = 1 << 12,
    
    /** 动画样式 缩放 放大 */
    XYAnimationStyleZoomEnlarge        = 1 << 24,
    /** 动画样式 缩放 缩小 */
    XYAnimationStyleZoomShrink         = 2 << 24,
};

//定义Alert的相关配置
typedef XYAlertConfigModel *(^XYConfig)(void);
typedef XYAlertConfigModel *(^XYConfigToBool)(BOOL is);
typedef XYAlertConfigModel *(^XYConfigToInteger)(NSInteger number);
typedef XYAlertConfigModel *(^XYConfigToFloat)(CGFloat number);
typedef XYAlertConfigModel *(^XYConfigToString)(NSString *str);
typedef XYAlertConfigModel *(^XYConfigToView)(UIView *view);
typedef XYAlertConfigModel *(^XYConfigToColor)(UIColor *color);
typedef XYAlertConfigModel *(^XYConfigToSize)(CGSize size);
typedef XYAlertConfigModel *(^XYConfigToEdgeInsets)(UIEdgeInsets insets);
typedef XYAlertConfigModel *(^XYConfigToAnimationStyle)(XYAnimationStyle style);
typedef XYAlertConfigModel *(^XYConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef XYAlertConfigModel *(^XYConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef XYAlertConfigModel *(^XYConfigToFloatBlock)(CGFloat(^)(XYScreenOrientationType type));
typedef XYAlertConfigModel *(^XYConfigToAction)(void(^)(XYAction *action));
typedef XYAlertConfigModel *(^XYConfigToCustomView)(void(^)(XYCustomView *custom));
typedef XYAlertConfigModel *(^XYConfigToStringAndBlock)(NSString *str , void (^)(void));
typedef XYAlertConfigModel *(^XYConfigToConfigLabel)(void(^)(UILabel *label));
typedef XYAlertConfigModel *(^XYConfigToConfigTextField)(void(^)(UITextField *textField));
typedef XYAlertConfigModel *(^XYConfigToItem)(void(^)(XYItem *item));
typedef XYAlertConfigModel *(^XYConfigToBlock)(void(^block)(void));
typedef XYAlertConfigModel *(^XYConfigToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));
typedef XYAlertConfigModel *(^XYConfigToStatusBarStyle)(UIStatusBarStyle style);

#endif /* XYAlertHelper_h */
