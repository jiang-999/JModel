//
//  ViewController.m
//  JModelDemo
//
//  Created by jiang on 2025/9/16.
//

#import "ViewController.h"

//模型
#import "Book.h"

#import "NSObject+JModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    Book *book = [Book j_modelWithJSON:@"{\"id\": 99,\"name\": \"书\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1987-09-31\" }}"];
//    NSLog(@"%@",book);
    
    NSArray *arr = [Book j_modelsWithJSON:@"[{\"id\": 99,\"name\": \"书1\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1987-09-31\" }},{\"id\": 100,\"name\": \"书2\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1988-09-31\" }},{\"id\": 101,\"name\": \"书3\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1989-09-31\" }}]"];
    NSLog(@"%@",arr);
    
}


@end
