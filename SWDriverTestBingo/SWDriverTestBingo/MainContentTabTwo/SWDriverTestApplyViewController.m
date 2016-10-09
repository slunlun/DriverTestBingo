//
//  SWDriverTestApplyViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/11/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestApplyViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface SWDriverTestApplyViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
@property(nonatomic, strong) BMKMapView* mapView;
@property(nonatomic, strong) BMKLocationService *locService;
@end

@implementation SWDriverTestApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _locService.desiredAccuracy = 5.0;
    self.view = _mapView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
      BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = true;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量（经度）
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    _mapView.showsUserLocation = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
     _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
   // [_locService stopUserLocationService];

}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

@end
