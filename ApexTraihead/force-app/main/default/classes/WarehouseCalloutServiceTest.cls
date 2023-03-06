@isTest
//test cho phương thức runWarehouseEquipmentSync()
//trong class WarehouseCalloutService dùng để gọi API từ một hệ thống bên ngoài để lấy thông tin thiết bị và cập nhật vào hệ thống Salesforce.
// /Trong đoạn code test này, ta sử dụng lớp WarehouseCalloutServiceMock để tạo một mock callout giả lập cho phương thức gọi API. T
private class WarehouseCalloutServiceTest {
  @isTest
  static void testWareHouseCallout() {
    Test.startTest();
    // implement mock callout test here
    //Trong phần setup của test, ta sử dụng Test.setMock() để set mock callout cho phương thức.
    Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
    //Test sẽ kiểm tra xem khi gọi phương thức runWarehouseEquipmentSync() với mock callout này, có sản phẩm nào được tạo ra trong Salesforce không
    WarehouseCalloutService.runWarehouseEquipmentSync();
    Test.stopTest();
    System.assertEquals(1, [SELECT COUNT() FROM Product2]);
  }
}
