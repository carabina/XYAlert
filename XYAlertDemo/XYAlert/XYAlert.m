//
//  XYAlert.m
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "XYAlert.h"

#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)
#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, XYBackgroundStyle) {
    /** 背景样式 模糊 */
    XYBackgroundStyleBlur,
    /** 背景样式 半透明 */
    XYBackgroundStyleTranslucent,
};

@interface XYAlertConfigModel ()

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelShadowRadius;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic , assign ) CGFloat modelWindowLevel;
@property (nonatomic , assign ) NSInteger modelQueuePriority;

@property (nonatomic , assign ) UIColor *modelShadowColor;
@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickHeaderClose;
@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsShouldAutorotate;
@property (nonatomic , assign ) BOOL modelIsQueue;
@property (nonatomic , assign ) BOOL modelIsContinueQueueDisplay;
@property (nonatomic , assign ) BOOL modelIsAvoidKeyboard;

@property (nonatomic , assign ) CGSize modelShadowOffset;
@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) NSString *modelIdentifier;

@property (nonatomic , copy ) CGFloat (^modelMaxWidthBlock)(XYScreenOrientationType);
@property (nonatomic , copy ) CGFloat (^modelMaxHeightBlock)(XYScreenOrientationType);

@property (nonatomic , copy ) void(^modelOpenAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void(^modelCloseAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void (^modelFinishConfig)(void);
@property (nonatomic , copy ) void (^modelCloseComplete)(void);

@property (nonatomic , assign ) XYBackgroundStyle modelBackgroundStyle;
@property (nonatomic , assign ) XYAnimationStyle modelOpenAnimationStyle;
@property (nonatomic , assign ) XYAnimationStyle modelCloseAnimationStyle;

@property (nonatomic , assign ) UIStatusBarStyle modelStatusBarStyle;
@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic , assign ) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;

@property (nonatomic , strong ) UIColor *modelActionSheetBackgroundColor;
@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end

@implementation XYAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 13.0f; //默认圆角半径
        _modelShadowOpacity = 0.3f; //默认阴影不透明度
        _modelShadowRadius = 5.0f; //默认阴影半径
        _modelShadowOffset = CGSizeMake(0.0f, 2.0f); //默认阴影偏移
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        _modelWindowLevel = UIWindowLevelAlert;
        _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
        
        
        _modelActionSheetBackgroundColor = [UIColor clearColor]; //默认actionsheet背景颜色
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelShadowColor = [UIColor blackColor]; //默认阴影颜色
        _modelHeaderColor = [UIColor whiteColor]; //默认颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsShouldAutorotate = YES; //默认支持自动旋转
        _modelIsQueue = NO; //默认不加入队列
        _modelIsContinueQueueDisplay = YES; //默认继续队列显示
        _modelIsAvoidKeyboard = YES; //默认闪避键盘
        
        _modelBackgroundStyle = XYBackgroundStyleTranslucent; //默认为半透明背景样式
        
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
        
        __weak typeof(self) weakSelf = self;
        
        _modelOpenAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelOpenAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelCloseAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelCloseAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        
    }
    return self;
}

- (XYConfigToString)XyTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return weakSelf.XyAddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (XYConfigToString)XyContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return  weakSelf.XyAddContent(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}

- (XYConfigToView)XyCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        return weakSelf.XyAddCustomView(^(XYCustomView *custom) {
            
            custom.view = view;
            
            custom.positionType = XYCustomViewPositionTypeCenter;
        });
        
    };
    
}

