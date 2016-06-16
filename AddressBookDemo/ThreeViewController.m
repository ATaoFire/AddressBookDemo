//
//  ThreeViewController.m
//  AddressBookDemo
//
//  Created by 洛方 on 16/6/15.
//  Copyright © 2016年 洛方. All rights reserved.
//

#import "ThreeViewController.h"
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>


#import <AddressBookUI/ABNewPersonViewController.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBookUI/ABUnknownPersonViewController.h>
@interface ThreeViewController ()
<CNContactViewControllerDelegate,
CNContactPickerDelegate,
ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate,
ABUnknownPersonViewControllerDelegate>

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.frame = CGRectMake(10, 100, 200, 30);
    newBtn.backgroundColor = [UIColor grayColor];
    [newBtn setTitle:@"添加新联系人" forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(saveNewContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
    
    UIButton * ExistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ExistBtn.frame = CGRectMake(10, 150, 200, 30);
    ExistBtn.backgroundColor = [UIColor grayColor];
    [ExistBtn setTitle:@"保存到现有联系人" forState:UIControlStateNormal];
    [ExistBtn addTarget:self action:@selector(saveExistContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ExistBtn];
    
    UIButton * newBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn1.frame = CGRectMake(10, 200, 200, 30);
    newBtn1.backgroundColor = [UIColor grayColor];
    [newBtn1 setTitle:@"添加新联系人ios7" forState:UIControlStateNormal];
    [newBtn1 addTarget:self action:@selector(addPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn1];
    
    UIButton * ExistBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    ExistBtn1.frame = CGRectMake(10, 250, 200, 30);
    ExistBtn1.backgroundColor = [UIColor grayColor];
    [ExistBtn1 setTitle:@"未知联系人ios7" forState:UIControlStateNormal];
    [ExistBtn1 addTarget:self action:@selector(unknownPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ExistBtn1];
    
    UIButton * newBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn2.frame = CGRectMake(10, 300, 200, 30);
    newBtn2.backgroundColor = [UIColor grayColor];
    [newBtn2 setTitle:@"查询某个联系人ios7" forState:UIControlStateNormal];
    [newBtn2 addTarget:self action:@selector(showPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn2];
    
    UIButton * ExistBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    ExistBtn2.frame = CGRectMake(10, 350, 200, 30);
    ExistBtn2.backgroundColor = [UIColor grayColor];
    [ExistBtn2 setTitle:@"添加到现有联系人IOS7" forState:UIControlStateNormal];
    [ExistBtn2 addTarget:self action:@selector(addShowPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ExistBtn2];
    
}




//添加联系人
- (void)addPersonClick:(UIButton *)sender {
    ABNewPersonViewController *newPersonController=[[ABNewPersonViewController alloc]init];
    //设置代理
    //设置未知人员
    ABRecordRef recordRef=ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, @"Kenshin", NULL);
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, @"Cui", NULL);
    ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABHomeLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    newPersonController.displayedPerson=recordRef;
    newPersonController.newPersonViewDelegate=self;
    CFRelease(recordRef);

    //注意ABNewPersonViewController必须包装一层UINavigationController才能使用，否则不会出现取消和完成按钮，无法进行保存等操作
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:newPersonController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
//添加未知联系人
- (void)unknownPersonClick:(UIButton *)sender {
    ABUnknownPersonViewController *unknownPersonController=[[ABUnknownPersonViewController alloc]init];
    //设置未知人员
    ABRecordRef recordRef=ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, @"Kenshin", NULL);
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, @"Cui", NULL);
    ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABHomeLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    unknownPersonController.displayedPerson=recordRef;
    //设置代理
    unknownPersonController.unknownPersonViewDelegate=self;
//    //设置其他属性
//    unknownPersonController.allowsActions=YES;//显示标准操作按钮
//    unknownPersonController.allowsAddingToAddressBook=YES;//是否允许将联系人添加到地址簿
    
    CFRelease(multiValueRef);
    CFRelease(recordRef);
    //使用导航控制器包装
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:unknownPersonController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
//查询某个联系人
- (void)showPersonClick:(UIButton *)sender {
    ABPersonViewController *personController=[[ABPersonViewController alloc]init];
    //设置联系人
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef recordRef= ABAddressBookGetPersonWithRecordID(addressBook, 2);//取得id为1的联系人记录
    personController.displayedPerson=recordRef;
    //设置代理
    personController.personViewDelegate=self;
//    //设置其他属性
//    personController.allowsActions=YES;//是否显示发送信息、共享联系人等按钮
//    personController.allowsEditing=YES;//允许编辑
    //    personController.displayedProperties=@[@(kABPersonFirstNameProperty),@(kABPersonLastNameProperty)];//显示的联系人属性信息,默认显示所有信息
    
    //使用导航控制器包装
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:personController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//添加到现有某个联系人
- (void)addShowPersonClick:(UIButton *)sender {
    ABPeoplePickerNavigationController *peoplePickerController=[[ABPeoplePickerNavigationController alloc]init];
    //设置代理
    //设置未知人员
    ABRecordRef recordRef=ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, @"Kenshin", NULL);
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, @"Cui", NULL);
    ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABHomeLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);

    peoplePickerController.peoplePickerDelegate=self;
    [self presentViewController:peoplePickerController animated:YES completion:nil];
}
#pragma mark - ABNewPersonViewController代理方法
//完成新增（点击取消和完成按钮时调用）,注意这里不用做实际的通讯录增加工作，此代理方法调用时已经完成新增，当保存成功的时候参数中得person会返回保存的记录，如果点击取消person为NULL
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    //如果有联系人信息
    if (person) {
        NSLog(@"%@ 信息保存成功.",(__bridge NSString *)(ABRecordCopyCompositeName(person)));
    }else{
        NSLog(@"点击了取消.");
    }
    //关闭模态视图窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - ABUnknownPersonViewController代理方法
//保存未知联系人时触发
-(void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person{
    if (person) {
        NSLog(@"%@ 信息保存成功！",(__bridge NSString *)(ABRecordCopyCompositeName(person)));
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择一个人员属性后触发，返回值YES表示触发默认行为操作，否则执行代理中自定义的操作
-(BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person) {
        NSLog(@"选择了属性：%i，值：%@.",property,(__bridge NSString *)ABRecordCopyValue(person, property));
    }
    return NO;
}
#pragma mark - ABPersonViewController代理方法
//选择一个人员属性后触发，返回值YES表示触发默认行为操作，否则执行代理中自定义的操作
-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person) {
        NSLog(@"选择了属性：%i，值：%@.",property,(__bridge NSString *)ABRecordCopyValue(person, property));
    }
    [self dismissViewControllerAnimated:YES completion:nil];

    return NO;
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate代理方法

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    return YES; // 返回YES代表不进行下一步操作，相当于对操作的拦截
    
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    return YES;
    
}
//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
//        if (phone && [ZXValidateHelper checkTel:phoneNO]) {
//            phoneNum = phoneNO;
//            [self.tableView reloadData];
//            [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//            return;
//        }
    
//    ABRecordSetValue(person, kABPersonFirstNameProperty, @"Kenshin", NULL);
//    ABRecordSetValue(person, kABPersonLastNameProperty, @"Cui", NULL);
//    ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
//    ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABWorkLabel, NULL);
//    ABRecordSetValue(person, kABPersonPhoneProperty, multiValueRef, NULL);
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
        ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
        ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
        ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABWorkLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, multiValueRef, NULL);
        personViewController.displayedPerson = person;
        personViewController.allowsActions=YES;//是否显示发送信息、共享联系人等按钮
        personViewController.allowsEditing=YES;//允许编辑
        [peoplePicker pushViewController:personViewController animated:YES];
    
}


