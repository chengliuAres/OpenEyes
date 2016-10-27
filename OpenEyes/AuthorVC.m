//
//  AuthorVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "AuthorVC.h"
#import "AuthorCell.h"
#import "AuthorModel.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "AuthorDetailVC.h"
@interface AuthorVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,strong) NSDictionary * dict;
@property (nonatomic,copy) NSString * nextPageurl;

@end

@implementation AuthorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNav];
    [self addTable];
    [self netData];
}
-(void)addNav{
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text =@"OpenEyes";
    label.font =[UIFont fontWithName:@"Lobster 1.4" size:24];
    label.textColor =[UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
}
-(void)addTable{
    self.tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    MJRefreshNormalHeader * header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self netData];
    }];
    MJRefreshAutoNormalFooter * footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self haveMoreData];
    }];
    _tableView.mj_header = header;
    _tableView.mj_footer = footer;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthorCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[AuthorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    AuthorModel * model =_modelArr[indexPath.row];
    NSString * authorStr =model.authorLabel;
    NSString * videoStr =model.videoCount;
    NSString * s = [NSString stringWithFormat:@"%@   [%@]",authorStr,videoStr];
    NSMutableAttributedString * str =[[NSMutableAttributedString alloc] initWithString:s attributes:nil];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:200] range:[s rangeOfString:authorStr]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:[s rangeOfString:videoStr]];
    cell.authorLabel.attributedText = str;
    cell.desLabel.text = model.desLabel;
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.iconImage]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AuthorDetailVC * detailVC = [[AuthorDetailVC alloc] init];
    AuthorModel * model =_modelArr[indexPath.row];
    detailVC.authorId = model.authorId;
    detailVC.authorIcon = model.iconImage;
    detailVC.authorDesc = model.desLabel;
    detailVC.authorName = model.authorLabel;
    detailVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)netData{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.modelArr =[NSMutableArray array];
    NSString * author =@"http://baobab.wandoujia.com/api/v3/tabs/pgcs/more?start=0&num=10";
    [NetWork requestDataByUrl:author Parameters:nil success:^(id responseObj) {
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        NSArray * itemList =[dic objectForKey:@"itemList"];
        self.nextPageurl =[NSString stringWithFormat:@"%@",dic[@"nextPageUrl"]];
        for (NSDictionary * dict in itemList) {
            NSDictionary *dataDict = dict[@"data"];
            
            AuthorModel *model = [[AuthorModel alloc]init];
            model.iconImage = [NSString stringWithFormat:@"%@",dataDict[@"icon"]];
            model.authorLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
            model.videoCount = [NSString stringWithFormat:@"%@",dataDict[@"subTitle"]];
            model.desLabel = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
            model.authorId = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
            model.actionUrl = [NSString stringWithFormat:@"%@",dataDict[@"actionUrl"]];
            [_modelArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    } failBlock:^(id responseObj) {
        NSLog(@"下载数据出错：%@",responseObj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
}
-(void)haveMoreData{
    if ([self.nextPageurl isEqualToString:@"<null>"]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [NetWork requestDataByUrl:self.nextPageurl Parameters:nil success:^(id responseObj) {
            NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
            self.nextPageurl = responseDic[@"nextPageUrl"];
            NSArray * itemList = [responseDic objectForKey:@"itemList"];
            for (NSDictionary *dict in itemList) {
                NSDictionary *dataDict = dict[@"data"];
                
                AuthorModel *model = [[AuthorModel alloc]init];
                model.iconImage = [NSString stringWithFormat:@"%@",dataDict[@"icon"]];
                model.authorLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
                model.videoCount = [NSString stringWithFormat:@"%@",dataDict[@"subTitle"]];
                model.desLabel = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
                model.authorId = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
                model.actionUrl = [NSString stringWithFormat:@"%@",dataDict[@"actionUrl"]];
                [_modelArr addObject:model];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
        } failBlock:^(id responseObj) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
        }];
    }
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
