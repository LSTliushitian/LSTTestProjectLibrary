//
//  LSTMicroVideoBackgroundMusicVC.m
//  GoldLiving
//
//  Created by 刘士天 on 2017/11/20.
//  Copyright © 2017年 YIYOU. All rights reserved.
//

#import "LSTMicroVideoBackgroundMusicVC.h"
#import "LSTMicroVideoBackgroundMusicCell.h"//Cell
#import "LSTMicroVideoBackgroundMusicModel.h"//Model
#import "LSTMicVideoBGMSearchVC.h"//背景音乐搜索

@interface LSTMicroVideoBackgroundMusicVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>
{
    void(^_selectBlock)(NSString *, NSString *, NSString *);
    NSInteger _currentPage;//当前页码
    NSString * _typeId;//当前音乐分类
}

@property (strong, nonatomic) UIScrollView * menuScrollView;//音乐分类菜单
@property (strong, nonatomic) UIView * indicateView;//指示条
@property (strong, nonatomic) NSMutableArray * musicTypeArr;//分类数组
@property (strong, nonatomic) NSMutableArray * menuButtonArr;//菜单按钮数组
@property (strong, nonatomic) UITableView * tableView;//音乐列表
@property (strong, nonatomic) NSMutableArray * dataSource;//数据数组
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;//音频播放器
@property (strong, nonatomic) UIImageView * emptyIV;//空数据视图

@end

@implementation LSTMicroVideoBackgroundMusicVC

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_audioPlayer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"在线音乐";
    self.view.backgroundColor = BackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.rightButton.frame = CGRectMake(SCREENWIDTH-60*PIX, CGRectGetHeight(self.navigationView.frame)-44, 60*PIX, 44);
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:23*PIX];
    [self.rightButton setTitleColor:RGB(207, 207, 207) forState:UIControlStateNormal];
    [self.rightButton setTitle:@"\ue60f" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //当前页码
    _currentPage = 1;
    //分类数组
    _musicTypeArr = [[NSMutableArray alloc] init];
    //菜单按钮数组
    _menuButtonArr = [[NSMutableArray alloc] init];
    //数据数组
    _dataSource = [[NSMutableArray alloc] init];
    
    //音乐分类菜单
    [self.view addSubview:({
        _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), SCREENWIDTH, 39*PIX)];
        _menuScrollView.backgroundColor = [UIColor whiteColor];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.delegate = self;
        
        _menuScrollView;
    })];
    
    //音乐列表
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationView.frame)+40*PIX, SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(self.navigationView.frame)-40*PIX) style:UITableViewStylePlain];
        _tableView.backgroundColor = BackgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            [self networkForData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _currentPage++;
            [self networkForData];
        }];
        
        _tableView;
    })];
    
    //空数据视图
    [self.view addSubview:({
        _emptyIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0-128*PIX, SCREENHEIGHT/2.0-128*PIX, 256*PIX, 256*PIX)];
        _emptyIV.image = [UIImage imageNamed:@"LXNoDataImage"];
        _emptyIV.hidden = YES;
        
        _emptyIV;
    })];
    
    
    [self networkForMusicType];//网络请求音乐数据
}

//根据数据布局菜单视图
- (void) configMenuScrollView {
    CGFloat curWidth = 0.0f;
    for (LSTMicroVideoBackgroundMusicTypeModel * model in _musicTypeArr) {
        [_menuScrollView addSubview:({
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 39*PIX)];
            label.font = [UIFont systemFontOfSize:16*PIX];
            label.text = model.typeName;
            [label sizeToFit];
            label.frame = CGRectMake(0, 0, CGRectGetWidth(label.frame), 35*PIX);
            
            UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            menuButton.frame = CGRectMake(curWidth, 0, CGRectGetWidth(label.frame)+26*PIX, 39*PIX);
            menuButton.titleLabel.font = [UIFont systemFontOfSize:16*PIX];
            [menuButton setTitle:model.typeName forState:UIControlStateNormal];
            [menuButton setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            [menuButton setTitleColor:[MainBackGroundColor ColorWithSize:menuButton.frame.size andColors:@[RGB(155, 66, 255), RGB(226, 109, 255)]] forState:UIControlStateSelected];
            [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            curWidth += CGRectGetWidth(menuButton.frame);
            [_menuButtonArr addObject:menuButton];
            
            menuButton;
        })];
    }
    
    _menuScrollView.contentSize = CGSizeMake(curWidth, 0);
    
    //指示条
    [_menuScrollView addSubview:({
        UIButton * menuButton = _menuButtonArr.firstObject;
        menuButton.selected = YES;
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(menuButton.mj_x+15*PIX, 35*PIX, menuButton.mj_w-30*PIX, 4*PIX)];
        _indicateView.layer.masksToBounds = YES;
        _indicateView.layer.cornerRadius = 2*PIX;
        
        _indicateView.backgroundColor = [MainBackGroundColor ColorWithSize:_indicateView.frame.size andColors:@[RGB(155, 66, 255), RGB(226, 109, 255)]];
        
        _indicateView;
    })];
}

