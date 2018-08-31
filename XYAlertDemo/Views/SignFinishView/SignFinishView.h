//
//  SignFinishView.h
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignFinishView : UIView

/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);

@end
