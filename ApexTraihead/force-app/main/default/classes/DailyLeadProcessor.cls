// Tạo một lớp Apex triển khai giao diện Có thể lập lịch để cập nhật các bản ghi Khách hàng tiềm năng với một Nguồn khách hàng tiềm năng cụ thể. (Điều này rất giống với những gì
// bạn đã làm với Batch Apex.)
// Tạo một lớp Apex:
// Tên: DailyLeadProcessor
// Giao diện: Schedulable
// Phương thức thực thi phải tìm 200 bản ghi lead(Khách hàng tiềm năng) đầu tiên có trường Nguồn khách hàng tiềm năng trống và cập nhật chúng với giá trị Nguồn khách hàng tiềm năng của Dreamforce
// Tạo một lớp thử nghiệm Apex:
// Tên: DailyLeadProcessorTest
// Trong lớp thử nghiệm, hãy chèn 200 bản ghi Khách hàng tiềm năng, lên lịch chạy lớp DailyLeadProcessor và kiểm tra xem tất cả các bản ghi Khách hàng tiềm năng đã được cập nhật chính xác chưa

//with sharing fix lỗi cảnh báo bảo mật
public with sharing class DailyLeadProcessor implements Schedulable {
  public void execute(SchedulableContext ctx) {
	//kiểm tra xem người dùng hiện tại có quyền truy cập đối tượng Lead hay không trước khi thực hiện truy vấn. Nếu người dùng không có quyền truy cập đối tượng này, truy vấn sẽ không được thực hiện.
    if (Schema.sObjectType.Lead.isUpdateable()) {
      List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = NULL];

      if (!leads.isEmpty()) {
        for (Lead l : leads) {
          l.LeadSource = 'Dreamforce';
        }
        update leads;
      }
    }
  }
}
