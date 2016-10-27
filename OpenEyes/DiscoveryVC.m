//
//  DiscoveryVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/26.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "DiscoveryVC.h"
#import "DefineHelper.h"
#import "DiscoveryCell.h"
#import "NetWork.h"
#import "DiscoveryModel.h"
#import "UIImageView+WebCache.h"
#import "TopVC.h"
#import "TopicVC.h"
#import "DiscoveryOtherVC.h"
@interface DiscoveryVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray * listArr;
@property (nonatomic,strong) UICollectionView * collectView;
@end

@implementation DiscoveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNav];
    [self addCollectView];
    [self NetData];
}
-(void)NetData{
    if (!_listArr) {
        _listArr =[NSMutableArray array];
    }else{
        [_listArr removeAllObjects];
    }
    NSString * urlstr =@"http://baobab.wandoujia.com/api/v3/discovery";
    [NetWork requestDataByUrl:urlstr Parameters:nil success:^(id responseObj) {
        NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        NSDictionary *itemList = [responseObject objectForKey:@"itemList"];
        for (NSDictionary *dict in itemList) {
            NSString *type = [dict objectForKey:@"type"];
            if ([type isEqualToString:@"squareCard"]) {
                
                NSDictionary *dataDic = dict[@"data"];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                [arr addObject:dataDic];
                
                for (NSDictionary *Dic in arr) {
                    DiscoveryModel *model = [[DiscoveryModel alloc]init];
                    model.image = [NSString stringWithFormat:@"%@",Dic[@"image"]];
                    model.actionUrl = [NSString stringWithFormat:@"%@",Dic[@"actionUrl"]];
                    model.title = [NSString stringWithFormat:@"%@",Dic[@"title"]];
                    model.IdStr = [NSString stringWithFormat:@"%@",Dic[@"id"]];
                    [_listArr addObject:model];
                }
            }
        }
        [_collectView reloadData];
        
        
    } failBlock:^(id responseObj) {
        NSLog(@"下载数据出错：%@",responseObj);
    }];

}

-(void)addNav{
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text =@"Discovery";
    label.font =[UIFont fontWithName:@"Lobster 1.4" size:24];
    label.textColor =[UIColor blackColor];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.tintColor =[UIColor blackColor];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}
-(void)addCollectView{
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ScreenWidth-9)/2;
    layout.itemSize = CGSizeMake(width, width);
    layout.sectionInset =UIEdgeInsetsMake(3, 3, 3, 3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing =0;
    layout.minimumInteritemSpacing =0;
    _collectView =[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.center = self.view.center;
    _collectView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:_collectView];
    [_collectView registerClass:[DiscoveryCell class] forCellWithReuseIdentifier:@"item"];
    _collectView.delegate =self;
    _collectView.dataSource =self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _listArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    DiscoveryModel * model =_listArr[indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.title.text = model.title;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            TopVC * top =[[TopVC alloc] init];
            top.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:top animated:YES];
        }
            break;
        case 1:
        {
            TopicVC * topic =[[TopicVC alloc] init];
            topic.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:topic animated:YES];
        }
            break;
        default:
        {
            DiscoveryOtherVC * other =[[DiscoveryOtherVC  alloc] init];
            DiscoveryModel * model =_listArr[indexPath.row];
            other.actionUrl = model.actionUrl;
            other.pageTitle = model.title;
            other.idStr = model.IdStr;
            other.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:other animated:YES];
        }
            break;
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
