# JModel
Implementing Dictionary to Model Conversion using Runtime in iOS

# 核心特性
* 支持字典或JSON字符串转模型
* 支持嵌套模型和数组解析

# 快速使用

```
    Book *book = [Book j_modelWithJSON:@"{\"id\": 99,\"name\": \"书\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1987-09-31\" }}"];
    NSLog(@"%@",book);
```
输出：
`2025-09-16 22:57:18.101696+0800 JModelDemo[670:77199] Book,id:99,name:书,pages:199,作者名:小王,作者生日:1987-09-31`
`数组`
```
    NSArray *arr = [Book j_modelsWithJSON:@"[{\"id\": 99,\"name\": \"书1\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1987-09-31\" }},{\"id\": 100,\"name\": \"书2\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1988-09-31\" }},{\"id\": 101,\"name\": \"书3\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1989-09-31\" }}]"];
    NSLog(@"%@",arr);
```
输出:
`2025-09-16 22:58:46.030385+0800 JModelDemo[673:77897] (
    "Book,id:99,name:\U4e661,pages:199,\U4f5c\U8005\U540d:\U5c0f\U738b,\U4f5c\U8005\U751f\U65e5:1987-09-31",
    "Book,id:100,name:\U4e662,pages:199,\U4f5c\U8005\U540d:\U5c0f\U738b,\U4f5c\U8005\U751f\U65e5:1988-09-31",
    "Book,id:101,name:\U4e663,pages:199,\U4f5c\U8005\U540d:\U5c0f\U738b,\U4f5c\U8005\U751f\U65e5:1989-09-31"
)
`
# License
本项目基于MIT协议开源。
