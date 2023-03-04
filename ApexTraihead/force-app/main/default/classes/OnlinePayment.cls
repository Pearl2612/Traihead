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


