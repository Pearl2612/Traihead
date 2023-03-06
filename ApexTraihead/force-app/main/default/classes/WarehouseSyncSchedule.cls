//lên lịch để chạy vào một thời điểm cụ thể
global class WarehouseSyncSchedule implements Schedulable{
    global void execute(System.SchedulableContext context){
        //Phương thức này tạo một yêu cầu HTTP GET tới API bên ngoài và truy xuất danh sách các bản ghi thiết bị. Sau đó, nó ánh xạ dữ liệu đã truy xuất tới các bản ghi Product2 và nâng cấp chúng lên tổ chức Salesforce. 
        //ên lịch chạy lớp WarehouseSyncSchedule trong một khoảng thời gian đã chỉ định, phương thức runWarehouseEquipmentSync sẽ được thực thi tự động, cho phép tổ chức Salesforce duy trì đồng bộ hóa với hệ thống kho hàng bên ngoài.
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}