@isTest
private class AnimalsCalloutsTest {
    @isTest static  void testGetCallout() {
        // Create the mock response based on a static resource
        // StaticResourceCalloutMock: giả lập việc gọi các yêu cầu HTTP và trả về phản hồi tương ứng 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //setStaticResource: tên
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        // setMock để thiết lập một giả lập cho cuộc gọi GET và POST bằng cách truyền một instance của lớp AnimalsCalloutsMock đã được định nghĩa vào phương thức setMock của lớp Test. Điều này cho phép chúng ta kiểm tra xem lớp AnimalsCallouts có xử lý kết quả trả về từ giả lập một cách chính xác hay không.
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        HttpResponse result = AnimalsCallouts.makeGetCallout();
        // Verify mock response is not null
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        // Verify status code
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
        System.assertEquals('application/json;charset=UTF-8',
          result.getHeader('Content-Type'),
          'The content type value is not expected.');  
        // Verify the array contains 3 items     
        Map<String, Object> results = (Map<String, Object>) 
            JSON.deserializeUntyped(result.getBody());
        List<Object> animals = (List<Object>) results.get('animals');
        System.debug(animals);
        System.assertEquals(3, animals.size(), 'The array should only contain 3 items.');          
    }   
}