- (XYConfigToStringAndBlock)XyAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.XyAddAction(^(XYAction *action) {
            
            action.type = XYActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (XYConfigToStringAndBlock)XyCancelAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.XyAddAction(^(XYAction *action) {
            
            action.type = XYActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (XYConfigToStringAndBlock)XyDestructiveAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.XyAddAction(^(XYAction *action) {
            
            action.type = XYActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor redColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (XYConfigToConfigLabel)XyAddTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.XyAddItem(^(XYItem *item) {
            
            item.type = XYItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        ;
    };
    
}

- (XYConfigToConfigLabel)XyAddContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.XyAddItem(^(XYItem *item) {
            
            item.type = XYItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (XYConfigToCustomView)XyAddCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(XYCustomView *custom)){
        
        return weakSelf.XyAddItem(^(XYItem *item) {
            
            item.type = XYItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (XYConfigToItem)XyAddItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(XYItem *)){
        
        if (weakSelf) if (block) [weakSelf.modelItemArray addObject:block];
        
        return weakSelf;
    };
    
}

- (XYConfigToAction)XyAddAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(XYAction *)){
        
        if (weakSelf) if (block) [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };
    
}

- (XYConfigToEdgeInsets)XyHeaderInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            weakSelf.modelHeaderInsets = insets;
        }
        
        return weakSelf;
    };
    
}

- (XYConfigToEdgeInsets)XyItemInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (weakSelf.modelItemArray.count) {
                
                if (insets.top < 0) insets.top = 0;
                
                if (insets.left < 0) insets.left = 0;
                
                if (insets.bottom < 0) insets.bottom = 0;
                
                if (insets.right < 0) insets.right = 0;
                
                [weakSelf.modelItemInsetsInfo setObject:[NSValue valueWithUIEdgeInsets:insets] forKey:@(weakSelf.modelItemArray.count - 1)];
                
            } else {
                
                NSAssert(YES, @"请在添加的某一项后面设置间距");
            }
            
        }
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (XYConfigToFloat)XyMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.XyConfigMaxHeight(^CGFloat(XYScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (XYConfigToFloatBlock)XyConfigMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(XYScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxWidthBlock = block;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloatBlock)XyConfigMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(XYScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxHeightBlock = block;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCornerRadius = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelOpenAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCloseAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToColor)XyHeaderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelHeaderColor = color;
        
        return weakSelf;
    };
    
}

- (XYConfigToColor)XyBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelBackgroundColor = color;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyBackgroundStyleTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = XYBackgroundStyleTranslucent;
            
            weakSelf.modelBackgroundStyleColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (XYConfigToBlurEffectStyle)XyBackgroundStyleBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIBlurEffectStyle style){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = XYBackgroundStyleBlur;
            
            weakSelf.modelBackgroundBlurEffectStyle = style;
        }
        
        return weakSelf;
    };
    
}

- (XYConfigToBool)XyClickHeaderClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickHeaderClose = is;
        
        return weakSelf;
    };
    
}

- (XYConfigToBool)XyClickBackgroundClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickBackgroundClose = is;
        
        return weakSelf;
    };
    
}

- (XYConfigToSize)XyShadowOffset{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGSize size){
        
        if (weakSelf) weakSelf.modelShadowOffset = size;
        
        return weakSelf;
    };
}

- (XYConfigToFloat)XyShadowOpacity{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowOpacity = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyShadowRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowRadius = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToColor)XyShadowColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelShadowColor = color;
        
        return weakSelf;
    };
    
}

- (XYConfigToString)XyIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) weakSelf.modelIdentifier = string;
        
        return weakSelf;
    };
    
}

- (XYConfigToBool)XyQueue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsQueue = is;
        
        return weakSelf;
    };
    
}

- (XYConfigToInteger)XyPriority{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger number){
        
        if (weakSelf) weakSelf.modelQueuePriority = number > 0 ? number : 0;
        
        return weakSelf;
    };
    
}

- (XYConfigToBool)XyContinueQueueDisplay{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsContinueQueueDisplay = is;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyWindowLevel{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelWindowLevel = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToBool)XyShouldAutorotate{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsShouldAutorotate = is;
        
        return weakSelf;
    };
    
}

- (XYConfigToInterfaceOrientationMask)XySupportedInterfaceOrientations{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIInterfaceOrientationMask mask){
        
        if (weakSelf) weakSelf.modelSupportedInterfaceOrientations = mask;
        
        return weakSelf;
    };
    
}

- (XYConfigToBlockAndBlock)XyOpenAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelOpenAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (XYConfigToBlockAndBlock)XyCloseAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelCloseAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (XYConfigToAnimationStyle)XyOpenAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(XYAnimationStyle style){
        
        if (weakSelf) weakSelf.modelOpenAnimationStyle = style;
        
        return weakSelf;
    };
    
}

- (XYConfigToAnimationStyle)XyCloseAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(XYAnimationStyle style){
        
        if (weakSelf) weakSelf.modelCloseAnimationStyle = style;
        
        return weakSelf;
    };
    
}

