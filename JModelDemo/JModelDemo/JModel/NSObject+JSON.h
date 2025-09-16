//
//  NSDictionary+JSON.h
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JSON)


/// 转字典
/// - Parameter json: json数据
/// - return 字典
+(NSDictionary *)j_dictionaryWithJSON:(id)json;

@end

NS_ASSUME_NONNULL_END
