//
//  ViewController.m
//  UI14_UITableView编辑
//
//  Created by SimpleWay on 16/10/28
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "SDAutoLayout.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UITableView *tableView;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isAllSelected;
@end

@implementation ViewController{
    UIView *selectAllView;//全选
    UIImageView *allSelectedImageView;//全选
    UILabel *allSelectedLabel;//全选
    UIBarButtonItem *editButton;//
    BOOL isManaged;/**<按钮是否是管理状态>*/
     NSMutableArray *countArray;/**<删除选中的个数>*/

}
//-(void)dealloc{
////    [_dataArr release];
////    [_tableView release];
//    [super dealloc];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑";
    self.dataArr = [[@"李毅然 王竞一 陈亮宇 闫继祥 王涛 杨宇" componentsSeparatedByString:@" "] mutableCopy];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)  style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_tableView release];
    //注册cell
    //参数1:cell的类型
    //参数2:重用标志
    //class方法 -> 获取对象/类 的类名
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem = editButton;
    [self createSelectView];
    
    
}

#pragma mark- 删除视图
-(void)createSelectView{
    
    selectAllView = [UIView new];
    [self.view addSubview:selectAllView];
    //    selectAllView.backgroundColor = [UIColor redColor];
    selectAllView.backgroundColor = [UIColor whiteColor];;
    selectAllView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(50 )
    .topSpaceToView(self.tableView,0);
    UIView *seperateLineView = [UIView new];
    seperateLineView.backgroundColor = [UIColor grayColor];
    [selectAllView addSubview:seperateLineView];
    seperateLineView.sd_layout
    .topSpaceToView(selectAllView,0)
    .leftSpaceToView(selectAllView,0)
    .widthIs(self.view.frame.size.width)
    .heightIs(0.5 );
    
    
    //全选图标
    allSelectedImageView = [UIImageView new];
    allSelectedImageView.userInteractionEnabled = YES;
    [selectAllView addSubview:allSelectedImageView];
    allSelectedImageView.sd_layout
    .centerYEqualToView(selectAllView)
    .leftSpaceToView(selectAllView,16.2)
    .widthIs(22)
    .heightEqualToWidth();
    
    allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allSelectedTap:)];
    [allSelectedImageView addGestureRecognizer:tap];
    
    //全选
    allSelectedLabel = [UILabel new];
    allSelectedLabel.font = [UIFont systemFontOfSize:14];
    allSelectedLabel.text = @"全选";
    allSelectedLabel.textColor = [UIColor blackColor];
    
    [selectAllView addSubview:allSelectedLabel];
    allSelectedLabel.sd_layout
    .centerYEqualToView(selectAllView)
    .leftSpaceToView(allSelectedImageView,8.2)
    .heightIs(12);
    
    
    //删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.backgroundColor = [UIColor yellowColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//    [BaseButton withBackground:COLOR_YELLOW_CITYBUTTON andTitleColor:[UIColor whiteColor] andBorderColor:[UIColor clearColor] andTiltl:@"删除" andFont:14 andRadius:4 andBorderWidth:0];
    [deleteButton addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    [selectAllView addSubview:deleteButton];
    deleteButton.sd_layout
    .rightSpaceToView(selectAllView,16)
    .centerYEqualToView(selectAllView)
    .widthIs(66)
    .heightIs(26);
    selectAllView.hidden = YES;
    
    
    
    
    
    
}


#warning 3.设置编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //默认所有都是删除样式
            return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
 
}


//row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.string = self.dataArr[indexPath.row];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.tintColor = [UIColor redColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
#pragma mark - 当全部cell选中的时候全选按钮变状态(此地方性能可以优化)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        //获取选中的cell
        [countArray removeAllObjects];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            
            [countArray addObject:@(indexPath.row)];
            
        }
        if (countArray.count == self.dataArr.count) {
            allSelectedImageView.image = [UIImage imageNamed:@"input_check-blue"];
            self.isAllSelected = YES;
        }else{
            allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
            self.isAllSelected = NO;
        }
        

        NSLog(@"tableView处于编辑状态");
    }else{
        
        NSLog(@"tableView处于非编辑状态,可以点击");
    }
}

#pragma mark - 当取消某个cell选中是,全选状态变化(此地方性能可以优化)
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

