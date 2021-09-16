public class ContactPDFController {

    public ContactPDFController(ApexPages.StandardSetController controller) {
    
    //String fileName = 'FinancialForce'.pdf';
    //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + fileName);
    //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=FinancialForce.pdf');
    
    //sets the no of records manually
    
    controller.setPageSize(10);


    }

}