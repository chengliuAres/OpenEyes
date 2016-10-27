//
//  NiceChoiceVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/24.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "NiceChoiceVC.h"
#import "MJRefresh.h"
#import "DefineHelper.h"
#import "NiceChoiceCell.h"
#import "SVProgressHUD.h"
#import "AFNetWorking.h"
#import "NetWork.h"
#import "VideoListModel.h"
#import "UIImageView+WebCache.h"
#import "ViideoPlayerVC.h"
@interface NiceChoiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray  * listArr;
@property (nonatomic,copy) NSString * nextPageStr;
@end

@implementation NiceChoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _listArr = [NSMutableArray array];
    [self addNav];
    [self addTable];
    [self netData];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(void)addNav{
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text =@"精选";
    label.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:24]; //FZLTXIHJW--GB1-0 FZLTZCHJW--GB1-0
    label.textColor =[UIColor blackColor];
    label.textAlignment =NSTextAlignmentCenter;
    self.navigationItem.titleView =label;
}
-(void)addTable{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = ScreenHeight/3;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    MJRefreshHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self netData];
    }];
    _tableView.mj_header = header;
    MJRefreshFooter * footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self haveMoreNewData];
    }];
    _tableView.mj_footer =footer;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NiceChoiceCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[NiceChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    VideoListModel * model =_listArr[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.ImageView]];
    cell.titleLabel.text = model.titleLabel;
    cell.messageLabel.text =[NSString stringWithFormat:@"%@%@%@",model.category,@" / ",[self timeStrFromTime:model.duration]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViideoPlayerVC * player =[[ViideoPlayerVC alloc] init];
    VideoListModel * model =_listArr[indexPath.row];
    player.urlStr =model.playUrl;
    player.titleStr = model.titleLabel;
    player.duration = [model.duration floatValue];
    //[self showDetailViewController:player sender:nil];
    [self presentViewController:player animated:YES completion:nil];
}
#pragma mark 事件处理
-(void)netData{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    NSString * time =[self changeTIme:[self getdate]];
    NSString * str =[NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/feed.bak?num=%d&date=%@",10,time];
    [NetWork requestDataByUrl:str Parameters:nil success:^(id responseObj) {
        NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        self.nextPageStr = [NSString stringWithFormat:@"%@",response[@"nextPageUrl"]];
        NSDictionary * dailyListdic =[response objectForKey:@"dailyList"];
        for (NSDictionary * videoList in dailyListdic) {
            NSArray * temp =[videoList objectForKey:@"videoList"];
            for (NSDictionary * dict in temp) {
                VideoListModel * model =[[VideoListModel alloc] init];
                model.ImageView = [NSString stringWithFormat:@"%@",dict[@"coverForDetail"]];
                model.titleLabel = [NSString stringWithFormat:@"%@",dict[@"title"]];
                model.category = [NSString stringWithFormat:@"%@",dict[@"category"]];
                model.duration = [NSString stringWithFormat:@"%@",dict[@"duration"]];
                model.desc = [NSString stringWithFormat:@"%@",dict[@"description"]];
                model.playUrl = [NSString stringWithFormat:@"%@",dict[@"playUrl"]];
                NSDictionary * cnsump =dict[@"consumption"];
                model.consumption = cnsump;
                [_listArr addObject:model];
            }
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failBlock:^(id responseObj) {
        NSLog(@"发生错误：%@",responseObj);
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)haveMoreNewData{
    if ([self.nextPageStr isEqualToString:@"<null>"]) {
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        label.text =@"已经到底了";
        label.font =[UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = label;
        [self.tableView.mj_footer endRefreshing];
    }else{
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"数据加载中...."];
        [NetWork requestDataByUrl:self.nextPageStr Parameters:nil success:^(id responseObj) {
            NSDictionary * responseObject =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
            NSLog(@"更多数据：%@",responseObject);
            self.nextPageStr = [responseObject objectForKey:@"nextPageUrl"];
            
            NSDictionary *dailyListDict = [responseObject objectForKey:@"dailyList"];
            for (NSDictionary *videoList in dailyListDict) {
                NSArray *temp = [videoList objectForKey:@"videoList"];
                
                for (NSDictionary *dict in temp) {
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
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        } failBlock:^(id responseObj) {
            NSLog(@"数据加载错误：%@",responseObj);
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark 本地调用
-(NSTimeInterval)getdate{
    NSDate * date =[NSDate date];
    NSTimeInterval a =[date timeIntervalSince1970]*1000;
    return a;
}
-(NSString *)changeTIme:(NSTimeInterval)time{
    //获取当天时间
    time = time - 86400000 *5;
    NSDate * date =[NSDate dateWithTimeIntervalSinceNow:time/1000.0];
    NSDateFormatter * former =[[NSDateFormatter alloc] init];
    [former setDateFormat:@"yyyyMMdd"];
    NSString * str =[former stringFromDate:date];
    return str;
}
-(NSString *)timeStrFromTime:(NSString *)timeStr{
    int time =[timeStr intValue];
    int minutes =time/60;
    int second =(int)time%60;
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
