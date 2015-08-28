//
//  ViewController.m
//  LDYGaoDeMapDemo
//
//  Created by qianfeng on 15-7-30.
//  Copyright (c) 2015年 林丹阳. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface ViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.region=MACoordinateRegionMake(CLLocationCoordinate2DMake(34.77274892, 113.67591140), MACoordinateSpanMake(0.01, 0.01));
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [self createAnnotation];
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"751c197ed5a8a9aa78723beddba39a54" Delegate:self];
    //构造 AMapPlaceSearchRequest 对象,配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init]; poiRequest.searchType = AMapSearchType_PlaceKeyword; poiRequest.keywords = @"俏江南";
    poiRequest.city = @[@"zhengzhou"];
    poiRequest.requireExtension = YES;
    //发起 POI 搜索
    [_search AMapPlaceSearch: poiRequest];
}
#pragma  mark - 搜索
//实现 POI 搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0) {
        return; }
    //处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@",response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description]; }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

#pragma  mark - 大头针
-(void)createAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(34.77274892, 113.67591140);
    pointAnnotation.title = @"千锋";
    pointAnnotation.subtitle = @"纬五路21号";
    [_mapView addAnnotation:pointAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout=YES;//设置气泡可以弹出,默认为 NO
        annotationView.animatesDrop=YES;//设置标注动画显示,默认为 NO
        annotationView.draggable=YES;//设置标注可以拖动,默认为 NO
        annotationView.pinColor=MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


@end
