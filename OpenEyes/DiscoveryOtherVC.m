//
//  DiscoveryOtherVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/26.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "DiscoveryOtherVC.h"
#import "NiceChoiceCell.h"
#import "VideoListModel.h"
#import "UIImageView+WebCache.h"
#import "DefineHelper.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "ViideoPlayerVC.h"
@interface DiscoveryOtherVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * listArr;
@property (nonatomic,copy) NSString * NextPageStr;
@property (nonatomic,copy) NSString * requestUrl;
@property (nonatomic,copy) NSString * requireId;
@property (nonatomic,strong) UIView * nav;
@end

@implementation DiscoveryOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNav];
    [self addTable];
    self.requireId =@"1";
    NSArray * array =[self.actionUrl componentsSeparatedByString:@"title="];
    self.requestUrl =[NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v1/videos.bak?strategy=date&categoryName=",array.lastObject,@"&num=10"];
    [self NetData];
}
-(void)NetData{
    if (_listArr) {
        [_listArr removeAllObjects];
    }else{
        _listArr =[NSMutableArray array];
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [NetWork requestDataByUrl:_requestUrl Parameters:nil success:^(id responseObj) {
        NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        if ([_requireId isEqualToString:@"1"]) {
            _NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
            NSDictionary *videoListDict = [responseObject objectForKey:@"videoList"];
            for (NSDictionary *dict in videoListDict) {
                
                VideoListModel *model = [[VideoListModel alloc]init];
                model.ImageView = [NSString stringWithFormat:@"%@",dict[@"coverForDetail"]];
                model.titleLabel = [NSString stringWithFormat:@"%@",dict[@"title"]];
                model.category = [NSString stringWithFormat:@"%@",dict[@"category"]];
                model.duration = [NSString stringWithFormat:@"%@",dict[@"duration"]];
                model.desc = [NSString stringWithFormat:@"%@",dict[@"description"]];
                model.playUrl = [NSString stringWithFormat:@"%@",dict[@"playUrl"]];
                NSDictionary *Dic = dict[@"consumption"];
                model.consumption = Dic;
                
                [_listArr addObject:model];
            }
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];

        }else{
            
            self.NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
            
            NSDictionary *itemListDict = [responseObject objectForKey:@"itemList"];
            
            for (NSDictionary *dict in itemListDict) {
                
                NSDictionary *dataDict = dict[@"data"];
                
                VideoListModel *model = [[VideoListModel alloc]init];
                model.ImageView = [NSString stringWithFormat:@"%@",dataDict[@"cover"][@"detail"]];
                model.titleLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
                model.category = [NSString stringWithFormat:@"%@",dataDict[@"category"]];
                model.duration = [NSString stringWithFormat:@"%@",dataDict[@"duration"]];
                model.desc = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
                model.playUrl = [NSString stringWithFormat:@"%@",dataDict[@"playUrl"]];
                NSDictionary *Dic = dataDict[@"consumption"];
                model.consumption = Dic;
                [_listArr addObject:model];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } failBlock:^(id responseObj) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}
-(void)haveMore{
    if ([_NextPageStr isEqualToString:@"<null>"]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        if ([self.requireId isEqualToString:@"1"]) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"数据加载中..."];
            [NetWork requestDataByUrl:_NextPageStr Parameters:nil success:^(id responseObj) {
                NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
                self.NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
                
                NSDictionary *videoListDict = [responseObject objectForKey:@"videoList"];
                
                for (NSDictionary *dict in videoListDict) {
                    
                    VideoListModel *model = [[VideoListModel alloc]init];
                    model.ImageView = [NSString stringWithFormat:@"%@",dict[@"coverForDetail"]];
                    model.titleLabel = [NSString stringWithFormat:@"%@",dict[@"title"]];
                    model.category = [NSString stringWithFormat:@"%@",dict[@"category"]];
                    model.duration = [NSString stringWithFormat:@"%@",dict[@"duration"]];
                    model.desc = [NSString stringWithFormat:@"%@",dict[@"description"]];
                    model.playUrl = [NSString stringWithFormat:@"%@",dict[@"playUrl"]];
                    NSDictionary *Dic = dict[@"consumption"];
                    model.consumption = Dic;
                    
                    [_listArr addObject:model];
                }
                
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                

            } failBlock:^(id responseObj) {
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                [SVProgressHUD dismiss];
            }];
          
            
        }else{
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"数据加载中..."];
            [NetWork requestDataByUrl:self.NextPageStr Parameters:nil success:^(id responseObj) {
                 NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
                self.NextPageStr = [NSString stringWithFormat:@"%@",responseObject[@"nextPageUrl"]];
                
                NSDictionary *itemListDict = [responseObject objectForKey:@"itemList"];
                
                for (NSDictionary *dict in itemListDict) {
                    
                    NSDictionary *dataDict = dict[@"data"];
                    
                    VideoListModel *model = [[VideoListModel alloc]init];
                    model.ImageView = [NSString stringWithFormat:@"%@",dataDict[@"cover"][@"detail"]];
                    model.titleLabel = [NSString stringWithFormat:@"%@",dataDict[@"title"]];
                    model.category = [NSString stringWithFormat:@"%@",dataDict[@"category"]];
                    model.duration = [NSString stringWithFormat:@"%@",dataDict[@"duration"]];
                    model.desc = [NSString stringWithFormat:@"%@",dataDict[@"description"]];
                    model.playUrl = [NSString stringWithFormat:@"%@",dataDict[@"playUrl"]];
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
}
-(void)addNav{
    self.navigationItem.title = _pageTitle;
}
-(void)addTable{
    _tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain ];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = ScreenHeight/3;
    [self.view addSubview:_tableView];
    MJRefreshNormalHeader * header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self NetData];
    }];
    MJRefreshAutoNormalFooter * footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self haveMore];
    }];
    _tableView.mj_header = header;
    _tableView.mj_footer = footer;
}
-(void)showIndex:(UIButton *)btn{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (btn.tag == 1001) {
        UIButton * btn2 =[self.tableView viewWithTag:1002];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.requireId = @"1";
        NSArray *array = [self.actionUrl componentsSeparatedByString:@"title="];
        _requestUrl = [NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v1/videos.bak?strategy=date&categoryName=",array.lastObject,@"&num=10"];

    }else{
        UIButton * btn2 =[self.tableView viewWithTag:1001];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.requireId = @"2";
        self.requestUrl = [NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v3/videos?_s=84dcbd31e142fd912326d4f92f25606f&categoryId=",self.idStr,@"&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&start=0&strategy=shareCount&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"];
    }
    [self NetData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_nav) {
        UIView * nav =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        nav.backgroundColor =[UIColor redColor];
        UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, ScreenWidth/2, 40);
        btn1.tag =1001;
        [btn1 setTitle:@"按时间排序" forState: UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [nav addSubview:btn1];
        [btn1 addTarget:self action:@selector(showIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 40);
        btn2.tag =1002;
        [btn2 setTitle:@"分享排行榜" forState: UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [nav addSubview:btn2];
        [btn2 addTarget:self action:@selector(showIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nav =nav;
    }
    return _nav;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NiceChoiceCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[NiceChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    VideoListModel * model = _listArr[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.ImageView]];
    cell.titleLabel.text =model.titleLabel;
    cell.messageLabel.text =[NSString stringWithFormat:@"%@ / %@",model.category,[self timeStrFormTime:model.duration]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViideoPlayerVC *player =[[ViideoPlayerVC alloc] init];
    VideoListModel * model =_listArr[indexPath.row];
    player.urlStr =model.playUrl;
    player.titleStr = model.titleLabel;
    player.duration = [model.duration floatValue];
    //[self showDetailViewController:player sender:nil];
    [self presentViewController:player animated:YES completion:nil];
}
//转换时间格式
-(NSString *)timeStrFormTime:(NSString *)timeStr
{
    int time = [timeStr intValue];
    int minutes = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d'%02d\"",minutes,second];
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
