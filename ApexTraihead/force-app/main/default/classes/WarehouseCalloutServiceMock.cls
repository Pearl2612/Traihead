@isTest
// HTTP Callout Mock. Cụ thể, nó được sử dụng để kiểm thử việc gọi API từ một hệ thống bên ngoài. Lớp này được sử dụng để định nghĩa phản hồi giả từ một API được gọi.
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
  // implement http mock callout
  global static HttpResponse respond(HttpRequest request) {
    System.assertEquals('https://th-superbadge-apex.herokuapp.com/equipment', request.getEndpoint());
    System.assertEquals('GET', request.getMethod());

    // Create a fake response
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(
      '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]'
    );
    response.setStatusCode(200);
    return response;
  }
}
// Phản hồi giả này được sử dụng để thay thế phản hồi thực tế từ API trong quá trình kiểm thử.
