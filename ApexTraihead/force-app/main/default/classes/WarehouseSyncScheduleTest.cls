@isTest
public class WarehouseSyncScheduleTest {
  @isTest
  static void WarehousescheduleTest() {
    //Trả về một phản hồi giả cho yêu cầu HTTP do lớp WarehouseSyncSchedule thực hiện. Sau đó, nó lên lịch cho lớp WarehouseSyncSchedule để chạy vào một thời điểm cụ thể (1:00 sáng)
    String scheduleTime = '00 00 01 * * ?';
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
    //bằng cách sử dụng phương thức System.schedule.
    String jobID = System.schedule('Warehouse Time To Schedule to Test', scheduleTime, new WarehouseSyncSchedule());
    Test.stopTest();
    //Contains schedule information for a scheduled job. CronTrigger is similar to a cron job on UNIX systems.
    // This object is available in API version 17.0 and later.
    //xác minh rằng một đối tượng CronTrigger đã được tạo cho công việc đã lên lịch với ID công việc dự kiến ​​bằng cách sử dụng câu lệnh SELECT và phương thức System.assertEquals
    CronTrigger a = [SELECT Id FROM CronTrigger WHERE NextFireTime > today];
    System.assertEquals(jobID, a.Id, 'Schedule ');
  }
}
