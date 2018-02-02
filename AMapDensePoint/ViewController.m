//
//  ViewController.m
//  AMapDensePoint
//
//  Created by RichyLeo on 2018/2/2.
//  Copyright © 2018年 WTC. All rights reserved.
//

#import "ViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ViewController () <MAMapViewDelegate, MAMultiPointOverlayRendererDelegate>

@property (nonatomic, nullable, strong) MAMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[AMapServices sharedServices].apiKey = @"26fbd432ca939e243064c285dc381f6c";
	[AMapServices sharedServices].enableHTTPS = YES;
	
	///把地图添加至view
	self.mapView.zoomLevel = 3;
	[self.view addSubview:self.mapView];
	
	//
	[self generateDenseMapPoints];
}

- (MAMapView *)mapView
{
	if(!_mapView){
		_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
		_mapView.delegate = self;
	}
	return _mapView;
}

- (void)generateDenseMapPoints
{
	//创建MultiPointItems数组，并更新数据
	NSMutableArray *items = [NSMutableArray array];
	
	for (int i = 0; i < 1000; ++i)
	{
		@autoreleasepool {
			MAMultiPointItem *item = [[MAMultiPointItem alloc] init];
			item.coordinate = CLLocationCoordinate2DMake(arc4random() % 90, arc4random() % 360);
			[items addObject:item];
		}
	}
	
	///根据items创建海量点Overlay MultiPointOverlay
	MAMultiPointOverlay *_overlay = [[MAMultiPointOverlay alloc] initWithMultiPointItems:items];
	
	///把Overlay添加进mapView
	[self.mapView addOverlay:_overlay];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
	if ([overlay isKindOfClass:[MAMultiPointOverlay class]])
	{
		MAMultiPointOverlayRenderer * renderer = [[MAMultiPointOverlayRenderer alloc] initWithMultiPointOverlay:overlay];
		
		///设置图片
		renderer.icon = [UIImage imageNamed:@"icon_map_pin"];
		///设置锚点
		renderer.anchor = CGPointMake(0.5, 1.0);
		renderer.delegate = self;
		return renderer;
	}
	
	return nil;
}

- (void)multiPointOverlayRenderer:(MAMultiPointOverlayRenderer *)renderer didItemTapped:(MAMultiPointItem *)item
{
	NSLog(@"item :%@ <%f, %f>", item, item.coordinate.latitude, item.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