#pragma mark - 网络请求
- (void) networkForMusicType {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [HttpTool POST:[NSString stringWithFormat:@"%@/microview/microView/backgroundMusicType", YuMing] parameters:@{@"Token":UserData.token} success:^(id responseObject) {
        if ([[responseObject objectForKey:@"errCode"] integerValue]) {
            [LXProgressHUD showError:[responseObject objectForKey:@"errMsg"]];
        } else {
            _musicTypeArr = [LSTMicroVideoBackgroundMusicTypeModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            [self configMenuScrollView];
            
            LSTMicroVideoBackgroundMusicTypeModel * model = _musicTypeArr.firstObject;
            //当前音乐分类
            _typeId = model.typeId;
            _menuScrollView.hidden = NO;
            _emptyIV.hidden = YES;
            
            [self networkForData];
        }
    } failure:^(NSError *error) {
        if (!_musicTypeArr.count) {
            _menuScrollView.hidden = YES;
            _emptyIV.hidden = NO;
            _emptyIV.image = [UIImage imageNamed:@"LXNoNetwork"];
        } else {
            [LXProgressHUD showError:FailedString];
        }
    }];
}

- (void) networkForData {
    if (!_typeId.length) {
        for (UIView * view in _menuScrollView.subviews) {
            [view removeFromSuperview];
        }
        _currentPage = 1;
        [self networkForMusicType];
        return;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/microview/microView/backgroundMusic", YuMing];
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:UserData.token forKey:@"Token"];//token
    [infoDic setObject:_typeId forKey:@"typeId"];//typeId
    [infoDic setObject:[NSString stringWithFormat:@"%ld", _currentPage] forKey:@"pageNo"];//pageNo
    [infoDic setObject:@"20" forKey:@"pageSize"];//pageSize
    [HttpTool POST:urlStr parameters:infoDic success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        if ([[responseObject objectForKey:@"errCode"] integerValue]) {
            [LXProgressHUD showError:[responseObject objectForKey:@"errCode"]];
        } else {
            NSArray * dataArr = [LSTMicroVideoBackgroundMusicModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
            if (_currentPage == 1) {
                [_audioPlayer stop];
                [_dataSource removeAllObjects];
                _dataSource = [NSMutableArray arrayWithArray:dataArr];
            } else {
                [_dataSource addObjectsFromArray:dataArr];
            }
            
            [_tableView reloadData];
            if (!_dataSource.count) {
                _emptyIV.hidden = NO;
                _emptyIV.image = [UIImage imageNamed:@"LXNoDataImage"];
            } else {
                _emptyIV.hidden = YES;
            }
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (!_dataSource.count) {
            _emptyIV.hidden = NO;
            _emptyIV.image = [UIImage imageNamed:@"LXNoNetwork"];
        } else {
            [LXProgressHUD showError:FailedString];
        }
    }];
}

#pragma mark - 网络请求音乐
- (void) networkForBGMWithModel:(LSTMicroVideoBackgroundMusicModel *) model cellAtIndexPath:(NSIndexPath *)indexPath {
    //获取音频保存路径
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    savePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"backgroundMusic"]];
    NSString * filePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.mp3", model.musicId, model.musicName]];
    NSFileManager *fm=[NSFileManager defaultManager];
    BOOL isExit = [fm fileExistsAtPath:filePath];
    if (isExit) {//判断当前选择的音乐，本地有缓存
        LSTMicroVideoBackgroundMusicCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
        cell.model = model;
        NSError * error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        NSLog(@">>>%@", [error description]);
        _audioPlayer.delegate = self;
        _audioPlayer.volume = 15.0;
        [_audioPlayer play];
    } else {//没有本地缓存，需要到网络上下载
        if ([fm createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"文件夹创建成功");
        }
        else
        {
            NSLog(@"文件夹创建失败");
        }
        
        NSString * musicUrl = [model.musicUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:musicUrl]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (!connectionError) {
                //下载的音频保存到本地
                BOOL isWrite = [data writeToFile:filePath atomically:YES];
                if (isWrite) {
                    NSLog(@"写成功。。。。");
                    LSTMicroVideoBackgroundMusicModel * model = [_dataSource objectAtIndex:indexPath.row];
                    LSTMicroVideoBackgroundMusicCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                    cell.model = model;
                    if (model.isPlaying) {
                        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
                        _audioPlayer.delegate = self;
                        _audioPlayer.volume = 15.0;
                        [_audioPlayer play];
                    }
                    
                }
                else
                {
                    NSLog(@"写入失败");
                }
            } else {
                [LXProgressHUD showError:@" 音乐加载失败，请重新加载"];
            }
        }];
    }

}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105*PIX;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTMicroVideoBackgroundMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LSTMicroVideoBackgroundMusicCell"];
    if (!cell) {
        cell = [[LSTMicroVideoBackgroundMusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTMicroVideoBackgroundMusicCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LSTMicroVideoBackgroundMusicModel * model = [_dataSource objectAtIndex:indexPath.row];
    cell.model = model;
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    savePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"backgroundMusic"]];
    NSString * filePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.mp3", model.musicId, model.musicName]];
    
    __weak typeof(LSTMicroVideoBackgroundMusicVC *) weakSelf = self;
    [cell selectButtonClickBlock:^{
        [_audioPlayer stop];
        if (_selectBlock) {
            _selectBlock(filePath, model.musicName, model.musicImage);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_audioPlayer stop];//点击时暂停播放
    for (int i = 0; i < _dataSource.count; i++) {//遍历model
        LSTMicroVideoBackgroundMusicModel * model = [_dataSource objectAtIndex:i];
        LSTMicroVideoBackgroundMusicCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {//当前选中的cell更改选中状态
            model.isPlaying = !model.isPlaying;
            if (model.isPlaying) {//如果当前为选中状态，则下载并播放音乐
                [self networkForBGMWithModel:model cellAtIndexPath:indexPath];
            } else {//非选中状态，直接更改cell，停止音乐播放
                cell.model = model;
            }
        } else {//选中之外的其他项均为非选中状态
            model.isPlaying = NO;
            cell.model = model;
        }
        
        [_dataSource replaceObjectAtIndex:i withObject:model];
    }
}

#pragma mark - #pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    for (int i = 0; i < _dataSource.count; i++) {//遍历model
        LSTMicroVideoBackgroundMusicModel * model = [_dataSource objectAtIndex:i];
        LSTMicroVideoBackgroundMusicCell * cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        model.isPlaying = NO;
        cell.model = model;
    }
}

