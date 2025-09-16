//
//  NSObject+JModel.m
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import "NSObject+JModel.h"
#import "NSObject+JSON.h"

#import <objc/runtime.h>

@implementation NSObject (JModel)

/// 从字典初始化模型对象
/// - Parameter dictionary: 数据源字典
///  - return 模型对象
+(instancetype)j_modelWithDictionary:(NSDictionary *)dictionary{
    Class cls = [self class];
    NSObject *obj = [cls new];
    [obj setPropertiesWithDictionary:dictionary];
    return obj;
}

/// 从json初始化模型对象
/// - Parameter json: json数据
///  - return 模型对象
+(instancetype)j_modelWithJSON:(id)json{
    NSDictionary *dic = [self j_dictionaryWithJSON:json];
    if(dic){return [self j_modelWithDictionary:dic];}
    return nil;
}

/// 从json初始化模型对象数组
/// - Parameter json: json数据
///  - return 模型对象数组
+(NSArray *)j_modelsWithJSON:(id)json{
    if(!json || json == (id)kCFNull) return nil;
    NSArray *arr = nil;
    NSData *jsonData = nil;
    if([json isKindOfClass:[NSArray class]]){
        arr = json;
    }else if ([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }
    if(jsonData){
        arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(![arr isKindOfClass:[NSArray class]]){
            arr = nil;
        }
    }
    return [self j_modelsWithArray:arr];
}


/// 从数组初始化模型对象数组
/// - Parameter arr: 数组
/// - return 数组
+(NSArray *)j_modelsWithArray:(NSArray *)arr{
    if(![arr isKindOfClass:[NSArray class]]){return nil;}
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        if(![dic isKindOfClass:[NSDictionary class]]){continue;}
        id obj = [self j_modelWithJSON:dic];
        if(obj){[result addObject:obj];};
    }
    return [NSArray arrayWithArray:result];
}


/// 通过字典设置类属性
/// - Parameter dictionary: 字典
-(void)setPropertiesWithDictionary:(NSDictionary *)dictionary{
    //获取类所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        //获取属性
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        //根据映射关系获取字典中的key
        NSString *dictKey = [self dictionaryKeyForProperty:propertyName];
        //从字典中获取对应的值
        id value = dictionary[dictKey];
        if(!value || [value isKindOfClass:[NSNull class]]){
            continue;
        }
        //处理值的类型转换
        id convertValue = [self convertValue:value forProperty:propertyName];
        if(convertValue){
            [self setValue:convertValue forKey:propertyName];
        }
    }
    free(properties);
}


/// 通过属性名设置
/// - Parameters:
///   - value: value
///   - propertyName: 属性名
- (id)convertValue:(id)value forProperty:(NSString *)propertyName{
    //获取属性类型
    NSString *propertyType = [self propertyType:propertyName];
    if(!propertyType){
        return value;
    }
    
    Class cls = Nil;
    
    // 处理特殊类映射
    NSDictionary *specialClasses = [[self class] specialClassMapping];
    if(specialClasses[propertyName]){
        NSString *className = specialClasses[propertyName];
        cls = NSClassFromString(className);
    }
    else{
        const char *type = [propertyType UTF8String];
        //判断是否是对象,以@ 开头的通常是对象类型，要排除特殊对象类型，例如block是@?
        if((*type == '@' && (*(type+1) != '?' )) || (*(type+1) == '@' && (*(type+2) != '?' ))){
            NSScanner *scanner = [NSScanner scannerWithString:propertyType];
            NSString *clsName = nil;
//            BOOL isA = [scanner scanString:@"@\"" intoString:NULL];
            [scanner scanUpToString:@"@\"" intoString:NULL];
            if([scanner scanString:@"@\"" intoString:NULL]){
                if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
                    if (clsName.length) cls = objc_getClass(clsName.UTF8String);
                }
            }
        }
    }
    
    //如果cls不为空
    if(cls){
        if([value isKindOfClass:[NSArray class]]){
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *itemDictionary in value) {
                if([itemDictionary isKindOfClass:[NSDictionary class]] && [cls respondsToSelector:@selector(j_modelWithDictionary:)]){
                    id model = [cls j_modelWithDictionary:value];
                    [array addObject:model];
                }
            }
            return array;
        }
        else if ([value isKindOfClass:[NSDictionary class]] && [cls respondsToSelector:@selector(j_modelWithDictionary:)]){
            return [cls j_modelWithDictionary:value];
        }
    }
    
    if([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]){
        //处理BOOL类型
        if([propertyType rangeOfString:@"BOOL"].location != NSNotFound){
            return @([value boolValue]);
        }
        //处理NSInteger/int类型
        if([propertyType rangeOfString:@"NSInteger"].location != NSNotFound || [propertyType rangeOfString:@"int"].location != NSNotFound){
            return @([value integerValue]);
        }
        //处理longlong类型
        if([propertyType rangeOfString:@"long long"].location != NSNotFound){
            return @([value longLongValue]);
        }
    }
    return value;
}


/// 获取类型编码
/// - Parameter propertyName: 属性名
- (NSString *)propertyType:(NSString *)propertyName{
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if(!property) return nil;
    
    NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSArray *components = [attributes componentsSeparatedByString:@","];
    if(components.count > 0){
        return components[0];
    }
    return nil;
}

/**
 根据属性名获取字典中的key(处理映射关系)
 */
-(NSString *)dictionaryKeyForProperty:(NSString *)propertyName{
    NSDictionary *mapping = [[self class] propertyKeyMapping];
    if(mapping && mapping[propertyName]){
        return mapping[propertyName];
    }
    return propertyName;
}

#pragma mark - 子类重写
+(NSDictionary *)propertyKeyMapping{
    return nil;
}

+(NSDictionary *)specialClassMapping{
    return nil;
}


@end
