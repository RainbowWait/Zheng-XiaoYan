//
//  TableViewCell.m
//  UI14_UITableView编辑
//
//  Created by 黄明远 on 16/10/28.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "TableViewCell.h"
#import "SeperateView.h"
@implementation TableViewCell{
    SeperateView *seperateLineView;
}
//- (void)dealloc{
//    [super dealloc];
//    
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
        
    }
    return self;
}
- (void)setup{
    self.lableName = [[UILabel alloc]init];
    self.lableName.textAlignment  = NSTextAlignmentLeft;
    self.lableName.textColor = [UIColor blackColor];

    self.lableName.frame = CGRectMake(16, 0, self.contentView.frame.size.width - 32, 30);
    ;
    [self.contentView addSubview:self.lableName];
    //分隔线
    seperateLineView = [[SeperateView alloc]init];
    //为了避免cell在选中的时候线的颜色变为无色

    seperateLineView.frame = CGRectMake(16,self.contentView.frame.size.height - 0.5 , [UIScreen mainScreen].bounds.size.height - 32, 0.5);
    [seperateLineView setPersistentBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:seperateLineView];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setString:(NSString *)string{
    _string = string;
    self.lableName.text = string;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
