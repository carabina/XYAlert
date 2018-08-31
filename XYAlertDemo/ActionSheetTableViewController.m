//
//  ActionSheetTableViewController.m
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "ActionSheetTableViewController.h"

#import "XYAlert.h"

#import "ShareView.h"

#import "AllShareView.h"

#import "FontSizeView.h"

#import "SelectedListView.h"

@interface ActionSheetTableViewController ()

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation ActionSheetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ActionSheet";
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.dataArray = [NSMutableArray array];
    
    NSMutableArray *baseArray = [NSMutableArray array];
    
    NSMutableArray *demoArray = [NSMutableArray array];
    
    [self.dataArray addObject:baseArray];
    
    [self.dataArray addObject:demoArray];
    
    
    [baseArray addObject:@{@"title" : @"显示一个默认的 actionSheet 菜单" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"显示一个带取消按钮的 actionSheet 菜单" , @"content" : @""}];
    
    [baseArray addObject:@{@"title" : @"显示一个不同控件顺序的 actionSheet 菜单" , @"content" : @"设置的顺序决定了控件显示的顺序."}];
    
    [baseArray addObject:@{@"title" : @"显示一个带自定义视图的 actionSheet 菜单" , @"content" : @"自定义视图的size发生改变时 会自动适应其改变."}];
    
    [baseArray addObject:@{@"title" : @"显示一个横竖屏不同宽度的 actionSheet 菜单" , @"content" : @"最大高度与最大宽度设置方法一样"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义标题和内容的 actionSheet 菜单" , @"content" : @"除了标题和内容 其他控件均支持自定义."}];
    
    [baseArray addObject:@{@"title" : @"显示一个多种action的 actionSheet 菜单" , @"content" : @"action分为三种类型 可添加多个 设置的顺序决定了显示的顺序."}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义action的 actionSheet 菜单" , @"content" : @"action的自定义属性可查看\"LEEAction\"类."}];
    
    [baseArray addObject:@{@"title" : @"显示一个可动态改变action的 actionSheet 菜单" , @"content" : @"已经显示后 可再次对action进行调整"}];
    
    [baseArray addObject:@{@"title" : @"显示一个可动态改变标题和内容的 actionSheet 菜单" , @"content" : @"已经显示后 可再次对其进行调整"}];
    
    [baseArray addObject:@{@"title" : @"显示一个模糊背景样式的 actionSheet 菜单" , @"content" : @"传入UIBlurEffectStyle枚举类型 默认为Dark"}];
    
    [baseArray addObject:@{@"title" : @"显示多个加入队列和优先级的 actionSheet 菜单" , @"content" : @"当多个同时需要显示时, 队列和优先级决定了如何去显示"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义动画配置的 actionSheet 菜单" , @"content" : @"可自定义打开与关闭的动画配置(UIView 动画)"}];
    
    [baseArray addObject:@{@"title" : @"显示一个自定义动画样式的 actionSheet 菜单" , @"content" : @"动画样式可设置动画方向, 淡入淡出, 缩放等"}];
    
    [demoArray addObject:@{@"title" : @"显示一个蓝色自定义风格的 actionSheet 菜单" , @"content" : @"菜单背景等颜色均可以自定义"}];
    
    [demoArray addObject:@{@"title" : @"显示一个类似微信布局的 actionSheet 菜单" , @"content" : @"只需要调整最大宽度,取消action的间隔颜色和底部间距即可"}];
    
    [demoArray addObject:@{@"title" : @"显示一个分享登录的 actionSheet 菜单" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个设置字体大小等级的 actionSheet 菜单" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个单选举报的 actionSheet 菜单" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个多选举报的 actionSheet 菜单" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
    
    [demoArray addObject:@{@"title" : @"显示一个带有更多功能的分享 actionSheet 菜单" , @"content" : @"类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"}];
}

#pragma mark - 自定义视图点击事件 (随机调整size)

- (void)viewTapAction:(UITapGestureRecognizer *)tap{
    
    CGFloat randomWidth = arc4random() % 240 + 10;
    
    CGFloat randomHeight = arc4random() % 400 + 10;
    
    CGRect viewFrame = tap.view.frame;
    
    viewFrame.size.width = randomWidth;
    
    viewFrame.size.height = randomHeight;
    
    tap.view.frame = viewFrame;
}

#pragma mark - 基础

- (void)base:(NSInteger)index{
    
    switch (index) {
            
        case 0:
        {
            [XYAlert actionsheet].config
            .XyTitle(@"标题")
            .XyContent(@"内容")
            .XyAction(@"好的", ^{
                
                // 点击事件Block
            })
            .XyShow();
        }
            break;
            
        case 1:
        {
            [XYAlert actionsheet].config
            .XyTitle(@"标题")
            .XyContent(@"内容")
            .XyAction(@"确认", ^{
                
                // 点击事件Block
            })
            .XyCancelAction(@"取消", ^{
                
                // 点击事件Block
            })
            .XyShow();
        }
            break;
            
        case 2:
        {
            [XYAlert actionsheet].config
            .XyContent(@"内容")
            .XyTitle(@"标题")
            .XyAction(@"确认", ^{
                
                // 点击事件Block
            })
            .XyCancelAction(@"取消", ^{
                
                // 点击事件Block
            })
            .XyShow();
        }
            break;
            
        case 3:
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 200, 100)];
            
            view.backgroundColor = [UIColor colorWithRed:43/255.0f green:133/255.0f blue:208/255.0f alpha:1.0f];
            
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)]];
            
            [XYAlert actionsheet].config
            .XyTitle(@"标题")
            .XyContent(@"内容")
//            .LeeCustomView(view)
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = view;
                
//                custom.isAutoWidth = YES; // 设置自动宽度后 会根据insets和最大的宽度自动计算自定义视图的宽度 并修改其frame属性
            })
            .XyAction(@"确认", ^{
                
            })
            .XyCancelAction(@"取消", ^{
                
            })
            .XyShow();
        }
            break;
            
        case 4:
        {
            [XYAlert actionsheet].config
            .XyContent(@"内容")
            .XyTitle(@"标题")
            .XyAction(@"确认", nil)
            .XyCancelAction(@"取消", nil)
            .XyConfigMaxWidth(^CGFloat (XYScreenOrientationType type) { // LeeConfigMaxWidth可以单独对横屏竖屏情况进行设置
                
                switch (type) {
                        
                    case XYScreenOrientationTypeHorizontal:
                        
                        // 横屏时最大宽度
                        
                        return CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.7f;
                        
                        break;
                        
                    case XYScreenOrientationTypeVertical:
                        
                        // 竖屏时最大宽度
                        
                        return CGRectGetWidth([[UIScreen mainScreen] bounds]) * 0.9f;
                        
                        break;
                        
                    default:
                        return 0.0f;
                        break;
                }
            })
            .XyShow();
        }
            break;
            
        case 5:
        {
            [XYAlert actionsheet].config
            .XyAddTitle(^(UILabel *label) {
                
                label.text = @"已经退出该群组";
                
                label.textColor = [UIColor darkGrayColor];
                
                label.textAlignment = NSTextAlignmentLeft;
            })
            .XyAddContent(^(UILabel *label) {
                
                label.text = @"以后将不会再收到该群组的任何消息";
                
                label.textColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
                
                label.textAlignment = NSTextAlignmentLeft;
            })
            .XyAction(@"好的", nil)
            .XyShow();
        }
            break;
            
        case 6:
        {
            [XYAlert actionsheet].config
            .XyTitle(@"这是一个actionSheet 它有三个不同类型的action!")
            .XyAction(@"一个默认action", ^{
                
                // 点击事件Block
            })
            .XyDestructiveAction(@"一个销毁action", ^{
                
                // 点击事件Block
            })
            .XyCancelAction(@"一个取消action", ^{
                
                // 点击事件Block
            })
            .XyShow();
        }
            break;
            
        case 7:
        {
            [XYAlert actionsheet].config
            .XyTitle(@"自定义 Action 的 actionSheet!")
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeDefault;
                
                action.title = @"自定义";
                
                action.titleColor = [UIColor brownColor];
                
                action.highlight = @"被点啦";
                
                action.highlightColor = [UIColor orangeColor];
                
                action.image = [UIImage imageNamed:@"smile"];
                
                action.highlightImage = [UIImage imageNamed:@"tongue"];
                
                action.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
                
                action.height = 60.0f;
                
                action.clickBlock = ^{
                    
                    // 点击事件Block
                };
                
            })
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeCancel;
                
                action.title = @"自定义";
                
                action.titleColor = [UIColor orangeColor];
                
                action.highlightColor = [UIColor brownColor];
                
                action.image = [UIImage imageNamed:@"smile"];
                
                action.highlightImage = [UIImage imageNamed:@"tongue"];
                
                action.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
                
                action.height = 60.0f;
                
                action.clickBlock = ^{
                    
                    // 点击事件Block
                };
                
            })
            .XyShow();
        }
            break;
            
        case 8:
        {
            __block XYAction *tempAction = nil;
            
            [XYAlert actionsheet].config
            .XyContent(@"点击改变 第一个action会长高哦")
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"我是action";
                
                tempAction = action;
            })
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"改变";
                
                action.isClickNotClose = YES; // 设置点击不关闭 (仅适用于默认类型的action)
                
                action.clickBlock = ^{
                    
                    tempAction.height += 40;
                    
                    tempAction.title = @"我长高了";
                    
                    tempAction.titleColor = [UIColor redColor];
                    
                    [tempAction update]; // 更改设置后 调用更新
                };
            })
            .XyCancelAction(@"取消", nil)
            .XyShow();
        }
            break;
            
        case 9:
        {
            __block UILabel *tempTitle = nil;
            __block UILabel *tempContent = nil;
            
            [XYAlert actionsheet].config
            .XyAddTitle(^(UILabel *label) {
                
                label.text = @"动态改变标题和内容的actionSheet";
                
                tempTitle = label;
            })
            .XyAddContent(^(UILabel *label) {
                
                label.text = @"点击调整 action 即可改变";
                
                tempContent = label;
            })
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"调整";
                
                action.isClickNotClose = YES; // 设置点击不关闭 (仅适用于默认类型的action)
                
                action.clickBlock = ^{
                    
                    tempTitle.text = @"一个改变后的标题 ...................................................................";
                    
                    tempTitle.textColor = [UIColor grayColor];
                    
                    tempTitle.textAlignment = NSTextAlignmentLeft;
                    
                    tempContent.text = @"一个改变后的内容";
                    
                    tempContent.textColor = [UIColor lightGrayColor];
                    
                    tempContent.textAlignment = NSTextAlignmentLeft;
                    
                    // 其他控件同理 ,
                };
                
            })
            .XyCancelAction(@"取消" , nil)
            .XyShow();
        }
            break;
            
        case 10:
        {
            [XYAlert actionsheet].config
            .XyTitle(@"这是一个毛玻璃背景样式的actionSheet")
            .XyContent(@"通过UIBlurEffectStyle枚举设置效果样式")
            .XyAction(@"确认", nil)
            .XyCancelAction(@"取消", nil)
            .XyBackgroundStyleBlur(UIBlurEffectStyleLight)
            .XyShow();
        }
            break;
            
        case 11:
        {
            // 队列: 加入队列后 在显示过程中 如果有一个更高优先级的alert要显示 那么当前的alert会暂时关闭 显示新的 待新的alert显示结束后 继续显示.
            // 优先级: 按照优先级从高到低的顺序显示, 优先级相同时 优先显示最新的.
            // 队列和优先级: 当两者结合时 两者的特性会相互融合
            
            // 下面代码可自行调试理解
            
            [XYAlert actionsheet].config
            .XyTitle(@"actionSheet 1")
            .XyCancelAction(@"取消", nil)
            .XyAction(@"确认", nil)
            .XyQueue(YES)
            .XyPriority(2)
            .XyShow();
            
            
            [XYAlert actionsheet].config
            .XyTitle(@"actionSheet 2")
            .XyCancelAction(@"取消", nil)
            .XyAction(@"确认", nil)
            .XyQueue(YES)
            .XyPriority(1)
            .XyShow();
        }
            break;
            
        case 12:
        {   
            [XYAlert actionsheet].config
            .XyTitle(@"自定义动画配置的 Actionsheet")
            .XyContent(@"支持 自定义打开动画配置和关闭动画配置 基于 UIView 动画API")
            .XyAction(@"好的", ^{
                
                // 点击事件Block
            })
            .XyOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
                [UIView animateWithDuration:1.5f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    animatingBlock(); //调用动画中Block
                    
                } completion:^(BOOL finished) {
                    
                    animatedBlock(); //调用动画结束Block
                }];
                
            })
            .XyCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
                [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    animatingBlock();
                    
                } completion:^(BOOL finished) {
                    
                    animatedBlock();
                }];
                
            })
            .XyShow();
        }
            break;
            
        case 13:
        {
            /*
             动画样式的方向只可以设置一个 其他样式枚举可随意增加.
             动画样式和动画配置可同时设置 这里不多做演示 欢迎自行探索
             */
            
            [XYAlert actionsheet].config
            .XyTitle(@"自定义动画样式的 Actionsheet")
            .XyContent(@"动画样式可设置动画方向, 淡入淡出, 缩放等")
            .XyAction(@"好的", ^{
                
                // 点击事件Block
            })
            //.LeeOpenAnimationStyle(LEEAnimationStyleOrientationTop | LEEAnimationStyleZoomShrink) //这里设置打开动画样式的方向为上 以及淡入效果.
            //.LeeCloseAnimationStyle(LEEAnimationStyleOrientationBottom | LEEAnimationStyleZoomShrink) //这里设置关闭动画样式的方向为下 以及淡出效果
            .XyOpenAnimationStyle(XYAnimationStyleOrientationLeft | XYAnimationStyleFade) //这里设置打开动画样式的方向为左 以及缩放效果.
            .XyCloseAnimationStyle(XYAnimationStyleOrientationRight | XYAnimationStyleFade) //这里设置关闭动画样式的方向为右 以及缩放效果
            .XyShow();
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - demo

- (void)demo:(NSInteger)index{
    
    switch (index) {
            
        case 0:
        {
            UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
            
            [XYAlert actionsheet].config
            .XyAddTitle(^(UILabel *label) {
                
                label.text = @"确认删除?";
                
                label.textColor = [UIColor whiteColor];
            })
            .XyAddContent(^(UILabel *label) {
                
                label.text = @"删除后将无法恢复, 请慎重考虑";
                
                label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
            })
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeCancel;
                
                action.title = @"取消";
                
                action.titleColor = blueColor;
                
                action.backgroundColor = [UIColor whiteColor];
                
                action.clickBlock = ^{
                    
                    // 取消点击事件Block
                };
            })
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeDefault;
                
                action.title = @"删除";
                
                action.titleColor = blueColor;
                
                action.backgroundColor = [UIColor whiteColor];
                
                action.clickBlock = ^{
                    
                    // 删除点击事件Block
                };
            })
            .XyHeaderColor(blueColor)
            .XyShow();
        }
            break;
            
        case 1:
        {
            [XYAlert actionsheet].config
            .XyContent(@"退出后不会通知群聊中其他成员, 且不会接收此群聊消息.出后不会通知群聊中其他成员, 且不会接收此群聊消息")
            .XyDestructiveAction(@"确定", ^{
                
                // 点击事件回调Block
            })
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeCancel;
                
                action.title = @"取消";
                
                action.titleColor = [UIColor blackColor];
                
                action.font = [UIFont systemFontOfSize:18.0f];
            })
            .XyActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
            .XyActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
            .XyCornerRadius(0.0f) // 设置圆角曲率为0
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .XyActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
            .XyShow();
        }
            break;
            
        case 2:
        {
            // 初始化分享视图
            
            CGFloat width = CGRectGetHeight([[UIScreen mainScreen] bounds]) > CGRectGetWidth([[UIScreen mainScreen] bounds]) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20 : CGRectGetHeight([[UIScreen mainScreen] bounds]) - 20;
            
            ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, width, 0) InfoArray:nil MaxLineNumber:2 MaxSingleCount:3];
            
            shareView.openShareBlock = ^(ShareType type){
                
                NSLog(@"%d" , type);
            };
            
            [XYAlert actionsheet].config
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = shareView;
                
                custom.positionType = XYCustomViewPositionTypeCenter;
            })
            .XyItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyAddAction(^(XYAction *action) {
                
                action.type = XYActionTypeDefault;
                
                action.title = @"取消";
                
                action.titleColor = [UIColor grayColor];
            })
            .XyShow();
        }
            break;
            
        case 3:
        {   
            FontSizeView *view = [[FontSizeView alloc] init];
            
            view.changeBlock = ^(NSInteger level){
              
                
            };
            
            [XYAlert actionsheet].config
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = view;
                
                custom.isAutoWidth = YES;
            })
            .XyItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"取消";
                
                action.titleColor = [UIColor grayColor];
                
                action.height = 45.0f;
            })
            .XyHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyActionSheetBottomMargin(0.0f)
            .XyCornerRadius(0.0f)
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                
                return type == XYScreenOrientationTypeHorizontal ? CGRectGetHeight([[UIScreen mainScreen] bounds]) : CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .XyShow();
        }
            break;
            
        case 4:
        {
            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) style:UITableViewStylePlain];
            
            view.isSingle = YES;
            
            view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"垃圾广告"] ,
                           [[SelectedListModel alloc] initWithSid:1 Title:@"淫秽色情"] ,
                           [[SelectedListModel alloc] initWithSid:2 Title:@"低俗辱骂"] ,
                           [[SelectedListModel alloc] initWithSid:3 Title:@"涉政涉密"] ,
                           [[SelectedListModel alloc] initWithSid:4 Title:@"欺诈谣言"] ];
            
            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                
                [XYAlert closeWithCompletionBlock:^{
                    
                    NSLog(@"选中的%@" , array);
                }];
                
            };
            
            [XYAlert actionsheet].config
            .XyTitle(@"举报内容问题")
            .XyItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = view;
                
                custom.isAutoWidth = YES;
            })
            .XyItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"取消";
                
                action.titleColor = [UIColor blackColor];
                
                action.backgroundColor = [UIColor whiteColor];
            })
            .XyHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
            .XyHeaderColor([UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f])
            .XyActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
            .XyCornerRadius(0.0f) // 设置圆角曲率为0
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .XyShow();
        }
            break;
            
        case 5:
        {
            __block XYAction *tempAction = nil;
            
            SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) style:UITableViewStylePlain];
            
            view.isSingle = NO;
            
            view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"垃圾广告"] ,
                           [[SelectedListModel alloc] initWithSid:1 Title:@"淫秽色情"] ,
                           [[SelectedListModel alloc] initWithSid:2 Title:@"低俗辱骂"] ,
                           [[SelectedListModel alloc] initWithSid:3 Title:@"涉政涉密"] ,
                           [[SelectedListModel alloc] initWithSid:4 Title:@"欺诈谣言"] ];
            
            view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
                
                NSLog(@"选中的%@" , array);
            };
            
            __block SelectedListView *blockView = view; //解决循环引用
            
            view.changedBlock = ^(NSArray<SelectedListModel *> *array) {
                
                // 当选择改变时 判断当前选中的数量 改变action的样式
                
                if (array.count) {
                    
                    tempAction.title = @"举报";
                    
                    tempAction.titleColor = [UIColor redColor];
                    
                    tempAction.clickBlock = ^{
                        
                        [blockView finish];
                        
                        blockView = nil;
                    };
                    
                } else {
                    
                    tempAction.title = @"取消";
                    
                    tempAction.titleColor = [UIColor lightGrayColor];
                    
                    tempAction.clickBlock = nil;
                }
                
                [tempAction update];
            };
            
            [XYAlert actionsheet].config
            .XyTitle(@"举报内容问题")
            .XyItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = view;
                
                custom.isAutoWidth = YES;
            })
            .XyItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyAddAction(^(XYAction *action) {
                
                tempAction = action;
                
                action.title = @"取消";
                
                action.titleColor = [UIColor lightGrayColor];
                
                action.backgroundColor = [UIColor whiteColor];
            })
            .XyHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
            .XyHeaderColor([UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f])
            .XyActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
            .XyCornerRadius(0.0f) // 设置圆角曲率为0
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .XyShow();
        }
            break;
            
        case 6:
        {
            AllShareView *view = [[AllShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) ShowMore:YES ShowReport:YES];
            
            view.openShareBlock = ^(ShareType type) {
              
                NSLog(@"%d" , type);
            };
            
            view.openMoreBlock = ^(MoreType type) {
                
                switch (type) {
                    
                    case MoreTypeToTheme:
                        
                        // 切换主题 (关于主题开源库 推荐一下: https://github.com/lixiang1994/LEETheme)
                        
                        break;
                        
                    case MoreTypeToReport:
                        
                        // 打开举报
                        [self demo:4];
                        
                        break;
                        
                    case MoreTypeToFontSize:
                        
                        // 打开字体设置
                        [self demo:3];
                        
                        break;
                        
                    case MoreTypeToCopyLink:
                        
                        // 复制链接
                        
                        break;
                        
                    default:
                        break;
                }
                
            };
            
            // 显示代码可以封装到自定义视图中 例如 [view show];
            
            [XYAlert actionsheet].config
            .XyAddCustomView(^(XYCustomView *custom) {
                
                custom.view = view;
                
                custom.isAutoWidth = YES;
            })
            .XyItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyAddAction(^(XYAction *action) {
                
                action.title = @"取消";
                
                action.titleColor = [UIColor grayColor];
                
                action.height = 45.0f;
            })
            .XyHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
            .XyActionSheetBottomMargin(0.0f)
            .XyCornerRadius(0.0f)
            .XyConfigMaxWidth(^CGFloat(XYScreenOrientationType type) {
                
                // 这是最大宽度为屏幕宽度 (横屏和竖屏)
                
                return CGRectGetWidth([[UIScreen mainScreen] bounds]);
            })
            .XyOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
                
                [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    animatingBlock(); //调用动画中Block
                    
                } completion:^(BOOL finished) {
                    
                    animatedBlock(); //调用动画结束Block
                }];
                
            })
            .XyShow();
        }
            break;
            
        case 7:
        {
            
        }
            break;
            
        case 8:
        {
            
        }
            break;
            
        case 9:
        {
            
        }
            break;
            
        case 10:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *info = self.dataArray[indexPath.section][indexPath.row];
    
    cell.textLabel.text = info[@"title"];
    
    cell.detailTextLabel.text = info[@"content"];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0:
            
            return @"基础";
            
            break;
            
        case 1:
            
            return @"Demo";
            
            break;
            
        default:
            
            return @"";
            
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
            
        case 0:
            
            [self base:indexPath.row];
            
            break;
            
        case 1:
            
            [self demo:indexPath.row];
            
            break;
            
        default:
            break;
    }
    
}

@end
