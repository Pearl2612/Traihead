//Tạo một lớp Apex có thể Queueable để chèn cùng một Liên hệ cho mỗi Tài khoản cho một trạng thái cụ thể.
//Yêu cầu Tạo một lớp Apex có thể xếp hàng để chèn cùng một Contact cho mỗi Account cho một trạng thái cụ thể.
    //Create an Apex class:
    //  Name: AddPrimaryContact
    //  Interface: Queueable
    //  Tạo một hàm tạo cho lớp chấp nhận đối số đầu tiên của nó là Contact sObject và đối số thứ hai dưới dạng String cho chữ viết tắt của State
    //  Phương thức thực thi phải truy vấn tối đa 200 Account có BillingState được chỉ định bởi tên viết tắt của State
    //  được truyền vào hàm tạo và chèn bản ghi sObject Contact được liên kết với từng Account. Nhìn vào phương thức sObject clone().

public class AddPrimaryContact implements Queueable {
	    
    private String st;
    private Contact primecontact;
    
    public AddPrimaryContact(Contact aContact, String aState) {
        this.st=aState;
        this.primecontact = aContact;
    }

    public void execute(QueueableContext context) {
		
        List<Account> accounts = [select name from account where billingstate=:st LIMIT 200];
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
           contact con=primecontact.clone(false,false,false,false);
           contacts.add(con);
        }
        insert contacts;
    }
}

