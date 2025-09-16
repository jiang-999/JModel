//
//  NSObject+JModel.h
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JModel)

/// 从字典初始化模型对象
/// - Parameter dictionary: 数据源字典
///  - return 模型对象
+(instancetype)j_modelWithDictionary:(NSDictionary *)dictionary;


/// 从json初始化模型对象
/// - Parameter json: json数据
///  - return 模型对象
+(instancetype)j_modelWithJSON:(id)json;

@end

NS_ASSUME_NONNULL_END