if (self.tableView.editing) {
    
    [countArray removeAllObjects];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        
        [countArray addObject:@(indexPath.section)];
        
    }
    if (countArray.count == self.dataArr.count) {
        
        allSelectedImageView.image = [UIImage imageNamed:@"input_check-blue"];
        self.isAllSelected = YES;
        
    }else{
        allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
        self.isAllSelected = NO;
    }
}

}
#pragma mark - 管理按钮点击方法
- (void)saveAction{
    if (isManaged == NO) {
        editButton.title = @"完成";
        
        self.tableView.editing = YES;
           selectAllView.hidden = NO;
        
    }else{
    editButton.title = @"管理";
        self.tableView.editing = NO;
           selectAllView.hidden = YES;
        //防止点击全选后,点击完成,再点击管理,还是全选状态
        self.isAllSelected = NO;
        allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
        
    }
    isManaged = !isManaged;

}

#pragma mark - 全选点击方法
- (void)allSelectedTap:(UITapGestureRecognizer *)tap{
    
    self.isAllSelected = !self.isAllSelected;
    
    for (int i = 0; i< self.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        
        if (self.isAllSelected) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            allSelectedImageView.image = [UIImage imageNamed:@"input_check-blue"];
            
        }else{//反选
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
            
            
        }
    }
    
    
    
}
#pragma mark - 删除
-(void)selectedAction
{
    [self deleteAction];
//    
//    WYHAlerView *alerView =  [[WYHAlerView alloc]initWithGrayTitle:@"温馨提示" andWithNoti:@"是否要删除项目?" andFirstButtomName:@"取消" andSecondButtonName:@"确定"];
//    alerView.delegate =self;
//    [self.view addSubview:alerView];
    
}

#pragma mark- WYHAlerViewDelegate
//-(void)sureChooseWithAlerView:(WYHAlerView *)wyhAlerView withButtonIndex:(NSInteger)index{
- (void)deleteAction{
//    if (index == 1) {
    
        
//        {
    
            NSMutableArray *deleteArrarys = [NSMutableArray array];
            for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
//                ProjectPreview *projectPreview  = self.dataArr[indexPath.section];
//                
//                [deleteArrarys addObject:projectPreview.expId];
        //无接口处理方法
                [deleteArrarys addObject:self.dataArr[indexPath.row]];
                
            }
    //无接口处理方法
    [self.dataArr removeObjectsInArray:deleteArrarys];
    [self.tableView reloadData];
    //🈶接口直接参照面,掉接口,刷新数据就行
    //
    
    
//            if (deleteArrarys.count == 0) {
//                Toast(@"请选择项目");
//                return;
//            }
//            
//            NSMutableArray  *paramsArray = [NSMutableArray array];
//            //            [paramsArray addObject:self.teamId];
//            [paramsArray addObject:deleteArrarys];
//            //            [paramsArray addObject:@(2)];
//            
//            [apiUitl deleteProjectExp:paramsArray andCompletionHandler:^(bool sucess, NSString *errCode, id responseObject) {
//                
//                if (sucess) {
//                    if ([responseObject[@"success"] integerValue]) {
//                        [self downloadValue];
//                        [self.delegate updateProjectNumber:self];
//                        
//                    } else {
//                        Toast(responseObject[@"message"]);
//                    }
//                } else {
//                    TOAST;
//                }
//                
//            }];
//            [UIView animateWithDuration:0 animations:^{
//                //                [workArray removeObjectsInArray:deleteArrarys];
//                //                [dataTableView reloadData];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.25 animations:^{
//                    
//                    
//                } completion:^(BOOL finished) {
//                    
//                    selectAllView.hidden = YES;
//                    bottomView.hidden = NO;
//                    dataTableView.editing = NO;
//                    allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
//                    
//                    
//                    //                    }
//                    
//                    
//                    
//                }];
//            }];
//            
//            
//        }
//        
//        
//    }else{
//        
//        selectAllView.hidden = YES;
//        if (self.dataArray.count == 0) {
//            noDataView.hidden = NO;
//            dataTableView.hidden = YES;
//            bottomView.hidden = YES;
//        } else {
//            noDataView.hidden = YES;
//            dataTableView.hidden = NO;
//            bottomView.hidden = NO;
//        }
//        dataTableView.editing = NO;
//        self.isAllSelected = NO;
//        allSelectedImageView.image = [UIImage imageNamed:@"input_check"];
//        
//    }
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
