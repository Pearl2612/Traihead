//Tạo một lớp Apex gọi một điểm cuối REST để trả về tên của một con vật, viết các bài kiểm tra đơn vị đạt được mức độ bao phủ mã 100% 
//cho lớp bằng cách sử dụng một phản hồi giả và chạy các bài kiểm tra Apex của bạn.
//Công việc chuẩn bị: Đảm bảo rằng các Trang web Từ xa từ thiết bị đầu tiên đã được thiết lập.
// Create an Apex class:
// Name: AnimalLocator
// Method name: getAnimalNameById
// Phương thức phải chấp nhận một Số nguyên và trả về một Chuỗi.
// Phương thức phải gọi https://th-apex-http-callout.herokuapp.com/animals/<id>, thay thế <id> bằng ID được truyền vào phương thức
// phương thức này trả về giá trị của thuộc tính name (nghĩa là tên động vật)
public class AnimalsCallouts {
    public static HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            // JSON.deserializeUntyped chuyển đổi chuỗi JSON thành đối tượng Apex tương ứng.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(results);
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for(Object animal: animals) {
                System.debug(animal);
            }
        }
        return response;
    }
    public static HttpResponse makePostCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //Thiết lập địa chỉ url yêu cầu
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        //Thiết lập http header thông báo cho máy chủ đích nội dung yêu cầu là 1 json
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //HTTP request body yêu cầu HTTP bằng cách truyền một chuỗi JSON có thuộc tính 'name' là 'mighty moose'.
        request.setBody('{"name":"mighty moose"}');
        //gửi một yêu cầu HTTP Phản hồi HTTP được trả về trong biến response
        HttpResponse response = http.send(request);
        // Parse the JSON response
        // getStatusCode: Lấy mã trạng thái HTTP của phản hồi từ máy chủ
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
        //getStatus()  lấy thông tin trạng thái của phản hồi từ máy chủ 201 Created"
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }        
}