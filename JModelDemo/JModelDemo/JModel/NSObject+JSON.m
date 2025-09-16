//
//  NSDictionary+JSON.m
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

/// 转字典
/// - Parameter json: json数据
/// - return 字典
+(NSDictionary *)j_dictionaryWithJSON:(id)json{
    if(!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if([json isKindOfClass:[NSDictionary class]]){
        dic = json;
    }else if ([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }
    if(jsonData){
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(![dic isKindOfClass:[NSDictionary class]]){
            dic = nil;
        }
    }
    return dic;
}

@end
