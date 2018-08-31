//
//  SelectedListModel.m
//  XYAlertDemo
//
//  Created by xiayingying on 2018/8/28.
//  Copyright © 2018年 ejl. All rights reserved.
//

#import "SelectedListModel.h"

@implementation SelectedListModel

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title{
    
    return [[SelectedListModel alloc] initWithSid:sid Title:title Context:nil];
}

- (instancetype)initWithSid:(NSInteger)sid
                      Title:(NSString *)title
                    Context:(id)context{
    
    self = [super init];
    
    if (self) {
        
        _sid = sid;
        
        _title = title;
        
        _context = context;
    }
    
    return self;
}

@end
