//kích hoạt "sau khi cập nhật" các đối tượng Case và gọi phương thức "updateWorkOrders" trong lớp "MaintenanceRequestHelper" chuyển các biến "Trigger.New" và "Trigger.OldMap".
trigger MaintenanceRequest on Case (before update, after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
		//Trình kích hoạt chỉ được kích hoạt khi một đối tượng Trường hợp được cập nhật và quá trình cập nhật diễn ra sau khi các thay đổi đã được thực hiện đối với bản ghi. 
		//Trình kích hoạt được sử dụng để cập nhật lệnh sản xuất liên quan khi đóng trường hợp bảo trì.
        MaintenanceRequestHelper.updateWorkOrders(Trigger.New, Trigger.OldMap);
    }
}