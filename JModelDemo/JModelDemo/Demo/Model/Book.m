//
//  Book.m
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import "Book.h"

@implementation Book

+(NSDictionary *)propertyKeyMapping{
    return @{@"bookId":@"id"};
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@,id:%ld,name:%@,pages:%d,作者名:%@,作者生日:%@",NSStringFromClass([self class]),(long)self.bookId,self.name,self.pages,self.author.name,self.author.birthday];
}

@end