#pragma mark - 按钮点击事件
- (void) menuButtonClick:(UIButton *)sender {
    [_audioPlayer stop];//更换菜单时，停止当前的音频播放
    for (UIButton * tmpBtn in _menuButtonArr) {
        tmpBtn.selected = NO;
    }
    
    sender.selected = YES;
    
    //根据当前选择的位置修改偏移量
    CGFloat offsetX = sender.mj_origin.x - _menuScrollView.frame.size.width/2.0;
    
    if (offsetX<0) {
        offsetX = 0;
    } else if (offsetX>_menuScrollView.contentSize.width-_menuScrollView.frame.size.width) {
        offsetX = _menuScrollView.contentSize.width - _menuScrollView.frame.size.width;
    }
    
    //滑动到目标偏移量
    [UIView animateWithDuration:0.3 animations:^{
        [_menuScrollView setContentOffset:CGPointMake(offsetX, 0)];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = _indicateView.frame;
        //修改指示条横向坐标
        rect.origin.x = sender.mj_x;
        //修改指示条宽度
        rect.size.width = sender.mj_w;
        _indicateView.backgroundColor = [MainBackGroundColor ColorWithSize:CGSizeMake(sender.mj_w, 3*PIX) andColors:@[RGB(155, 66, 255),RGB(226, 109, 255)]];
        _indicateView.frame = rect;
    } completion:^(BOOL finished) {
        _indicateView.backgroundColor = [MainBackGroundColor ColorWithSize:_indicateView.frame.size andColors:@[RGB(155, 66, 255),RGB(226, 109, 255)]];
    }];
    
    LSTMicroVideoBackgroundMusicTypeModel * model = [_musicTypeArr objectAtIndex:[_menuButtonArr indexOfObject:sender]];
    _typeId = model.typeId;
    _currentPage = 1;
//    [_dataSource removeAllObjects];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_tableView reloadData];
    [self networkForData];
}

- (void) searchButtonClick:(UIButton *) sender {
    LSTMicVideoBGMSearchVC * bgmSearchVC = [[LSTMicVideoBGMSearchVC alloc] init];
    
    [self.navigationController pushViewController:bgmSearchVC animated:YES];
}

#pragma mark - 选中背景音乐回调
- (void) musicSelectBlock:(void (^)(NSString *, NSString *, NSString *))selectBlock {
    if (_selectBlock != selectBlock) {
        _selectBlock = selectBlock;
    }
}

- (void) fanhuiButtonClick:(UIButton *)sender {
    [_audioPlayer stop];//页面返回时，停止音频播放
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
