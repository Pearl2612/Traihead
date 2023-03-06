public with sharing class WarehouseCalloutService implements Queueable {
  //1 biến static final WAREHOUSE_URL
  private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
  //bất đồng bộ thực hiện 1 yêu cầu http get đến địa chỉ WAREHOUSE_URL.
  @future(callout=true)
  public static void runWarehouseEquipmentSync() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(WAREHOUSE_URL);
    request.setMethod('GET');
    //Kết quả trả về là một đối tượng HttpResponse được lưu trữ trong biến "response".
    //Dữ liệu phản hồi được đọc từ "response" bằng cách sử dụng phương thức "getBody" và được phân tích cú pháp thành một đối tượng danh sách JSON không kiểu hóa.
    HttpResponse response = http.send(request);
    //tạo một đối tượng "Product2" mới và map các trường dữ liệu trong đối tượng JSON vào đối tượng "Product2"
    //Các trường dữ liệu được ánh xạ gồm Replacement Part, Name, Maintenance Cycle, Lifespan Months, Cost, Warehouse SKU, Current Inventory và Product Code.
    //Các đối tượng "Product2" được tạo ra từ dữ liệu được nhận được được thêm vào danh sách "warehouseEq".
    List<Product2> warehouseEq = new List<Product2>();

    if (response.getStatusCode() == 200) {
      //nội dung phản hồi được giải tuần tự hóa thành một danh sách các đối tượng chưa được nhập bằng cách sử dụng phương thức JSON.deserializeUntyped().
      //Sau đó, mã sẽ lặp qua từng bản ghi thiết bị trong danh sách và ánh xạ các trường JSON tới các trường tương ứng trong đối tượng Product2.
      List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
      // được đưa vào để ghi nhật ký nội dung phản hồi do lệnh gọi API bên ngoài trả về vào nhật ký gỡ lỗi trong Salesforce
      System.debug(response.getBody());

      //lặp qua từng đối tượng JSON trong danh sách jsonResponse và tạo bản ghi Product2 mới cho từng đối tượng
      for (Object eq : jsonResponse) {
        //sử dụng lớp Map<String, Object> để trích xuất các giá trị từ mỗi đối tượng JSON bằng cách sử dụng các cặp khóa-giá trị trong JSON
        Map<String, Object> mapJson = (Map<String, Object>) eq;
        Product2 myEq = new Product2();
        //gán các giá trị này cho các trường tương ứng của bản ghi Product2.
        myEq.Replacement_Part__c = (Boolean) mapJson.get('replacement');
        myEq.Name = (String) mapJson.get('name');
        myEq.Maintenance_Cycle__c = (Integer) mapJson.get('maintenanceperiod');
        myEq.Lifespan_Months__c = (Integer) mapJson.get('lifespan');
        myEq.Cost__c = (Integer) mapJson.get('cost');
        myEq.Warehouse_SKU__c = (String) mapJson.get('sku');
        myEq.Current_Inventory__c = (Double) mapJson.get('quantity');
        myEq.ProductCode = (String) mapJson.get('_id');
        //thêm từng bản ghi Product2 vào danh sách warehouseEq.
        warehouseEq.add(myEq);
      }

      if (warehouseEq.size() > 0) {
        //Khi tất cả các đối tượng JSON đã được xử lý, danh sách này được chuyển đến câu lệnh upsert DML để chèn hoặc cập nhật các bản ghi trong Salesforce.
        upsert warehouseEq;
        System.debug('Your equipment was synced with the warehouse one');
      }
    }
  }

  public static void execute(QueueableContext context) {
    runWarehouseEquipmentSync();
  }
}