- (XYConfigToStatusBarStyle)XyStatusBarStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIStatusBarStyle style){
        
        if (weakSelf) weakSelf.modelStatusBarStyle = style;
        
        return weakSelf;
    };
    
}


- (XYConfig)XyShow{
    
    __weak typeof(self) weakSelf = self;
    
    return ^{
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig();
        }
        
        return weakSelf;
    };
    
}

#pragma mark Alert Config

- (XYConfigToConfigTextField)XyAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        return weakSelf.XyAddItem(^(XYItem *item) {
            
            item.type = XYItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
    };
    
}

- (XYConfigToBool)XyAvoidKeyboard{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsAvoidKeyboard = is;
        
        return weakSelf;
    };
    
}

#pragma mark ActionSheet Config

- (XYConfigToFloat)XyActionSheetCancelActionSpaceWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceWidth = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToColor)XyActionSheetCancelActionSpaceColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceColor = color;
        
        return weakSelf;
    };
    
}

- (XYConfigToFloat)XyActionSheetBottomMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetBottomMargin = number;
        
        return weakSelf;
    };
    
}

- (XYConfigToColor)XyActionSheetBackgroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelActionSheetBackgroundColor = color;
        
        return weakSelf;
    };
    
}

- (XYConfigToBlock)XyCloseComplete{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(void)){
        
        if (weakSelf) weakSelf.modelCloseComplete = block;
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
    
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelItemArray{
    
    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];
    
    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{
    
    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];
    
    return _modelItemInsetsInfo;
}

@end

@interface XYAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) XYAlertWindow *XyWindow;

@property (nonatomic , strong ) NSMutableArray <XYAlertConfig *>*queueArray;

@property (nonatomic , strong ) XYAlertBaseViewController *viewController;

@end

@protocol XYAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end

@implementation XYAlert

+ (XYAlert *)shareManager{
    
    static XYAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [[XYAlert alloc] init];
    });
    
    return alertManager;
}

+ (XYAlertConfig *)alert{
    
    XYAlertConfig *config = [[XYAlertConfig alloc] init];
    
    config.type = XYAlertTypeAlert;
    
    return config;
}

+ (XYAlertConfig *)actionsheet{
    
    XYAlertConfig *config = [[XYAlertConfig alloc] init];
    
    config.type = XYAlertTypeActionSheet;
    
    config.config.XyClickBackgroundClose(YES);
    
    return config;
}

