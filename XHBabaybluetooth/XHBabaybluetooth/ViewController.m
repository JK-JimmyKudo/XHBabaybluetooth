//
//  ViewController.m
//  XHBabaybluetooth
//
//  Created by power on 2019/11/20.
//  Copyright © 2019 Henan XinKangqiao. All rights reserved.
//

#import "ViewController.h"

#import "XHBabyBluetoothManager.h"
#import "XHPeripheralInfo.h"

#define SERVICE_UUID @""
#define NOTIFY_UUID  @""
#define WRITE_UUID   @""



@interface ViewController ()<XHBabyBluetoothManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) XHBabyBluetoothManager *babyMgr;


@property (nonatomic, strong) NSMutableDictionary *keyCodeDictionary;


@property (nonatomic, strong) NSMutableArray *dataSource;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, copy) NSString *peripheralName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initHKBabyBluetooth];
     
     NSString *temp = @"KQC19060100896&EB:10:10:C9:8B:FE&20241113";
    

     [self creatDoorModel:temp];
    
}

-(void) creatDoorModel:(NSString *)temp{
    
    NSMutableArray *keyIdArr = [NSMutableArray array];
    
    NSArray *array = [temp componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
    NSLog(@"array:%@",array);
    NSString *mark = array[1];
    NSLog(@"mark:%@",mark);
    NSString *temp1  = [self gainString:mark];
    NSLog(@"temp:%@",temp1);
    NSString *keyCode  = array[0];
    NSMutableDictionary *keyCodeDictionary  = [NSMutableDictionary dictionary];
    [keyCodeDictionary setObject:keyCode forKey:@"key"];
    [keyCodeDictionary setObject:temp1 forKey:@"name"];
    NSLog(@"self.keyCodeDictionary:%@",keyCodeDictionary);
    NSString *key = [keyCodeDictionary objectForKey:@"key"];
    NSLog(@"key:%@",key);
    NSMutableArray *keyArr = [NSMutableArray array];
    [keyArr addObject:keyCodeDictionary];
    
    
    [keyIdArr addObjectsFromArray:keyArr];
    
    NSLog(@"keyIdArr:%@",keyIdArr);

}

- (NSString *)gainString:(NSString *)string
{
    NSString *result = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@":" withString:@""];
//    NSLog(@"result===%@", result);
    return result;
}


- (void)initHKBabyBluetooth {
    _babyMgr = [XHBabyBluetoothManager sharedManager];
    _babyMgr.delegate = self;
//    [_babyMgr startScanPeripheral];
}


#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    
    XHPeripheralInfo *info = self.dataSource[indexPath.row];
    cell.textLabel.text = info.peripheral.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XHPeripheralInfo *info = self.dataSource[indexPath.row];
    
    // 去连接当前选择的Peripheral
    [_babyMgr connectPeripheral:info.peripheral];
}


#pragma mark HKBabyBluetoothManageDelegate 代理回调
- (void)systemBluetoothClose {
    // 系统蓝牙被关闭、提示用户去开启蓝牙
    
    
}

- (void)sysytemBluetoothOpen {
    // 系统蓝牙已开启、开始扫描周边的蓝牙设备
    [_babyMgr startScanPeripheral];
}



- (void)getScanResultPeripherals:(NSArray *)peripheralInfoArr {
    
    NSLog(@"peripheralInfoArr == %@",peripheralInfoArr);
    
    self.peripheralName = @"";
 

    
    // 这里获取到扫描到的蓝牙外设数组、添加至数据源中
    if (self.dataSource.count>0) {
        [self.dataSource removeAllObjects];
    }

    [self.dataSource addObjectsFromArray:peripheralInfoArr];
    [self.tableView reloadData];

//    for (HKPeripheralInfo *peripheralInfo  in peripheralInfoArr) {
//        NSLog(@"peripheralInfo.peripheral.name == %@",peripheralInfo.peripheral.name);
//        for (NSString *name in dataArr) {
//            if ([peripheralInfo.peripheral.name isEqualToString:name]) {
//
//                self.peripheralName = peripheralInfo.peripheral.name;
//                [_babyMgr stopScanPeripheral];
//                [_babyMgr connectPeripheral:peripheralInfo.peripheral];
//            }
//        }
//    }
}

- (void)connectSuccess {
    // 连接成功 写入UUID值【替换成自己的蓝牙设备UUID值】
    _babyMgr.serverUUIDString = SERVICE_UUID;
    _babyMgr.writeUUIDString = WRITE_UUID;
    _babyMgr.readUUIDString = NOTIFY_UUID;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self sendAction:nil];
    });
   
}

- (void)connectFailed {
    // 连接失败、做连接失败的处理
}

-(void)setBlockOnCancelScanBlock{
    
    
    if (self.peripheralName.length == 0) {
        NSLog(@"扫描超市 === ");
    }
    
}

- (void)sendAction:(UIButton *)sender {
    // 向蓝牙发数据 转化为data类型
//    Byte byte[] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
//    NSData *data = [[NSData dataWithBytes:&byte
//                                   length:sizeof(&byte)]
//                    subdataWithRange:NSMakeRange(0, 8)];

    NSString *keyCode = @"KQC19060100897";
    NSData *data = [keyCode dataUsingEncoding:NSUTF8StringEncoding];
    [_babyMgr write:data];
    
}

- (void)readData:(NSData *)valueData {
    // 获取到蓝牙设备发来的数据
    
    
    NSString * dataStr  =[[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
    
    NSLog(@"蓝牙发来的数据 = %@",[NSString stringWithFormat:@"%@",dataStr]);

    
}

- (void)disconnectAction:(UIButton *)sender {
    // 断开连接
    // 1、可以选择断开所有设备
    // 2、也选择断开当前peripheral
    [_babyMgr disconnectAllPeripherals];
    //[_babyMgr disconnectLastPeripheral:(CBPeripheral *)];
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    // 获取到当前断开的设备 这里可做断开UI提示处理
    
}





#pragma mark lazy - load
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
