public virtual class PaymentCustom {
  private String paymentName;
  private Date paymentDate;
  private Double amount;
  private String paymentMethod;
  private User lastModifiedBy;
  private User createdBy;
  // private UserOrGroup owner;
  private Account account;
  // private Class__c paymentClass;
  private String description;

  public PaymentCustom(String paymentName, Date paymentDate, Double amount, String paymentMethod, User lastModifiedBy, User createdBy, Account account, String description) {
    this.paymentName = paymentName;
    this.paymentDate = paymentDate;
    this.amount = amount;
    this.paymentMethod = paymentMethod;
    this.lastModifiedBy = lastModifiedBy;
    this.createdBy= createdBy;
    this.account = account;
    this.description = description;
  }

  // Getter and Setter for paymentName
  public String getPaymentName() {
    return paymentName;
  }
  public void setPaymentName(String paymentName) {
    this.paymentName = paymentName;
  }

  // Getter and Setter for paymentDate
  public Date getPaymentDate() {
    return paymentDate;
  }
  public void setPaymentDate(Date paymentDate) {
    this.paymentDate = paymentDate;
  }

  // Getter and Setter for amount
  public Double getAmount() {
    return amount;
  }
  public void setAmount(Double amount) {
    this.amount = amount;
  }

  // Getter and Setter for paymentMethod
  public String getPaymentMethod() {
    return paymentMethod;
  }
  public void setPaymentMethod(String paymentMethod) {
    this.paymentMethod = paymentMethod;
  }

  // Getter and Setter for lastModifiedBy
  public User getLastModifiedBy() {
    return lastModifiedBy;
  }
  public void setLastModifiedBy(User lastModifiedBy) {
    this.lastModifiedBy = lastModifiedBy;
  }

  // Getter and Setter for createdBy
  public User getCreatedBy() {
    return createdBy;
  }
  public void setCreatedBy(User createdBy) {
    this.createdBy = createdBy;
  }

  // Getter and Setter for owner
  // public UserOrGroup getOwner() {
  //   return owner;
  // }
  // public void setOwner(UserOrGroup owner) {
  //   this.owner = owner;
  // }

  // Getter and Setter for account
  public Account getAccount() {
    return account;
  }
  public void setAccount(Account account) {
    this.account = account;
  }

  // Getter and Setter for paymentClass
  // public Class__c getPaymentClass() {
  //   return paymentClass;
  // }
  // public void setPaymentClass(Class__c paymentClass) {
  //   this.paymentClass = paymentClass;
  // }
  // Getter and Setter for description
  public virtual String getDescription() {
    return description;
  }
  public void setDscription(String description) {
    this.description = description;
  }
}

// Bạn nên khai báo lớp của bạn là ảo (virtual) nếu bạn muốn cho phép lớp con (subclass) kế thừa và ghi đè
// (override) các phương thức (method) hoặc thuộc tính (property) của lớp cha (base class).

// Bạn nên khai báo lớp của bạn là trừu tượng (abstract) nếu bạn muốn cho phép định nghĩa các phương thức (method)
// và thuộc tính (property) mà không cần cung cấp thân hàm (implementation) của chúng. Các lớp con (subclass) sẽ phải cung cấp thân hàm (implementation) cho các phương thức
// và thuộc tính trừu tượng (abstract) này để có thể sử dụng chúng được.

