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
    
    Book *book = [Book j_modelWithJSON:@"{\"id\": 111,\"name\": \"书\", \"pages\": 199, \"author\": {\"name\": \"小王\", \"birthday\": \"1987-09-31\" }}"];
    NSLog(@"%@",book);
    
}


@end
