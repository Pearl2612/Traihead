//Giao diện Có thể lập lịch cho phép các lớp Apex được lên lịch để chạy vào những thời điểm cụ thể.
global with sharing class WarehouseSyncSchedule implements Schedulable {
  //lớp WarehouseSyncSchedule lấy đối tượng SchedulableContext làm tham số, chứa thông tin về công việc đã lên lịch.
  //Khi phương thức thực thi được gọi, nó sẽ xử lý một công việc mới cho lớp WarehouseCalloutService bằng cách sử dụng phương thức System.enqueueJob().
  global void execute(SchedulableContext ctx) {
    WarehouseCalloutService.runWarehouseEquipmentSync();
  }
}

//setup - apex classes - Schedule Apex - WarehouseSyncSchedule - all time

