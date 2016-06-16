//
//  FirstViewController.m
//  AddressBookDemo
//
//  Created by 洛方 on 16/6/15.
//  Copyright © 2016年 洛方. All rights reserved.
//

#import "FirstViewController.h"
#import <AddressBook/AddressBook.h>
#import "ChineseToPinyin.h"
@interface FirstViewController ()
<UITableViewDataSource,
UITableViewDelegate>
{
    ABAddressBookRef addressBookRef;
    UITableView * firstTableView;
    NSMutableArray * dataArray;
    NSMutableArray * sectionTitles;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    firstTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    firstTableView.delegate = self;
    firstTableView.dataSource = self;
    firstTableView.backgroundColor = [UIColor clearColor];
    firstTableView.showsVerticalScrollIndicator = NO;
    firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    firstTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //设置索引列文本的颜色
    firstTableView.sectionIndexColor = [UIColor greenColor];
    //myTableView.sectionIndexBackgroundColor=BB_Red_Color;
    //myTableView.sectionIndexTrackingBackgroundColor=BB_White_Color;
    [self.view addSubview:firstTableView];
    dataArray = [NSMutableArray arrayWithCapacity:1];
    sectionTitles = [NSMutableArray arrayWithObjects:@"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#" ,nil];
    [self getAddressPerson];
    
}

- (void)getAddressPerson
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {
        // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0); ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
            [self copyAddressBook:addressBook];

        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else {
            // we're on iOS 5 or older
        
            accessGranted = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [firstTableView reloadData];
            NSLog(@"没有获取到访问通讯录权限");
        
    });

    //模拟器不会立即获取，建议使用上一种
//    addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
////            CFErrorRef *error1 = NULL;
////            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
////            [self copyAddressBook:addressBook];
//            [self copyAddressBook:addressBookRef];
//        });
//    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
//        
//        CFErrorRef *error = NULL;
//        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//        [self copyAddressBook:addressBook];
//    }
//    else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 更新界面
//            [firstTableView reloadData];
//            NSLog(@"没有获取到访问通讯录权限");
//        });
//    }
}




- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for ( int i = 0; i < numberOfPeople; i++){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSLog(@"1111%@",firstName);
        [dic setValue:firstName forKey:@"firstName"];
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"1111%@",lastName);
        [dic setValue:lastName forKey:@"lastName"];

//        //读取middlename
//        NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
//        NSLog(@"1111%@",middlename);
//
//        //读取prefix前缀
//        NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
//        NSLog(@"1111%@",prefix);
//
//        //读取suffix后缀
//        NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
//        NSLog(@"1111%@",suffix);
//
//        //读取nickname呢称
//        NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
//        NSLog(@"1111%@",nickname);
//
//        //读取firstname拼音音标
//        NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
//        NSLog(@"1111%@",firstnamePhonetic);
//
//        //读取lastname拼音音标
//        NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
//        NSLog(@"1111%@",lastnamePhonetic);
//
//        //读取middlename拼音音标
//        NSString *middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
//        NSLog(@"1111%@",middlenamePhonetic);
//
//        //读取organization公司
//        NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
//        NSLog(@"1111%@",organization);
//
//        //读取jobtitle工作
//        NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
//        NSLog(@"1111%@",jobtitle);
//
//        //读取department部门
//        NSString *department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
//        NSLog(@"1111%@",department);
//
//        //读取birthday生日
//        NSDate *birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
//        NSLog(@"1111%@",birthday);
//
//        //读取note备忘录
//        NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
//        NSLog(@"1111%@",note);
//
//        //第一次添加该条记录的时间
//        NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
//        NSLog(@"1111%@",lastName);
//
//        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
//        //最后一次修改該条记录的时间
//        NSString *lastknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
//        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
//        
//        //获取email多值
//        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
//        CFIndex emailcount = ABMultiValueGetCount(email);
//        for (int x = 0; x < emailcount; x++)
//        {
//            //获取email Label
//            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
//            //获取email值
//            NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
//            NSLog(@"%@%@", emailLabel,emailContent);
//
//        }
//        //读取地址多值
//        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
//        CFIndex count = ABMultiValueGetCount(address);
//        
//        for(int j = 0; j < count; j++)
//        {
//            //获取地址Label
//            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
//            //获取該label下的地址6属性
//            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
//            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
//            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
//            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
//            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
//            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
//            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
//            NSLog(@"%@%@%@%@%@%@%@%@%%@",addressLabel,personaddress,country,city,state,street,zip,coutntrycode);
//        }
//        
//        //获取dates多值
//        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
//        CFIndex datescount = ABMultiValueGetCount(dates);
//        for (int y = 0; y < datescount; y++)
//        {
//            //获取dates Label
//            NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
//            //获取dates值
//            NSString* datesContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(dates, y);
//            NSLog(@"%@%@", datesLabel,datesContent);
//        }
//        //获取kind值
//        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
//        if (recordType == kABPersonKindOrganization) {
//            // it's a company
//            NSLog(@"it's a company\n");
//        } else {
//            // it's a person, resource, or room
//            NSLog(@"it's a person, resource, or room\n");
//        }
//        
//        
//        //获取IM多值
//        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
//        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
//        {
//            //获取IM Label
//            NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
//            //获取該label下的2属性
//            NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
//            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
//            
//            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
//            NSLog(@"%@%@%@%@", instantMessageLabel,instantMessageContent,username,service);
//
//        }
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSLog(@"%@%@",personPhoneLabel,personPhone);
            [dic setValue:personPhone forKey:@"personPhone"];

        }
        
//        //获取URL多值
//        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
//        for (int m = 0; m < ABMultiValueGetCount(url); m++)
//        {
//            //获取电话Label
//            NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
//            //获取該Label下的电话值
//            NSString * urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
//            NSLog(@"%@%@",urlLabel,urlContent);
//
//        }
//        
//        //读取照片
//        NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
//        NSLog(@"%@", image);
        NSString *personPhone =  [dic objectForKey:@"personPhone"];
        if (personPhone.length > 0) {
            [array addObject:dic];
        }
    }
    dataArray = [self sortDataArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [firstTableView reloadData];
    });
}

#pragma mark -- tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([dataArray[section] count] > 0) {
        return 30;
    }else
    {
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = sectionTitles[section];
    titleLabel.textColor = [UIColor redColor];
    return titleLabel;
}
#pragma mark -- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indefile = @"SCUseViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indefile];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indefile];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * dic = dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"lastName"], [dic objectForKey:@"firstName"] ];
    cell.detailTextLabel.text = [dic objectForKey:@"personPhone"];
    return cell;
}
//添加索引列

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView

{
       return sectionTitles;
}

//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index

{
    
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,(long)index);
    
    for(NSString *character in sectionTitles)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

//分区排序
#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)array
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [sectionTitles removeAllObjects];
    [sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (NSDictionary *dic in array) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString * str = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"lastName"], [dic objectForKey:@"firstName"] ];
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:str];
        
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:dic];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
            NSString * str1 = [NSString stringWithFormat:@"%@%@",[dic1 objectForKey:@"lastName"], [dic1 objectForKey:@"firstName"]];
            NSString * str2 = [NSString stringWithFormat:@"%@%@",[dic2 objectForKey:@"lastName"], [dic2 objectForKey:@"firstName"] ];
            
            
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:str1];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:str2];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
        
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    
    return sortedArray;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
