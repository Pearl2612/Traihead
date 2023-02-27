// Tạo một lớp thử nghiệm Apex:
// Tên: DailyLeadProcessorTest
// Trong lớp thử nghiệm, hãy chèn 200 bản ghi Khách hàng tiềm năng, lên lịch chạy lớp DailyLeadProcessor và kiểm tra xem tất cả các bản ghi Khách hàng tiềm năng đã được cập nhật chính xác chưa
@isTest
private class DailyLeadProcessorTest {
  //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
  // final fix cảnh báo bảo mật từ khóa static chỉ được sử dụng để định nghĩa các biến tĩnh từ khóa final được sử dụng để chỉ định rằng biến CRON_EXP là một hằng số không thể thay đổi giá trị sau khi được khởi tạo.
  // private Trong Apex, các biến cục bộ chỉ có thể được khai báo là private hoặc không có từ khóa quyền truy cập nào (mặc định là private).
  private static final String CRON_EXP = '0 0 9 * * ? 2023';

  static testMethod void testScheduledJob() {
    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
      Lead lead = new Lead(
        LastName = 'Test ' + i,
        LeadSource = '',
        Company = 'Test Company ' + i,
        Status = 'Open - Not Contacted'
      );
      leads.add(lead);
    }
    insert leads;
    Test.startTest();
    // Schedule the test job
    String jobId = System.schedule('Update LeadSource to DreamForce', CRON_EXP, new DailyLeadProcessor());
    // Stopping the test will run the job synchronously
    Test.stopTest();
    // fix cảnh báo assertEquals của dòng 11 assertEquals(giá trị dự kiến, giá trị cập nhật, thông báo lỗi)
    // Add an assertion here to confirm expected behavior
    List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
    System.assertEquals(
      leads.size(),
      updatedLeads.size(),
      'The number of updated leads does not match the expected value'
    );
  }
}

// Biểu thức Cron 0 0 1 * * ? *được đặt trong biến CRON_EXP là để lập lịch thực hiện một công việc vào lúc 1 giờ sáng (01:00) hàng ngày.

// Giải thích chi tiết các phần tử của biểu thức Cron này:

//     0: phần giây (luôn là 0 trong biểu thức Cron)
//     0: phút (luôn là 0 trong biểu thức Cron)
//     1: giờ (thực hiện vào lúc 1 giờ sáng)
//     *: ngày trong tháng (sử dụng dấu * để chỉ định tất cả các ngày trong tháng)
//     *: tháng (sử dụng dấu * để chỉ định tất cả các tháng trong năm)
//     ?: thứ trong tuần (sử dụng dấu ? khi không quan tâm đến thứ trong tuần)
//     *: năm

// Vì phần tử thứ trong tuần (thứ trong tuần hoặc ngày trong tuần) và ngày trong tháng là hai phần tử có tính chất tương đương nhau, nên trong biểu thức Cron chỉ có thể sử dụng một trong hai phần tử này và dấu ? để chỉ định phần tử còn lại là không quan tâm.

// Với biểu thức Cron này, công việc sẽ được thực hiện vào lúc 1 giờ sáng hàng ngày.

