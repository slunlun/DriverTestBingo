//
//  SWDriverTestApplyViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/11/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestApplyViewController.h"
#import "SWMainContentTabBarController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface SWDriverTestApplyViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKPoiSearchDelegate>
@property(nonatomic, strong) BMKMapView* mapView;
@property(nonatomic, strong) BMKLocationService *locService;
@property(nonatomic, strong) BMKPoiSearch *search;
@end

@implementation SWDriverTestApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.gesturesEnabled = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = true;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量（经度）
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:15];// 缩放级别
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.desiredAccuracy = 5.0;
    [self.view addSubview:_mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_locService startUserLocationService];
    
    ((SWMainContentTabBarController *)self.tabBarController).drag2ShowMenuVC.shouldResponseUserAction = NO;
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ((SWMainContentTabBarController *)self.tabBarController).drag2ShowMenuVC.shouldResponseUserAction = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - /**

/*在将要启动定位时，会调用此函数
*/
- (void)willStartLocatingUser
{
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
     _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    

    //[_mapView addO];
    [_locService stopUserLocationService];
    
    
    // poi search
    _search =[[BMKPoiSearch alloc]init];
    _search.delegate = self;    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 1;  //当前索引页
    option.pageCapacity = 10; //分页量
    option.location = userLocation.location.coordinate;
    option.keyword = @"驾校";
    option.radius = 3000;
    BOOL flag = [_search poiSearchNearBy:option];
    if(flag)     {
        NSLog(@"周边检索发送成功");
    }    else     {
        NSLog(@"周边检索发送失败");
    }


}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

#pragma mark - BMKPoiSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    //正确
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        //遍历返回的查询结果
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = poi.phone;
            //给地图添加大头针模型
            [_mapView addAnnotation:item];
        }
        [_mapView showAnnotations:annotations animated:YES];
        
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if ([view.annotation subtitle]) {
        NSString *telNum = [NSString stringWithFormat:@"telprompt://%@", [view.annotation subtitle]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];

    }
}

@end
