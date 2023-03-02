// Create an Apex class:

//     Name: AddPrimaryContact
//     Interface: Queueable
//     Create a constructor for the class that accepts as its first argument a Contact sObject and a second argument as a string for the State abbreviation
//     The execute method must query for a maximum of 200 Accounts with the BillingState specified by the State abbreviation passed into the constructor and insert the Contact sObject record associated to each Account. Look at the sObject clone() method.

// Create an Apex test class:

//     Name: AddPrimaryContactTest
//     In the test class, insert 50 Account records for BillingState NY and 50 Account records for BillingState CA
//     Create an instance of the AddPrimaryContact class, enqueue the job, and assert that a Contact record was inserted for each of the 50 Accounts with the BillingState of CA
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

