public class calculator {
 public Integer xvalue {get;set;}
    public Integer yvalue {get;set;}
    public Integer result {get;set;}
    
     public pagereference sub() {
        result = xvalue-yvalue;
        //operation = 'Subtraction';
        return null;
    }
    public pagereference add() {
        result = xvalue+yvalue;
        //operation = 'Addition';
        return null;
    }
    public pagereference mul() {
        result = xvalue*yvalue;
        //operation = 'Multiplication';
        return null;
    }
}