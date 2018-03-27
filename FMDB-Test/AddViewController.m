//
//  AddViewController.m
//  FMDB-Test
//
//  Created by YeYiFeng on 2018/3/27.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "AddViewController.h"
#import "FMDB.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;


@property(nonatomic,strong)FMDatabase *db;

@property(strong,nonatomic)NSString * dbPath;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"增加数据";
    // Do any additional setup after loading the view.
}
- (IBAction)savebtn:(id)sender {
    
    if (![_nameText.text  isEqual: @""] && ![_ageText.text  isEqual: @""]) {
        [self saveData];
    }
}


#pragma mark - 数据库操作 - 创建表格
- (void)saveData {
    
    //获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
    self.dbPath = fileName;
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userData (id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL, userAge text NOT NULL);"];
        if (result){
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
        }
    }
    self.db=db;
    
    [self insert];
}

#pragma mark - 数据库操作 - 插入一条数据
//插入数据
-(void)insert{
    BOOL res = [self.db executeUpdate:@"INSERT INTO t_userData (userName, userAge) VALUES (?, ?);", _nameText.text, _ageText.text];
    
    if (!res) {
        NSLog(@"增加数据失败");
    }else{
        NSLog(@"增加数据成功");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"新增数据成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.5];
        
    }
}

- (void)dismiss:(UIAlertController *)alert{
    
    [alert dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
