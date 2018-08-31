//
//  XYAlert.h
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYAlertHelper.h"

@interface XYAlert : NSObject

/** 初始化 */
+ (XYAlertConfig *)alert;

+ (XYAlertConfig *)actionsheet;

/** 获取Alert窗口 */
+ (XYAlertWindow *)getAlertWindow;

/** 设置主窗口 */
+ (void)configMainWindow:(UIWindow *)window;

/** 继续队列显示 */
+ (void)continueQueueDisplay;

/** 继续队列显示 */
+ (void)clearQueue;

/** 关闭 */
+ (void)closeWithCompletionBlock:(void(^)(void))completionBlock;

@end

#pragma mark - XYAlertConfigModel 通用设置

@interface XYAlertConfigModel : NSObject

/** 设置 标题 -> 格式: .XyTitle(@"") */
@property (nonatomic , copy , readonly ) XYConfigToString XyTitle;
/** 设置 内容 -> 格式: .XyContent(@"") */
@property (nonatomic , copy , readonly ) XYConfigToString XyContent;
/** 设置 自定义视图 -> 格式: .XyCustomView(UIView) */
@property (nonatomic , copy , readonly ) XYConfigToView XyCustomView;
/** 设置 动作 -> 格式: .XyAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToStringAndBlock XyAction;
/** 设置 取消动作 -> 格式: .XyCancelAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToStringAndBlock XyCancelAction;
/** 设置 取消动作 -> 格式: .XyDestructiveAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToStringAndBlock XyDestructiveAction;
/** 设置 添加标题 -> 格式: .XyConfigTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToConfigLabel XyAddTitle;

/** 设置 添加内容 -> 格式: .XyConfigContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToConfigLabel XyAddContent;

/** 设置 添加自定义视图 -> 格式: .XyAddCustomView(^(LEECustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToCustomView XyAddCustomView;

/** 设置 添加一项 -> 格式: .XyAddItem(^(XYItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToItem XyAddItem;

/** 设置 添加动作 -> 格式: .XyAddAction(^(XYAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToAction XyAddAction;

/** 设置 头部内的间距 -> 格式: .XyHeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20)) */
@property (nonatomic , copy , readonly ) XYConfigToEdgeInsets XyHeaderInsets;

/** 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .XyItemInsets(UIEdgeInsetsMake(5, 0, 5, 0)) */
@property (nonatomic , copy , readonly ) XYConfigToEdgeInsets XyItemInsets;

/** 设置 最大宽度 -> 格式: .XyMaxWidth(280.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyMaxWidth;

/** 设置 最大高度 -> 格式: .XyMaxHeight(400.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyMaxHeight;

/** 设置 设置最大宽度 -> 格式: .XyConfigMaxWidth(CGFloat(^)(^CGFloat(XYScreenOrientationType type) { return 280.0f; }) */
@property (nonatomic , copy , readonly ) XYConfigToFloatBlock XyConfigMaxWidth;

/** 设置 设置最大高度 -> 格式: .XyConfigMaxHeight(CGFloat(^)(^CGFloat(XYScreenOrientationType type) { return 600.0f; }) */
@property (nonatomic , copy , readonly ) XYConfigToFloatBlock XyConfigMaxHeight;

/** 设置 圆角半径 -> 格式: .XyCornerRadius(13.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyCornerRadius;

/** 设置 开启动画时长 -> 格式: .XyOpenAnimationDuration(0.3f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .XyCloseAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyCloseAnimationDuration;

/** 设置 颜色 -> 格式: .LeeHeaderColor(UIColor) */
@property (nonatomic , copy , readonly ) XYConfigToColor XyHeaderColor;

/** 设置 背景颜色 -> 格式: .XyBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) XYConfigToColor XyBackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .XyBackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyBackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .XyBackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) XYConfigToBlurEffectStyle XyBackgroundStyleBlur;

/** 设置 点击头部关闭 -> 格式: .XyClickHeaderClose(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyClickHeaderClose;

/** 设置 点击背景关闭 -> 格式: .XyClickBackgroundClose(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyClickBackgroundClose;

/** 设置 阴影偏移 -> 格式: .LeeShadowOffset(CGSizeMake(0.0f, 2.0f)) */
@property (nonatomic , copy , readonly ) XYConfigToSize XyShadowOffset;

