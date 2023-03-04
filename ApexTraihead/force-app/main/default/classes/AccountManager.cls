//Tạo một lớp Apex
//Tên: Quản lý tài khoản
//Lớp phải có một phương thức gọi là getAccount
//Phương thức phải được chú thích bằng @HttpGet và trả về một đối tượng Tài khoản
//Phương thức phải trả lại ID và Tên cho bản ghi được yêu cầu và tất cả các liên hệ được liên kết với ID và Tên của họ
//@RestResource chú thích được sử dụng để chỉ định ánh xạ URL cho điểm cuối. "https://example.salesforce.com", then the endpoint can be accessed using a URL like "https://example.salesforce.com/services/apexrest/Account/001XXXXXXXXXXXX/contacts"
//Chú thích @HttpGet chỉ định rằng điểm cuối hỗ trợ các yêu cầu HTTP GET. 
@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager{
    @HttpGet
    global static Account getAccount(){
        RestRequest req = RestContext.request;
        String accId = req.requestURI.substringBetween('Accounts/', '/contacts');
        Account acc = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) 
                       FROM Account WHERE Id = :accId];
        
        return acc;
    }
}

//test api web 
//https://workbench.developerforce.com/restExplorer.php
//Rest explorer
//Get
// /services/apexrest/Accounts/0012w00001JhhEqAAJ/contacts/
// with account Dickenson plc