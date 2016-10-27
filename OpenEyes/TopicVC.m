//
//  TopicVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/26.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "TopicVC.h"
#import "DefineHelper.h"
#import "NiceChoiceCell.h"
#import "VideoListModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "TopicNextVC.h"
@interface TopicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * listArr;
@property (nonatomic,copy) NSString *NextPageStr;
@end

@implementation TopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNav];
    [self NetData];
}
-(void)addNav{
    self.navigationItem.title =@"热门专题";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = ScreenHeight/3;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    MJRefreshNormalHeader *header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self NetData];
    }];
    
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer  =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
    }];
    
    self.tableView.mj_footer = footer;
}
-(void)NetData{
    if (_listArr) {
        [_listArr removeAllObjects];
    }else{
        _listArr =[NSMutableArray array];
    }
    NSString *urlStr = @"http://baobab.wandoujia.com/api/v3/specialTopics?_s=44e4ee05b1f5d1efd3e30735e81230b2";
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [NetWork requestDataByUrl:urlStr Parameters:nil success:^(id responseObj) {
        NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        self.NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
        
        NSDictionary *itemListDict = [responseObject objectForKey:@"itemList"];
        
        for (NSDictionary *dict in itemListDict) {
            
            NSDictionary *dataDict = dict[@"data"];
            
            VideoListModel *model = [[VideoListModel alloc]init];
            model.ImageView = [NSString stringWithFormat:@"%@",dataDict[@"image"]];
            model.titleLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
            model.category = [NSString stringWithFormat:@"%@",dataDict[@"dataType"]];
            model.desc = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
            model.actionUrl = [NSString stringWithFormat:@"%@",dataDict[@"actionUrl"]];
            model.idStr = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
            [_listArr addObject:model];
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failBlock:^(id responseObj) {
        [SVProgressHUD dismiss];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];

}
-(void)loadMore{
    if ([self.NextPageStr isEqualToString:@"<null>"]) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }else{
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        [NetWork requestDataByUrl:_NextPageStr Parameters:nil success:^(id responseObj) {
            NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
            self.NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
            
            NSDictionary *itemListDict = [responseObject objectForKey:@"itemList"];
            
            for (NSDictionary *dict in itemListDict) {
                
                NSDictionary *dataDict = dict[@"data"];
                
                VideoListModel *model = [[VideoListModel alloc]init];
                model.ImageView = [NSString stringWithFormat:@"%@",dataDict[@"image"]];
                model.titleLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
                model.category = [NSString stringWithFormat:@"%@",dataDict[@"dataType"]];
                model.desc = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
                model.actionUrl = [NSString stringWithFormat:@"%@",dataDict[@"actionUrl"]];
                model.idStr = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
                NSDictionary *Dic = dataDict[@"consumption"];
                model.consumption = Dic;
                
                [_listArr addObject:model];
            }
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];

        } failBlock:^(id responseObj) {
            [SVProgressHUD dismiss];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }];
    }

}
#pragma mark -- TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight/3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *IDStr = @"cell";
    NiceChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:IDStr];
    if (!cell) {
        cell = [[NiceChoiceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDStr];
    }
    
    VideoListModel *model = _listArr[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.ImageView]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicNextVC * next =[[TopicNextVC alloc] init];
    next.model = _listArr[indexPath.row];
    [self.navigationController pushViewController:next animated:YES];
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
