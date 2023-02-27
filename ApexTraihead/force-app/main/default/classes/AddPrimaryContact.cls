//Tạo một lớp Apex có thể Queueable để chèn cùng một Liên hệ cho mỗi Tài khoản cho một trạng thái cụ thể.
//Yêu cầu Tạo một lớp Apex có thể xếp hàng để chèn cùng một Contact cho mỗi Account cho một trạng thái cụ thể.
//Create an Apex class:
//  Name: AddPrimaryContact
//  Interface: Queueable
//  Tạo một hàm tạo cho lớp chấp nhận đối số đầu tiên của nó là Contact sObject và đối số thứ hai dưới dạng String cho chữ viết tắt của State
//  Phương thức thực thi phải truy vấn tối đa 200 Account có BillingState được chỉ định bởi tên viết tắt của State
//  Được truyền vào hàm tạo và (chèn bản ghi sObject Contact) được (liên kết với từng Account). Nhìn vào phương thức sObject clone().
//  Sobject (Account, contact, lead,...)
public class AddPrimaryContact implements Queueable {
  private String state;
  private Contact contact;

  public AddPrimaryContact(Contact contact, String state) {
    this.state = state;
    this.contact = contact;
  }

  public void execute(QueueableContext context) {
    //Dell gán state cho random tại vì dell thích => state = random
    List<Account> accounts = [
      SELECT name
      FROM account
      WHERE billingstate = :state
      LIMIT 200
    ];

    List<Contact> contacts = new List<Contact>();
    // Lặp qua từng accounts và truyền vào acc
    for (Account acc : accounts) {
      //Tạo 1 1 bản sao cho đối tương contact
      //Phương thức "clone" sẽ tạo một bản sao của đối tượng Contact
      contact con = contact.clone(false, false, false, false);
      // Thêm con vào danh sách các dối tượng contacts
      contacts.add(con);
    }
    //đẩy dữ liệu lên contacts list
    insert contacts;
  }
}

//demo

// Contact contact = new Contact(
//     FirstName = 'John',
//     LastName = 'Doe',
//     Email = 'johndoe@email.com',
//     Phone = '123-456-7890'
// );

// AddPrimaryContact primaryContact = new AddPrimaryContact(contact, 'CA');
// System.enqueueJob(primaryContact);
// System.debug(primaryContact);

// DEBUG AddPrimaryContact:[contact=Contact:{FirstName=John, LastName=Doe, Email=johndoe@email.com, Phone=123-456-7890}, state=CA]
//Khi phương thức "execute" được gọi trên đối tượng AddPrimaryContact này, nó sẽ tạo ra các bản sao của đối tượng Contact và chèn chúng vào
//Salesforce dựa trên danh sách các Account có BillingState là "CA".

// Nếu, ví dụ, danh sách Account trong Salesforce chứa hai bản ghi với BillingState là "CA", lớp AddPrimaryContact !!sẽ tạo ra hai bản sao của đối tượng Contact
// với các thuộc tính giống nhau nhưng có Id khác nhau và chèn chúng vào Salesforce.!!

