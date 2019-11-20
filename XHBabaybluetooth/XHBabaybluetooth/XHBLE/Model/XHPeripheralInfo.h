//
//  XHPeripheralInfo.h
//  XHBabaybluetooth
//
//  Created by power on 2019/11/20.
//  Copyright © 2019 Henan XinKangqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BabyBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHPeripheralInfo : NSObject
@property (nonatomic, strong) NSNumber     *RSSI;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSDictionary *advertisementData;
@end

NS_ASSUME_NONNULL_END