#pragma mark --------下面是iOS9的方法
//保存新联系人实现
- (void)saveNewContact:(UIButton *)btn{
    
     //1.创建Contact对象，必须是可变的
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        //2.为contact赋值，这块比较恶心，很混乱，setValue4Contact中会给出常用值的对应关系
        [self setValue4Contact:contact existContect:NO];
        //3.创建新建好友页面
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:contact];
        //代理内容根据自己需要实现
        controller.delegate = self;
        //4.跳转
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigation animated:YES completion:^{
            
        }];
 
    
    
}

//保存现有联系人实现
- (void)saveExistContact:(UIButton *)btn{
     //1.跳转到联系人选择页面，注意这里没有使用UINavigationController
        CNContactPickerViewController *controller = [[CNContactPickerViewController alloc] init];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:^{
        
        }];
    
}
#pragma mark - CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - CNContactPickerDelegate
//2.实现点选的代理，其他代理方法根据自己需求实现
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    [picker dismissViewControllerAnimated:YES completion:^{
        //3.copy一份可写的Contact对象，不要尝试alloc一类，mutableCopy独此一家
        CNMutableContact *c = [contact mutableCopy];
        //4.为contact赋值
        [self setValue4Contact:c existContect:YES];
        //5.跳转到新建联系人页面
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:c];
        controller.delegate = self;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigation animated:YES completion:^{
        }];
    }];
}
- (void)setValue4Contact:(CNMutableContact *)contact existContect:(BOOL)exist
{
    if (exist == NO) {
//        contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"Icon-114.png"]);
        //设置名字
        contact.givenName = @"jaki";
        //设置姓氏
        contact.familyName = @"张";
        CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:@"316045346@qq.com"];
        CNLabeledValue *workEmail =[CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"316045346@qq.com"];
        contact.emailAddresses = @[homeEmail,workEmail];
        CNMutablePostalAddress * homeAdress = [[CNMutablePostalAddress alloc]init];
        homeAdress.street = @"贝克街";
        homeAdress.city = @"伦敦";
        homeAdress.state = @"英国";
        homeAdress.postalCode = @"221B";
        contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAdress]];
        NSDateComponents * birthday = [[NSDateComponents  alloc]init];
        birthday.day=7;
        birthday.month=5;
        birthday.year=1992;
        contact.birthday=birthday;

    }
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:@"18888888888"]];
    if (!exist) {
        contact.phoneNumbers = @[phoneNumber];
    }
    //现有联系人情况
    else{
        if ([contact.phoneNumbers count] >0) {
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
            [phoneNumbers addObject:phoneNumber];
            contact.phoneNumbers = phoneNumbers;
        }else{
            contact.phoneNumbers = @[phoneNumber];
        }
    }

    //初始化方法
    CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
    //添加联系人
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    CNContactStore * store = [[CNContactStore alloc]init];
    [store executeSaveRequest:saveRequest error:nil];
}

