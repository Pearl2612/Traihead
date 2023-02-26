//Tạo một lớp thử nghiệm Apex:
//Tên: AddPrimaryContactTest
//Trong lớp thử nghiệm, hãy chèn 50 bản ghi Tài khoản cho BillingState NY
// và 50 bản ghi Tài khoản cho BillingState CA
//Tạo một phiên bản của lớp AddPrimaryContact, xếp hàng đợi công việc 
//và xác nhận rằng một bản ghi Liên hệ đã được chèn cho mỗi trong số 50 Tài khoản có BillingState của CA
@isTest 
public class AddPrimaryContactTest {
@TestSetup
static void setupTest(){
    List<Account> accounts = new List<Account>();
    //add 50 NY account
    for(Integer i = 0; i < 50; i++) {
        accounts.add(new Account(Name='NY', BillingState='NY'));
    }
    //add 50 CA account
    for(Integer i = 0; i < 50; i++) {
        accounts.add(new Account(Name='CA' + i, BillingState='CA'));
    }
    insert accounts;
}
static testMethod void testQueueable() {
    Contact a = new Contact(LastName='mary', Firstname = 'rose');
    Test.startTest();
    AddPrimaryContact updater = new AddPrimaryContact(a, 'CA');
    System.enqueueJob(updater);
    Test.stopTest();
    System.assertEquals(50, [SELECT count() FROM Contact WHERE LastName = 'mary' AND FirstName= 'rose']);
}
}