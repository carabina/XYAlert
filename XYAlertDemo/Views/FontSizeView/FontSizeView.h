//
//  FontSizeView.h
//  MierMilitaryNews
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontSizeView : UIView

@property (nonatomic , copy ) void (^changeBlock)(NSInteger);

@end