/** 设置 阴影不透明度 -> 格式: .XyShadowOpacity(0.3f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyShadowOpacity;

/** 设置 阴影半径 -> 格式: .XyShadowRadius(5.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyShadowRadius;

/** 设置 阴影颜色 -> 格式: .XyShadowColor(UIColor) */
@property (nonatomic , copy , readonly ) XYConfigToColor XyShadowColor;

/** 设置 是否加入到队列 -> 格式: .XyQueue(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyQueue;

/** 设置 优先级 -> 格式: .XyPriority(1000) */
@property (nonatomic , copy , readonly ) XYConfigToInteger XyPriority;

/** 设置 是否继续队列显示 -> 格式: .XyContinueQueue(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyContinueQueue;

/** 设置 window等级 -> 格式: .XyWindowLevel(UIWindowLevel) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyWindowLevel;

/** 设置 是否支持自动旋转 -> 格式: .XyShouldAutorotate(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyShouldAutorotate;

/** 设置 是否支持显示方向 -> 格式: .LeeShouldAutorotate(UIInterfaceOrientationMaskAll) */
@property (nonatomic , copy , readonly ) XYConfigToInterfaceOrientationMask XySupportedInterfaceOrientations;

/** 设置 打开动画配置 -> 格式: .XyOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToBlockAndBlock XyOpenAnimationConfig;

/** 设置 关闭动画配置 -> 格式: .XyCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToBlockAndBlock XyCloseAnimationConfig;

/** 设置 打开动画样式 -> 格式: .LeeOpenAnimationStyle() */
@property (nonatomic , copy , readonly ) XYConfigToAnimationStyle XyOpenAnimationStyle;

/** 设置 关闭动画样式 -> 格式: .XyCloseAnimationStyle() */
@property (nonatomic , copy , readonly ) XYConfigToAnimationStyle XyCloseAnimationStyle;

/** 设置 状态栏样式 -> 格式: .XyStatusBarStyle(UIStatusBarStyleDefault) */
@property (nonatomic , copy , readonly ) XYConfigToStatusBarStyle XyStatusBarStyle;


/** 显示  -> 格式: .XyShow() */
@property (nonatomic , copy , readonly ) XYConfig XyShow;


/** ✨alert 专用设置 */
/** 设置 添加输入框 -> 格式: .XyAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToConfigTextField XyAddTextField;

/** 设置 是否闪避键盘 -> 格式: .XyAvoidKeyboard(YES) */
@property (nonatomic , copy , readonly ) XYConfigToBool XyAvoidKeyboard;


/** ✨actionSheet 专用设置 */
/** 设置 ActionSheet的背景视图颜色 -> 格式: .XyActionSheetBackgroundColor(UIColor) */
@property (nonatomic , copy , readonly ) XYConfigToColor XyActionSheetBackgroundColor;

/** 设置 取消动作的间隔宽度 -> 格式: .XyActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .XyActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) XYConfigToColor XyActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .XyActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) XYConfigToFloat XyActionSheetBottomMargin;


/** 设置 当前关闭回调 -> 格式: .XyCloseComplete(^{ //code.. }) */
@property (nonatomic , copy , readonly ) XYConfigToBlock XyCloseComplete;


@end

#pragma mark - XYItem设置

@interface XYItem : NSObject

/** item类型 */
@property (nonatomic,assign) XYItemType type;
/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;
/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);
/** item更新 */
- (void)update;

@end

#pragma mark - XYAction设置

@interface XYAction : NSObject
/** action类型 */
@property (nonatomic,assign) XYActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic , strong ) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) XYActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickBlock)(void);

/** action更新 */
- (void)update;

@end

#pragma mark - XYCustomView设置
@interface XYCustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) XYCustomViewPositionType positionType;

/** 是否自动适应宽度 */
@property (nonatomic , assign ) BOOL isAutoWidth;

@end

#pragma mark - XYCustomView设置
@interface XYAlertConfig : NSObject

@property (nonatomic , strong ) XYAlertConfigModel *config;

@property (nonatomic , assign ) XYAlertType type;

@end

#pragma mark - XYAlert 视图设置

@interface XYAlertWindow : UIWindow @end;

@interface XYAlertBaseViewController : UIViewController @end;

@interface XYAlertViewController : XYAlertBaseViewController @end;

@interface XYActionSheetViewController : XYAlertBaseViewController @end