/*
//设置要保存的contact对象
- (void)setValue4Contact:(CNMutableContact *)contact existContect:(BOOL)exist{
    if (!exist) {
        //名字和头像
        contact.nickname = @"oriccheng";
        //        UIImage *logo = [UIImage imageNamed:@"..."];
        //        NSData *dataRef = UIImagePNGRepresentation(logo);
        //        contact.imageData = dataRef;
    }
    //电话,每一个CNLabeledValue都是有讲究的，如何批评，可以在头文件里面查找，这里给出几个常用的，别的我也不愿意去研究
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:@"18888888888"]];
    
    if (!exist) {
        contact.phoneNumbers = @[phoneNumber];
    }
    //现有联系人情况
    else{
        if ([contact.phoneNumbers count] >0) {
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
            [phoneNumbers addObject:phoneNumber];
            contact.phoneNumbers = phoneNumbers;
        }else{
            contact.phoneNumbers = @[phoneNumber];
        }
    }
    
    //网址:CNLabeledValue *url = [CNLabeledValue labeledValueWithLabel:@"" value:@""];
    //邮箱:CNLabeledValue *mail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.poiData4Save.mail];
    
    //特别说一个地址，PostalAddress对应的才是地址
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    address.state = @"辽宁省";
    address.city = @"沈阳市";
    address.postalCode = @"111111";
    //外国人好像都不强调区的概念，所以和具体地址拼到一起
    address.street = @"沈河区惠工街10号";
    //生成的上面地址的CNLabeledValue，其中可以设置类型CNLabelWork等等
    CNLabeledValue *addressLabel = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:address];
    if (!exist) {
        contact.postalAddresses = @[addressLabel];
    }else{
        if ([contact.postalAddresses count] >0) {
            NSMutableArray *addresses = [[NSMutableArray alloc] initWithArray:contact.postalAddresses];
            [addresses addObject:addressLabel];
            contact.postalAddresses = addresses;
        }else{
            contact.postalAddresses = @[addressLabel];
        }
    }
}
 */
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
