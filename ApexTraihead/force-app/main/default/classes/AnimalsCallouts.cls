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