+ (XYAlertWindow *)getAlertWindow{
    
    return [XYAlert shareManager].XyWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [XYAlert shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    
    if ([XYAlert shareManager].queueArray.count) [XYAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
}

+ (void)clearQueue{
    
    [[XYAlert shareManager].queueArray removeAllObjects];
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([XYAlert shareManager].queueArray.count) {
        
        XYAlertConfig *item = [XYAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
    
}

#pragma mark LazyLoading

- (NSMutableArray <XYAlertConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (XYAlertWindow *)XyWindow{
    
    if (!_XyWindow) {
        
        _XyWindow = [[XYAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _XyWindow.rootViewController = [[UIViewController alloc] init];
        
        _XyWindow.backgroundColor = [UIColor clearColor];
        
        _XyWindow.windowLevel = UIWindowLevelAlert;
        
        _XyWindow.hidden = YES;
    }
    
    return _XyWindow;
}

@end

@implementation XYAlertWindow

@end

@interface XYItem ()

@property (nonatomic , copy ) void (^updateBlock)(XYItem *);

@end

@implementation XYItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface XYAction ()

@property (nonatomic , copy ) void (^updateBlock)(XYAction *);

@end

@implementation XYAction

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface XYItemView : UIView

@property (nonatomic , strong ) XYItem *item;

+ (XYItemView *)view;

@end

@implementation XYItemView

+ (XYItemView *)view{
    
    return [[XYItemView alloc] init];
}

@end

@interface XYItemLabel : UILabel

@property (nonatomic , strong ) XYItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)(void);

+ (XYItemLabel *)label;

@end

@implementation XYItemLabel

+ (XYItemLabel *)label{
    
    return [[XYItemLabel alloc] init];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    
    [super setNumberOfLines:numberOfLines];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

@end

@interface XYItemTextField : UITextField

@property (nonatomic , strong ) XYItem *item;

+ (XYItemTextField *)textField;

@end

@implementation XYItemTextField

+ (XYItemTextField *)textField{
    
    return [[XYItemTextField alloc] init];
}

@end

@interface XYActionButton : UIButton

@property (nonatomic , strong ) XYAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)(void);

+ (XYActionButton *)button;

@end

@interface XYActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation XYActionButton

+ (XYActionButton *)button{
    
    return [XYActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(XYAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.backgroundImage) [self setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];
    
    if (action.backgroundHighlightImage) [self setBackgroundImage:action.backgroundHighlightImage forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setActionHeight:action.height];
    
    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];
    
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titleEdgeInsets];
    
    if (action.borderPosition & XYActionBorderPositionTop &&
        action.borderPosition & XYActionBorderPositionBottom &&
        action.borderPosition & XYActionBorderPositionLeft &&
        action.borderPosition & XYActionBorderPositionRight) {
        
        self.layer.borderWidth = action.borderWidth;
        
        self.layer.borderColor = action.borderColor.CGColor;
        
        [self removeTopBorder];
        
        [self removeBottomBorder];
        
        [self removeLeftBorder];
        
        [self removeRightBorder];
        
    } else {
        
        self.layer.borderWidth = 0.0f;
        
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (action.borderPosition & XYActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];
        
        if (action.borderPosition & XYActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];
        
        if (action.borderPosition & XYActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];
        
        if (action.borderPosition & XYActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }
    
    __weak typeof(self) weakSelf = self;
    
    action.updateBlock = ^(XYAction *act) {
        
        if (weakSelf) weakSelf.action = act;
    };
    
}

- (CGFloat)actionHeight{
    
    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{
    
    BOOL isChange = [self actionHeight] == height ? NO : YES;
    
    CGRect buttonFrame = self.frame;
    
    buttonFrame.size.height = height;
    
    self.frame = buttonFrame;
    
    if (isChange) {
        
        if (self.heightChangedBlock) self.heightChangedBlock();
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);
    
    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);
    
    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);
    
    if (_rightLayer) _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
}

- (void)addTopBorder{
    
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    
    [self.layer addSublayer:self.rightLayer];
}

- (void)removeTopBorder{
    
    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{
    
    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{
    
    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{
    
    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
}

- (CALayer *)createLayer{
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = self.borderColor.CGColor;
    
    return layer;
}

- (CALayer *)topLayer{
    
    if (!_topLayer) _topLayer = [self createLayer];
    
    return _topLayer;
}

- (CALayer *)bottomLayer{
    
    if (!_bottomLayer) _bottomLayer = [self createLayer];
    
    return _bottomLayer;
}

- (CALayer *)leftLayer{
    
    if (!_leftLayer) _leftLayer = [self createLayer];
    
    return _leftLayer;
}

- (CALayer *)rightLayer{
    
    if (!_rightLayer) _rightLayer = [self createLayer];
    
    return _rightLayer;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface XYCustomView ()

@property (nonatomic , strong ) XYItem *item;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)(void);

@end

@implementation XYCustomView

- (void)dealloc{
    
    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangedBlock:(void (^)(void))sizeChangedBlock{
    
    _sizeChangedBlock = sizeChangedBlock;
    
    if (_view) {
        
        [_view layoutSubviews];
        
        _size = _view.frame.size;
        
        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *view = (UIView *)object;
    
    if (self.isAutoWidth) {
        self.size = CGSizeMake(view.frame.size.width, self.size.height);
    }
    
    if (!CGSizeEqualToSize(self.size, view.frame.size)) {
        
        self.size = view.frame.size;
        
        if (self.sizeChangedBlock) self.sizeChangedBlock();
    }
    
}

@end

@interface XYAlertBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong ) XYAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) XYScreenOrientationType orientationType;

@property (nonatomic , strong ) XYCustomView *customView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)(void);

@property (nonatomic , copy ) void (^closeFinishBlock)(void);

@end

@implementation XYAlertBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
    
    _customView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.config.modelBackgroundStyle == XYBackgroundStyleBlur) {
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
        [self.view addSubview:self.backgroundVisualEffectView];
    }
    
    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
    
    self.orientationType = VIEW_HEIGHT > VIEW_WIDTH ? XYScreenOrientationTypeVertical : XYScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.orientationType = size.height > size.width ? XYScreenOrientationTypeVertical : XYScreenOrientationTypeHorizontal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
    
    [self.view setUserInteractionEnabled:NO];
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [[XYAlert shareManager].XyWindow endEditing:YES];
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [XYAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![XYAlert shareManager].mainWindow) [XYAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{
    
    return self.config.modelIsShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.config.modelSupportedInterfaceOrientations;
}

#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return self.config.modelStatusBarStyle;
}

@end

#pragma mark - Alert

@interface XYAlertViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <XYActionButton *>*alertActionArray;

@end

@implementation XYAlertViewController
{
    CGFloat alertViewHeight;
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
    if (self.config.modelIsAvoidKeyboard) {
        
        double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        isShowingKeyboard = keyboardFrame.origin.y < SCREEN_HEIGHT;
        
        [UIView beginAnimations:@"keyboardWillChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        [self updateAlertLayout];
        
        [UIView commitAnimations];
    }
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateAlertLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateAlertLayout];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            [self updateAlertItemsLayout];
            
            CGFloat keyboardY = keyboardFrame.origin.y;
            
            CGRect alertViewFrame = self.alertView.frame;
            
            CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
            
            CGFloat tempAlertViewY = keyboardY - tempAlertViewHeight - 10;
            
            CGFloat originalAlertViewY = (viewHeight - alertViewFrame.size.height) * 0.5f;
            
            alertViewFrame.size.height = tempAlertViewHeight;
            
            alertViewFrame.size.width = alertViewMaxWidth;
            
            self.alertView.frame = alertViewFrame;
            
            CGRect containerFrame = self.containerView.frame;
            
            containerFrame.size.width = alertViewFrame.size.width;
            
            containerFrame.size.height = alertViewFrame.size.height;
            
            containerFrame.origin.x = (viewWidth - alertViewFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY;
            
            self.containerView.frame = containerFrame;
            
            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
        }
        
    } else {
        
        [self updateAlertItemsLayout];
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        self.alertView.frame = alertViewFrame;
        
        CGRect containerFrame = self.containerView.frame;
        
        containerFrame.size.width = alertViewFrame.size.width;
        
        containerFrame.size.height = alertViewFrame.size.height;
        
        containerFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - alertViewFrame.size.height) * 0.5f;
        
        self.containerView.frame = containerFrame;
    }
    
}

- (void)updateAlertItemsLayout{
    
    [UIView setAnimationsEnabled:NO];
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self->alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            XYItemView *view = (XYItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = self->alertViewHeight + view.item.insets.top;
            
            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            self->alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:XYCustomView.class]) {
            
            XYCustomView *custom = (XYCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = XYCustomViewPositionTypeCenter;
                
                viewFrame.size.width = alertViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case XYCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case XYCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case XYCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = alertViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = self->alertViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            self->alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) self->alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (XYActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2) {
        
        XYActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        XYActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
        
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);
    
    [UIView setAnimationsEnabled:YES];
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.alertView];
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.alertView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(XYItem *) = obj;
        
        XYItem *item = [[XYItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case XYItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                XYItemLabel *label = [XYItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case XYItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                XYItemLabel *label = [XYItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case XYItemTypeCustomView:
            {
                void(^block)(XYCustomView *) = item.block;
                
                XYCustomView *custom = [[XYCustomView alloc] init];
                
                block(custom);
                
                [self.alertView addSubview:custom.view];
                
                [self.alertItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case XYItemTypeTextField:
            {
                XYItemTextField *textField = [XYItemTextField textField];
                textField.frame = CGRectMake(0, 0, 0, 40.0f);
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item.block;
                
                if (block) block(textField);
                
                textField.item = item;
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^block)(XYAction *action) = item;
        
        XYAction *action = [[XYAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? XYActionBorderPositionTop | XYActionBorderPositionRight : XYActionBorderPositionTop;
        
        if (!action.height) action.height = 45.0f;
        
        XYActionButton *button = [XYActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) [weakSelf updateAlertLayout];
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (XYActionButton *button in self.alertActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case XYActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                    
                case XYActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case XYActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == XYBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == XYBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == XYBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == XYBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationNone) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.alertView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc] init];
        
        _alertView.backgroundColor = self.config.modelHeaderColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_alertView addGestureRecognizer:tap];
    }
    
    return _alertView;
}

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
}

- (NSMutableArray <XYActionButton *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface XYActionSheetViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <XYActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) XYActionButton *actionSheetCancelAction;

@end

@implementation XYActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateActionSheetLayout];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    [UIView setAnimationsEnabled:NO];
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            XYItemView *view = (XYItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left + VIEWSAFEAREAINSETS(view).left;
            
            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;
            
            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right - VIEWSAFEAREAINSETS(view).left - VIEWSAFEAREAINSETS(view).right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:XYCustomView.class]) {
            
            XYCustomView *custom = (XYCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = XYCustomViewPositionTypeCenter;
                
                viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case XYCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case XYCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case XYCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (XYActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    [UIView setAnimationsEnabled:YES];
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.actionHeight + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = actionSheetViewFrame.origin.x;
        
        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = actionSheetViewFrame.origin.x;
        
        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
    CGRect containerFrame = self.containerView.frame;
    
    containerFrame.size.width = viewWidth;
    
    containerFrame.size.height = actionSheetViewFrame.size.height + cancelActionTotalHeight + VIEWSAFEAREAINSETS(self.view).bottom + self.config.modelActionSheetBottomMargin;
    
    containerFrame.origin.x = 0;
    
    if (isShowed) {
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
    } else {
        
        containerFrame.origin.y = viewHeight;
    }
    
    self.containerView.frame = containerFrame;
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.actionSheetView];
    
    self.containerView.backgroundColor = self.config.modelActionSheetBackgroundColor;
    
    self.containerView.layer.shadowOffset = self.config.modelShadowOffset;
    
    self.containerView.layer.shadowRadius = self.config.modelShadowRadius;
    
    self.containerView.layer.shadowOpacity = self.config.modelShadowOpacity;
    
    self.containerView.layer.shadowColor = self.config.modelShadowColor.CGColor;
    
    self.actionSheetView.layer.cornerRadius = self.config.modelCornerRadius;
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        void (^itemBlock)(XYItem *) = obj;
        
        XYItem *item = [[XYItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case XYItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                XYItemLabel *label = [XYItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case XYItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                XYItemLabel *label = [XYItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case XYItemTypeCustomView:
            {
                void(^block)(XYCustomView *) = item.block;
                
                XYCustomView *custom = [[XYCustomView alloc] init];
                
                block(custom);
                
                [self.actionSheetView addSubview:custom.view];
                
                [self.actionSheetItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }
        
    }];
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(XYAction *action) = item;
        
        XYAction *action = [[XYAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.height) action.height = 57.0f;
        
        XYActionButton *button = [XYActionButton button];
        
        switch (action.type) {
                
            case XYActionTypeCancel:
            {
                [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.layer.cornerRadius = self.config.modelCornerRadius;
                
                button.backgroundColor = action.backgroundColor;
                
                [self.containerView addSubview:button];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.containerView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = XYActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.action = action;
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) {
            
            [weakSelf updateActionSheetLayout];
        }
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (XYActionButton *button in self.actionSheetActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case XYActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                    
                case XYActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case XYActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    void (^clickBlock)(void) = self.actionSheetCancelAction.action.clickBlock;
    
    [self closeAnimationsWithCompletionBlock:^{
        
        if (clickBlock) clickBlock();
    }];
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & XYAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & XYAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case XYBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
            }
                break;
                
            case XYBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.config.modelBackgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight - containerFrame.size.height;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case XYBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.alpha = 0.0f;
            }
                break;
                
            case XYBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationNone) {
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & XYAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.actionSheetView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc] init];
        
        _actionSheetView.backgroundColor = self.config.modelHeaderColor;
        
        _actionSheetView.directionalLockEnabled = YES;
        
        _actionSheetView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_actionSheetView addGestureRecognizer:tap];
    }
    
    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
}

- (NSMutableArray <XYActionButton *>*)actionSheetActionArray{
    
    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];
    
    return _actionSheetActionArray;
}

@end

@interface XYAlertConfig ()<XYAlertProtocol>

@end

@implementation XYAlertConfig

- (void)dealloc{
    
    _config = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
            
            if ([XYAlert shareManager].queueArray.count) {
                
                XYAlertConfig *last = [XYAlert shareManager].queueArray.lastObject;
                
                if (!strongSelf.config.modelIsQueue && last.config.modelQueuePriority > strongSelf.config.modelQueuePriority) return;
                
                if (!last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) [[XYAlert shareManager].queueArray removeObject:last];
                
                if (![[XYAlert shareManager].queueArray containsObject:strongSelf]) {
                    
                    [[XYAlert shareManager].queueArray addObject:strongSelf];
                    
                    [[XYAlert shareManager].queueArray sortUsingComparator:^NSComparisonResult(XYAlertConfig *configA, XYAlertConfig *configB) {
                        
                        return configA.config.modelQueuePriority > configB.config.modelQueuePriority ? NSOrderedDescending
                        : configA.config.modelQueuePriority == configB.config.modelQueuePriority ? NSOrderedSame : NSOrderedAscending;
                    }];
                    
                }
                
                if ([XYAlert shareManager].queueArray.lastObject == strongSelf) [strongSelf show];
                
            } else {
                
                [strongSelf show];
                
                [[XYAlert shareManager].queueArray addObject:strongSelf];
            }
            
        };
        
    }
    
    return self;
}

- (void)setType:(XYAlertType)type{
    
    _type = type;
    
    // 处理默认值
    
    switch (type) {
            
        case XYAlertTypeAlert:
            
            self.config
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                return 280.0f;
            })
            .XyConfigMaxHeight(^CGFloat(XYScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).bottom;
            })
            .XyOpenAnimationStyle(XYAnimationStyleOrientationNone | XYAnimationStyleFade | XYAnimationStyleZoomEnlarge)
            .XyCloseAnimationStyle(XYAnimationStyleOrientationNone | XYAnimationStyleFade | XYAnimationStyleZoomShrink);
            
            break;
            
        case XYAlertTypeActionSheet:
            
            self.config
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                return type == XYScreenOrientationTypeHorizontal ? SCREEN_HEIGHT - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).bottom - 20.0f : SCREEN_WIDTH - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).left - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).right - 20.0f;
            })
            .XyConfigMaxHeight(^CGFloat(XYScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).top - VIEWSAFEAREAINSETS([XYAlert getAlertWindow]).bottom;
            })
            .XyOpenAnimationStyle(XYAnimationStyleOrientationBottom)
            .XyCloseAnimationStyle(XYAnimationStyleOrientationBottom);
            
            break;
            
        default:
            break;
    }
    
}

