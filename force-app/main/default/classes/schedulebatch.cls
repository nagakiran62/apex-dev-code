global class schedulebatch implements schedulable{

   global void execute(Schedulablecontext sc)
          {
             batchtrigger bb = new batchtrigger ();
             Database.executeBatch(bb,200);
          }

}