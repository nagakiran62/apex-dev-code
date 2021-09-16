public class InvoiceWrapper {
    public class LineItem {
        public Double unitPrice {get; set;}
        public Double quantity {get; set;}
        public String productName {get; set;}

        public Double getLineItemTotal() {
            return this.unitPrice * this.quantity;
        }
    }

    public class Invoice {
        public Double totalPrice {get; set;}
        public DateTime statementDate {get; set;}
        public String contactnumber {get; set;}
        public List<LineItem> lineItems {get; set;}
        public Integer invoiceNumber {get; set;}
    }

    public List<Invoice> invoiceList {get; set;}
}