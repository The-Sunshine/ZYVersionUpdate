//
//  ZYVersionUpdateView.m
//
//
//  Created by zy on 2021/12/26.
//  Copyright © 2021 zy. All rights reserved.
//

#import "ZYVersionUpdateView.h"
#import "Masonry.h"

static NSString * cellID = @"cellID";

@interface ZYVersionUpdateView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * array;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * cancelButton;

@property (nonatomic, strong) UIButton * sureButton;

@end

@implementation ZYVersionUpdateView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    UIView * whiteView = UIView.new;
    [self addSubview:whiteView];
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = true;
    whiteView.backgroundColor = UIColor.whiteColor;
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(34);
    }];
 
    UILabel * titleLabel = UILabel.new;
    [whiteView addSubview:titleLabel];
    titleLabel.text = @"发现最新版本";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.redColor;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.offset(0);
    }];

    UIView * line = UIView.new;
    [whiteView addSubview:line];
    line.backgroundColor = UIColor.redColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.height.offset(1.5);
    }];
    
    UIButton * cancelButton = UIButton.new;
    [whiteView addSubview:cancelButton];
    _cancelButton = cancelButton;
    [cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.masksToBounds = true;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = UIColor.redColor.CGColor;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.offset(12.5);
        make.right.offset(-12.5);
        make.height.offset(34);
    }];

    UIButton * sureButton = UIButton.new;
    [whiteView addSubview:sureButton];
    _sureButton = sureButton;
    [sureButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = true;
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.backgroundColor = UIColor.redColor;
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelButton.mas_top).offset(-10);
        make.left.right.height.equalTo(cancelButton);
    }];
    
    UITableView * tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [whiteView addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureButton.mas_top).offset(-10);
        make.top.equalTo(line.mas_bottom).offset(13);
        make.left.right.equalTo(sureButton);
    }];
}

- (void)setModel:(ZYVersionUpdateModel *)model {
    _model = model;
    if (model.force.boolValue) {
        _cancelButton.hidden = true;
        [_sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-10);
            make.left.offset(12.5);
            make.right.offset(-12.5);
            make.height.offset(34);
        }];
    }
    _array = [model.content componentsSeparatedByString:@"\n"];
    [_tableView reloadData];
}

- (void)sureClick {
    !_sureBlock ?: _sureBlock();
}

- (void)cancelClick {
    !_cancelBlock ?: _cancelBlock();
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

@end