- (void)show{
    
    switch (self.type) {
            
        case XYAlertTypeAlert:
            
            [XYAlert shareManager].viewController = [[XYAlertViewController alloc] init];
            
            break;
            
        case XYAlertTypeActionSheet:
            
            [XYAlert shareManager].viewController = [[XYActionSheetViewController alloc] init];
            
            break;
            
        default:
            break;
    }
    
    if (![XYAlert shareManager].viewController) return;
    
    [XYAlert shareManager].viewController.config = self.config;
    
    [XYAlert shareManager].XyWindow.rootViewController = [XYAlert shareManager].viewController;
    
    [XYAlert shareManager].XyWindow.windowLevel = self.config.modelWindowLevel;
    
    [XYAlert shareManager].XyWindow.hidden = NO;
    
    [[XYAlert shareManager].XyWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [XYAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
    [XYAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([XYAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [XYAlert shareManager].XyWindow.hidden = YES;
            
            [[XYAlert shareManager].XyWindow resignKeyWindow];
            
            [XYAlert shareManager].XyWindow.rootViewController = nil;
            
            [XYAlert shareManager].viewController = nil;
            
            [[XYAlert shareManager].queueArray removeObject:strongSelf];
            
            if (strongSelf.config.modelIsContinueQueueDisplay) [XYAlert continueQueueDisplay];
            
        } else {
            
            [[XYAlert shareManager].queueArray removeObject:strongSelf];
        }
        
        if (strongSelf.config.modelCloseComplete) strongSelf.config.modelCloseComplete();
    };
    
}

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([XYAlert shareManager].viewController) [[XYAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (XYAlertConfigModel *)config{
    
    if (!_config) _config = [[XYAlertConfigModel alloc] init];
    
    return _config;
}

@end
