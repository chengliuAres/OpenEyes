//
//  AuthorDetailVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "AuthorDetailVC.h"
#import "DefineHelper.h"
#import "VideoListModel.h"
#import "ViideoPlayerVC.h"
#import "NiceChoiceCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "NetWork.h"
#import "MJRefresh.h"
#import "UINavigationBar+bgColor.h"
@interface AuthorDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,copy) NSString * NextPageStr;

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,copy) NSString * requestUrl;
@property (nonatomic,strong) UIView * nav;
@property (nonatomic,weak) UIImageView * userPhoto;
@end

@implementation AuthorDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNav];
    [self addTable];
    _requestUrl =[NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v3/pgc/videos?_s=4667dd0eacb22bce6099c0d2c1dd5886&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&pgcId=",_authorId,@"&start=0&strategy=date&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"];
    [self netData];
}
-(void)addNav{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)addTable{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;;
        _tableView.dataSource =self;
        _tableView.delegate =self;
        _tableView.rowHeight = ScreenHeight/3;
        _tableView.tableFooterView =[UIView new];
        [self.view addSubview:_tableView];
        MJRefreshNormalHeader * h =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netData];
        }];
        MJRefreshAutoNormalFooter * f =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self haveMore];
        }];
        _tableView.mj_header = h;
        _tableView.mj_footer = f;
    }
    [_tableView setTableHeaderView:[self headerView]];
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
        _headerView.backgroundColor =[UIColor whiteColor];
        UIImageView * imagView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-40, 30, 80, 80)];
        imagView.layer.cornerRadius =40;
        imagView.layer.masksToBounds =YES;
        [_headerView addSubview:imagView];
        _userPhoto = imagView;
        [imagView sd_setImageWithURL:[NSURL URLWithString:_authorIcon]];
        
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imagView.frame)+5, ScreenWidth, 30)];
        label.textAlignment =NSTextAlignmentCenter;
        label.font =[UIFont systemFontOfSize:17];
        [_headerView addSubview:label];
        label.text = _authorName;
        
        UILabel * content =[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), ScreenWidth, 200-CGRectGetMaxY(label.frame))];
        content.numberOfLines =0;
        content.textAlignment = NSTextAlignmentCenter;
        content.font =[UIFont systemFontOfSize:14];
        [_headerView addSubview:content];
        content.text = _authorDesc;
    }
    return _headerView;
}
#pragma mark 数据加载
-(void)netData{
    if (_modelArr) {
        [_modelArr removeAllObjects];
    }else{
        self.modelArr =[[NSMutableArray alloc] init];
    }
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [NetWork requestDataByUrl:_requestUrl Parameters:nil success:^(id responseObj) {
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        self.NextPageStr =[NSString stringWithFormat:@"%@",responseDic[@"nextPageUrl"]];
        NSDictionary *itemListDict = [responseDic objectForKey:@"itemList"];
        
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
            
            [_modelArr addObject:model];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failBlock:^(id responseObj) {
        NSLog(@"数据加载报错...%@",responseObj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)haveMore{
        if ([self.NextPageStr isEqualToString:@"<null>"]) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            //正方形的背景样式(或颜色),黑色背景,白色圆环和文字
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showWithStatus:@"数据加载中..."];
            [NetWork requestDataByUrl:_NextPageStr Parameters:nil success:^(id responseObj) {
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
                    
                    [_modelArr addObject:model];
                }
                
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            } failBlock:^(id responseObj) {
                NSLog(@"数据加载报错...%@",responseObj);
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }];
        }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
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
    VideoListModel * model = _modelArr[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.ImageView]];
    cell.titleLabel.text = model.titleLabel;
    cell.messageLabel.text = [NSString stringWithFormat:@"#%@%@%@",model.category,@" / ",[self timeStrFormTime:model.duration]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViideoPlayerVC * player =[[ViideoPlayerVC alloc] init];
    VideoListModel * model =_modelArr[indexPath.row];
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

-(void)showIndex:(UIButton *)btn{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (btn.tag == 1001) {
        UIButton * btn2 =[self.tableView viewWithTag:1002];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _requestUrl =  [NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v3/pgc/videos?_s=4667dd0eacb22bce6099c0d2c1dd5886&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&pgcId=",self.authorId,@"&start=0&strategy=date&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"];
    }else{
        UIButton * btn2 =[self.tableView viewWithTag:1001];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _requestUrl = [NSString stringWithFormat:@"%@%@%@",@"http://baobab.wandoujia.com/api/v3/pgc/videos?_s=fb319be3889af5cbd86dcf3b048e9e8b&f=iphone&net=wifi&num=20&p_product=EYEPETIZER_IOS&pgcId=",self.authorId,@"&start=0&strategy=shareCount&u=8141e05d14a4cabf8464f21683ad382c9df8d55e&v=2.7.0&vc=1305"];
    }
    [self netData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    if (y>80) {
        [self.navigationItem setTitle:_authorName];
    }else{
        [self.navigationItem setTitle:@""];
    }
    if (y<-64) {
        CGFloat ratio = (-y)/500.0+1;
        NSLog(@"ratio:%f",ratio);
        [UIView animateWithDuration:0.1 animations:^{
            _userPhoto.transform = CGAffineTransformMakeScale(ratio, ratio);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _userPhoto.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
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
