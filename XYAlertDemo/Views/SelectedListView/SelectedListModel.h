//
//  SelectedListModel.h
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedListModel : NSObject

@property (nonatomic , assign ) NSInteger sid;

@property (nonatomic , copy ) NSString *title;

@property (nonatomic , strong ) id context;

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title;

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title
                    Context:(id)context;

@end
