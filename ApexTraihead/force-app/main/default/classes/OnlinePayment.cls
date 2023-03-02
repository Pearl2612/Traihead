public class OnlinePayment extends PaymentCustom {
  private String paymentGateway;

  //Định nghĩa contructor payment
  public OnlinePayment(
    String paymentName,
    Date paymentDate,
    Double amount,
    String paymentMethod,
    User lastModifiedBy,
    User createdBy,
    Account account,
    String description,
    String paymentGateway
  ) {
    super(paymentName, paymentDate, amount, paymentMethod, lastModifiedBy, createdBy, account, description);
    this.paymentGateway = paymentGateway;
    
  }

  public override String getDescription() {
    return 'Online payment of ' + getAmount() + ' via ' + paymentGateway;
  }
}

// Class OnlinePayment kế thừa tất cả các thuộc tính và phương thức của lớp cha Payment,
//  bổ sung thêm thuộc tính paymentGateway đại diện cho cổng thanh toán được sử dụng.
//  Ngoài ra, lớp con còn định nghĩa lại 2 phương thức của lớp cha getDescription() và processPayment() để phù hợp với kiểu thanh toán trực tuyến.

