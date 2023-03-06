public with sharing class MaintenanceRequestHelper {
  public static void updateworkOrders(List<Case> updWorkOrders, Map<Id, Case> nonUpdCaseMap) {
    //Set các id của các  yêu cầu bảo trì định kì hoặc sửa chữa đã đóng và được cập nhật trong danh sách upWorkOrders
    Set<Id> validIds = new Set<Id>();
    //Kiểm tra trạng thái của updWorkOrders và danh sách nonUpdCaseMap .Nếu trạng thái của yêu cầu trong danh sách updWorkOrders là Closed và nonUpdCaseMap không phải là Closed
    for (Case c : updWorkOrders) {
      if (nonUpdCaseMap.get(c.Id).Status != 'Closed' && c.Status == 'Closed') {
        //Kiểm tra lại yêu cầu Repair hoặc Routine Maintenance thì sẽ thêm yêu cầu vào set validIds.
        if (c.Type = 'Repair' || c.Type = 'Routine Maintenace') {
          //thêm 1 phần tử mới (Trong trường hợp này là id của 1 yêu cầu bảo trì). Nếu có thì sẽ ko được thêm vào.
          validIds.add(c.Id);
        }
      }
    }
    //Kiểm tra xem validIds có phần tử nào không
    if (!validIds.isEmpty()) {
      //Tạo một List newCases để lưu trữ các yêu cầu bảo trì định kỳ mới và hai Map closedCasesM và maintenanceCycles để lưu trữ thông tin cần thiết cho quá trình tạo yêu cầu bảo trì định kỳ mới.
      List<Case> newCases = new List<Case>();
      Map<Id, Case> closedCasesM = new Map<Id, Case>(
        //Truy vấn các thông tin của các yêu cầu bảo trì định kỳ hoặc sửa chữa đã đóng bằng cách sử dụng Set validIds làm điều kiện truy vấn. Các thông tin này bao gồm Id,
        [
          SELECT
            Id,
            Vehicle__c,
            Equipment__c,
            Equipment__r.Maintenance_Cycle__c,
            (SELECT Id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items__r)
          FROM Case
          WHERE Id IN :validIds
        ]
      );
      //Tạo một Map maintenanceCycles để lưu trữ chu kỳ bảo trì nhỏ nhất của từng yêu cầu bảo trì định kỳ.
      Map<Id, Decimal> maintenanceCycles = new Map<ID, Decimal>();
      AggregateResult[] results = [
        //Thực hiện truy vấn để lấy ra chu kỳ bảo trì nhỏ nhất của các bản ghi con của các yêu cầu bảo trì định kỳ được cập nhật trong danh sách updWorkOrders.
        //Kết quả của truy vấn được lưu trữ trong một mảng AggregateResult results.
        SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) cycle
        FROM Equipment_Maintenance_Item__c
        WHERE Maintenance_Request__c IN :ValidIds
        GROUP BY Maintenance_Request__c
      ];
      //Với mỗi phần tử trong results, lưu trữ chu kỳ bảo trì nhỏ nhất vào Map maintenanceCycles.
      for (AggregateResult ar : results) {
        maintenanceCycles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
      }
      //Sau khi tìm thấy các Case có ID nằm trong Set validIds, đoạn code trên tiếp tục tạo ra các Case mới (newCases) để đăng ký bảo dưỡng định kỳ.
      //Với mỗi Case được tìm thấy, một Case mới (nc) sẽ được tạo ra với các trường giá trị được thiết lập:
      for (Case cc : closedCasesM.values()) {
        Case nc = new Case(
          //ParentId: ID của Case được tìm thấy trước đó
          ParentId = cc.Id,
          //Status: 'New' - Trạng thái mới của Case
          Status = 'New',
          // Subject: 'Routine Maintenance' - Chủ đề của Case mới
          Subject = 'Routine Maintenance',
          //Type: 'Routine Maintenance' - Loại Case mới
          Type = 'Routine Maintenance',
          //Vehicle__c: giá trị của trường Vehicle__c của Case được tìm thấy trước đó
          Vehicle__c = cc.Vehicle__c,
          //Equipment__c: giá trị của trường Equipment__c của Case được tìm thấy trước đó
          Equipment__c = cc.Equipment__c,
          //Origin: 'Web' - Nguồn của Case mới
          Origin = 'Web',
          //Date_Reported__c: Ngày hôm nay
          Date_Reported__c = Date.Today()
        );
        //nếu ID của Case được tìm thấy trước đó có trong Map maintenanceCycles,
        //trường Date_Due__c của Case mới (nc) sẽ được thiết lập bằng cách lấy ngày hôm nay cộng thêm số ngày được lấy từ Map maintenanceCycles
        if (maintenanceCycles.containskey(cc.Id)) {
          nc.Date_Due__c = Date.today().addDays((Integer) maintenanceCycles.get(cc.Id));
        } else {
          //Ngược lại, nếu không có trong Map maintenanceCycles,
          //trường Date_Due__c sẽ được thiết lập bằng cách lấy ngày hôm nay cộng thêm giá trị của trường maintenance_Cycle__c của trường Equipment__r của Case được tìm thấy trước đó.
          nc.Date_Due__c = Date.today().addDays((Integer) cc.Equipment__r.maintenance_Cycle__c);
        }
        //danh sách các Case mới được thêm vào (newCases)
        newCases.add(nc);
      }
      //add vào database
      insert newCases;
      List<Equipment_Maintenance_Item__c> clonedWPs = new List<Equipment_Maintenance_Item__c>();
      //Lặp qua danh sách các Case mới tạo ra (newCases) và tìm các Equipment_Maintenance_Item__c liên quan đến từng Case bằng cách sử dụng trường ParentId để lấy danh sách các Equipment_Maintenance_Item__c từ case tương ứng
      //trong closedCasesM - một bản đồ ánh xạ các ID của Case tới các Case tương ứng.
      for (Case nc : newCases) {
        for (Equipment_Maintenance_Item__c wp : closedCasesM.get(nc.ParentId).Equipment_Maintenance_Items__r) {
          //Lặp qua danh sách các Equipment_Maintenance_Item__c tìm được và tạo một bản sao (clone()) của mỗi Equipment_Maintenance_Item__c này
          Equipment_Maintenance_Item__c wpClone = wp.clone();
          //gán Maintenance_Request__c cho bản sao này bằng Id của Case mới tạo ra.
          wpClone.Maintenance_Request__c = nc.Id;
          //thêm các Equipment_Maintenance_Item__c được sao chép vào danh sách clonedWPs.
          ClonedWPs.add(wpClone);
        }
      }
      //insert các bản ghi trong danh sách clonedWPs vào Salesforce.
      insert ClonedWPs;
    }
  }
}
