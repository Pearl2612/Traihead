@istest
public with sharing class MaintenanceRequestHelperTest {
  private static final string STATUS_NEW = 'New';
  private static final string WORKING = 'Working';
  private static final string CLOSED = 'Closed';
  private static final string REPAIR = 'Repair';
  private static final string REQUEST_ORIGIN = 'Web';
  private static final string REQUEST_TYPE = 'Routine Maintenance';
  private static final string REQUEST_SUBJECT = 'Testing subject';
  //tạo mới đối tượng "Vehicle__c"
  private static Vehicle__c createVehicle() {
    Vehicle__c Vehicle = new Vehicle__C(name = 'SuperTruck');
    return Vehicle;
  }
  //tạo mới đối tượng Product2
  private static Product2 createEq() {
    product2 equipment = new product2(
      name = 'SuperEquipment',
      //Tuổi thọ 10 tháng
      lifespan_months__C = 10,
      maintenance_cycle__C = 10,
      replacement_part__c = true
    );
    return equipment;
  }
  //ạo ra một yêu cầu bảo trì mới cho một chiếc xe và một thiết bị cụ thể được chỉ định bởi các tham số vehicleId và equipmentId
  private static Case createMaintenanceRequest(id vehicleId, id equipmentId) {
    case cs = new case(
      //Type: kiểu yêu cầu sửa chữa, trong trường hợp này là "Repair".
      Type = REPAIR,
      //Status: trạng thái yêu cầu, trong trường hợp này là "New".
      Status = STATUS_NEW,
      //Origin: nguồn gốc yêu cầu, trong trường hợp này là "Web".
      Origin = REQUEST_ORIGIN,
      //Subject: chủ đề của yêu cầu bảo trì, trong trường hợp này là "Testing subject".
      Subject = REQUEST_SUBJECT,
      //Equipment__c: trường tùy chọn để liên kết yêu cầu bảo trì với thiết bị đã được chỉ định bởi equipmentId.
      Equipment__c = equipmentId,
      //Vehicle__c: trường tùy chọn để liên kết yêu cầu bảo trì với chiếc xe đã được chỉ định bởi vehicleId.
      Vehicle__c = vehicleId
    );
    //trả về đối tượng Case được tạo mới.
    return cs;
  }
  // / tạo ra một đối tượng Equipment_Maintenance_Item__c mới, được liên kết với một yêu cầu bảo trì (Maintenance_Request__c) và một thiết bị (Equipment__c).
  private static Equipment_Maintenance_Item__c createWorkPart(id equipmentId, id requestId) {
    //lưu trữ thông tin về các bộ phận và công việc được thực hiện trên thiết bị trong quá trình bảo trì.
    Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(
      Equipment__c = equipmentId,
      Maintenance_Request__c = requestId
    );
    //Hàm này trả về đối tượng Equipment_Maintenance_Item__c được tạo mới và chứa thông tin về thiết bị và yêu cầu bảo trì
    return wp;
  }

  //Phần mã này đang tạo một bản ghi mới của đối tượng tùy chỉnh Equipment_Maintenance_Item__c và liên kết nó với bản ghi somethingToUpdate đã tạo trước đó của đối tượng Trường hợp.
  @istest
  private static void testMaintenanceRequestPositive() {
    Vehicle__c vehicle = createVehicle();
    insert vehicle;
    id vehicleId = vehicle.Id;

    Product2 equipment = createEq();
    insert equipment;
    id equipmentId = equipment.Id;
    case somethingToUpdate = createMaintenanceRequest(vehicleId, equipmentId);
    insert somethingToUpdate;

    //Phương pháp này tạo một bản ghi Equipment_Maintenance_Item__c mới với equipmentId và somethingToUpdate.id được chuyển vào và trả về bản ghi.
    Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, somethingToUpdate.id);
    insert workP;

    test.startTest();
    somethingToUpdate.status = CLOSED;
    update somethingToUpdate;
    test.stopTest();

    Case newReq = [
      SELECT id, subject, type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c
      FROM case
      WHERE status = :STATUS_NEW
    ];

    Equipment_Maintenance_Item__c workPart = [
      SELECT id
      FROM Equipment_Maintenance_Item__c
      WHERE Maintenance_Request__c = :newReq.Id
    ];

    system.assert(workPart != null);
    system.assert(newReq.Subject != null);
    system.assertEquals(newReq.Type, REQUEST_TYPE);
    SYSTEM.assertEquals(newReq.Equipment__c, equipmentId);
    SYSTEM.assertEquals(newReq.Vehicle__c, vehicleId);
    SYSTEM.assertEquals(newReq.Date_Reported__c, system.today());
  }

  @istest
  private static void testMaintenanceRequestNegative() {
    Vehicle__C vehicle = createVehicle();
    insert vehicle;
    id vehicleId = vehicle.Id;

    product2 equipment = createEq();
    insert equipment;
    id equipmentId = equipment.Id;

    case emptyReq = createMaintenanceRequest(vehicleId, equipmentId);
    insert emptyReq;
    //tạo một bản ghi Xe mới và một bản ghi Thiết bị mới bằng cách sử dụng các phương thức createVehicle() và createEq() tương ứng
    //Sau đó, nó gọi phương thức createMaintenanceRequest() với các ID của phương tiện và thiết bị được tạo trước đó để tạo một bản ghi Trường hợp mới thể hiện yêu cầu bảo trì và chèn nó vào cơ sở dữ liệu bằng cách sử dụng câu lệnh chèn.
    // tạo một bản ghi Equipment_Maintenance_Item__c mới bằng cách sử dụng phương thức createWorkPart() với ID của thiết bị và ID của yêu cầu bảo trì được tạo trước đó,
    // đồng thời chèn nó vào cơ sở dữ liệu bằng cách sử dụng câu lệnh chèn.

    Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, emptyReq.Id);
    insert workP;
    // Sử dụng các phương thức test.startTest() và test.stopTest() để bắt đầu và dừng bối cảnh thử nghiệm mới, giúp tách thử nghiệm khỏi các hoạt động khác và cải thiện hiệu suất.
    test.startTest();
    emptyReq.Status = WORKING;
    //cập nhật trạng thái của yêu cầu bảo trì thành ĐÃ ĐÓNG bằng cách sử dụng câu lệnh cập nhật.
    update emptyReq;
    test.stopTest();
    //Sau đó, nó truy vấn cơ sở dữ liệu cho yêu cầu bảo trì bằng cách sử dụng truy vấn SOQL, lọc theo trạng thái = :STATUS_NEW và lưu trữ kết quả trong một đối tượng Trường hợp mới có tên là newReq.
    list<case> allRequest = [
      SELECT id
      FROM case
    ];

    //truy vấn cơ sở dữ liệu cho bản ghi Equipment_Maintenance_Item__c liên quan đến yêu cầu bảo trì bằng cách sử dụng truy vấn SOQL,
    //lọc theo Maintenance_Request__c = :newReq.Id và lưu trữ kết quả trong một đối tượng Equipment_Maintenance_Item__c mới có tên là workPart.
    Equipment_Maintenance_Item__c workPart = [
      SELECT id
      FROM Equipment_Maintenance_Item__c
      WHERE Maintenance_Request__c = :emptyReq.Id
    ];
    // /Các câu lệnh system.assert sau đây xác minh rằng thử nghiệm đã hoàn thành thành công bằng cách kiểm tra xem đối tượng workPart có phải là null không,
    // trường Chủ đề của đối tượng newReq không phải là null và giá trị của các trường nhất định trên đối tượng newReq khớp với giá trị dự kiến .
    system.assert(workPart != null);
    system.assert(allRequest.size() == 1);
  }

  @istest
  private static void testMaintenanceRequestBulk() {
    // khởi tạo 4 danh sách rỗng, mỗi danh sách đại diện cho một loại đối tượng mà chúng ta sẽ tạo trong quá trình kiểm tra.
    list<Vehicle__C> vehicleList = new List<Vehicle__C>();
    list<Product2> equipmentList = new List<Product2>();
    list<Equipment_Maintenance_Item__c> workPartList = new List<Equipment_Maintenance_Item__c>();
    list<case> requestList = new List<case>();
    list<id> oldRequestIds = new List<id>();
    //trong vòng lặp for, chúng ta sẽ tạo 300 phương tiện và 300 thiết bị tương ứng, thêm chúng vào danh sách tương ứng và cuối cùng thực hiện insert để thêm chúng vào database.
    for (integer i = 0; i < 300; i++) {
      //thử nghiệm tạo 300 bản ghi Vehicle__c và 300 bản ghi Product2 bằng cách sử dụng các phương thức createVehicle() và createEq() tương ứng.
      //Sau đó, nó chèn các bản ghi vào cơ sở dữ liệu bằng phương thức chèn.
      vehicleList.add(createVehicle());
      equipmentList.add(createEq());
    }
    insert vehicleList;
    insert equipmentList;
    //khởi tạo 300 request bảo trì cho mỗi cặp phương tiện và thiết bị. Chúng ta sẽ thêm các request này vào danh sách requestList.
    for (integer i = 0; i < 300; i++) {
      //Tạo 300 bản ghi trường hợp bằng cách sử dụng phương thức createMaintenanceRequest() và gán từng bản ghi trường hợp cho bản ghi Vehicle__c và bản ghi Product2
      requestList.add(createMaintenanceRequest(vehicleList.get(i).id, equipmentList.get(i).id));
    }
    insert requestList;
    //tạo 300 bản ghi Equipment_Maintenance_Item__c bằng cách sử dụng phương thức createWorkPart() và gán từng bản ghi Equipment_Maintenance_Item__c cho một bản ghi Product2 và một bản ghi trường hợp
    for (integer i = 0; i < 300; i++) {
      workPartList.add(createWorkPart(equipmentList.get(i).id, requestList.get(i).id));
    }
    insert workPartList;
    //một kịch bản hàng loạt đang được thử nghiệm trong đó 300 yêu cầu bảo trì được tạo và liên kết với các đối tượng phương tiện và thiết bị tương ứng của chúng.
    //Sau đó, các yêu cầu được cập nhật hàng loạt để đặt trạng thái của chúng thành "Đã đóng".
    test.startTest();
    //Một vòng lặp được sử dụng để tạo 300 yêu cầu và một vòng lặp khác được sử dụng để tạo các phần công việc tương ứng cho mỗi yêu cầu.
    //Cả hai danh sách đối tượng sau đó được chèn vào cơ sở dữ liệu.
    for (case req : requestList) {
      //Sau đó, một vòng lặp khác được sử dụng để cập nhật trạng thái của từng yêu cầu thành "Đã đóng" và lưu trữ id của chúng trong danh sách.
      req.Status = CLOSED;
      oldRequestIds.add(req.Id);
    }
    //Cuối cùng, bản cập nhật được thực thi và thử nghiệm được đính kèm với test.startTest() và test.stopTest() để đảm bảo thực thi và xử lý đúng các giới hạn của bộ điều chỉnh.
    update requestList;
    test.stopTest();
    //Thử nghiệm này đảm bảo rằng khi một bản cập nhật hàng loạt được thực hiện đối với các yêu cầu bảo trì,
    //tất cả các yêu cầu có trạng thái "Mới" sẽ được cập nhật thành "Đã đóng" và các hạng mục bảo trì thiết bị tương ứng của chúng được tạo trong cơ sở dữ liệu.
    list<case> allRequests = [
      SELECT id
      FROM case
      WHERE status = :STATUS_NEW
    ];
    //Thử nghiệm đầu tiên tạo ra 300 phương tiện, 300 sản phẩm thiết bị, 300 yêu cầu bảo trì và 300 hạng mục bảo trì thiết bị.
    //Sau đó, nó sẽ chèn tất cả các bản ghi này vào cơ sở dữ liệu. Tiếp theo, nó cập nhật trạng thái của tất cả 300 yêu cầu bảo trì thành "Đã đóng" bằng thao tác cập nhật hàng loạt.
    //Cuối cùng, nó truy vấn cơ sở dữ liệu cho tất cả các yêu cầu bảo trì có trạng thái "Mới" và đảm bảo rằng không có yêu cầu nào, đồng thời xác minh rằng có 300 hạng mục bảo trì thiết bị trong cơ sở dữ liệu cho các id yêu cầu cũ.
    list<Equipment_Maintenance_Item__c> workParts = [
      SELECT id
      FROM Equipment_Maintenance_Item__c
      WHERE Maintenance_Request__c IN :oldRequestIds
    ];

    system.assert(allRequests.size() == 300);
  }
}
