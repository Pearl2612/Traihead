//Tạo một lớp thử nghiệm Apex:
//Tên: AddPrimaryContactTest
//Trong lớp thử nghiệm, hãy chèn 50 bản ghi Tài khoản cho BillingState NY
// và 50 bản ghi Tài khoản cho BillingState CA
//Tạo một phiên bản của lớp AddPrimaryContact, xếp hàng đợi công việc
//và xác nhận rằng một bản ghi Liên hệ đã được chèn cho mỗi trong số 50 Tài khoản có BillingState của CA
@isTest
public class AddPrimaryContactTest {
  @TestSetup
  static void setupTest() {
    List<Account> accounts = new List<Account>();
    //add 50 NY account
    for (Integer i = 0; i < 50; i++) {
      accounts.add(new Account(Name = 'NY', BillingState = 'NY'));
    }
    //add 50 CA account
    for (Integer i = 0; i < 50; i++) {
      accounts.add(new Account(Name = 'CA' + i, BillingState = 'CA'));
    }
    insert accounts;
  }
  static testMethod void testQueueable() {
    Contact a = new Contact(LastName = 'mary', Firstname = 'rose');
    Test.startTest();
    AddPrimaryContact updater = new AddPrimaryContact(a, 'CA');
    System.enqueueJob(updater);
    Test.stopTest();
    System.assertEquals(
      50,
      [
        SELECT COUNT()
        FROM Contact
        WHERE LastName = 'mary' AND FirstName = 'rose'
      ]
    );
  }
}

//System.assertEquals(50, [SELECT count() FROM Contact WHERE LastName = 'mary' AND FirstName= 'rose']);
//Đoạn mã này là một lệnh Assert trong Salesforce Apex để kiểm tra xem có bao nhiêu bản ghi Contact trong Salesforce có Họ là "mary" và Tên là "rose". Cụ thể là đoạn mã sẽ so sánh kết quả truy vấn SELECT với số nguyên 50.
//Nếu kết quả truy vấn SELECT trả về chính xác 50 bản ghi thỏa mãn điều kiện tìm kiếm,
//thì lệnh Assert này sẽ không làm gì cả và test case được coi là "pass". Ngược lại, nếu kết quả truy vấn không trả về 50 bản ghi thỏa mãn điều kiện tìm kiếm, lệnh Assert này sẽ báo lỗi và test case sẽ bị coi là "fail".
//Lệnh Assert trong Salesforce Apex được sử dụng để xác nhận tính đúng đắn của kết quả
//trả về từ một phương thức hoặc truy vấn.

