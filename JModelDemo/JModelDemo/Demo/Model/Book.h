//
//  Book.h
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import <Foundation/Foundation.h>

#import "Author.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic,assign) NSInteger bookId;//id
@property (nonatomic,copy) NSString *name;//书名
@property (nonatomic,assign) int pages;//页数
@property (nonatomic,strong) Author *author;//作者

@end

NS_ASSUME_NONNULL_END
