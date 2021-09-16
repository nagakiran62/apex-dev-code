@isTest
private class excelHelper_Tests {

    static TestMethod void excelHelper_Tests_UnitTest(){
        Show__c testShow = new Show__c();
        testShow.Name = 'Test';
        insert testShow;

        Test.startTest();
            excelHelper.getAtlMemo(testShow.Id);
            excelHelper.getAtlBreakdown(testShow.Id);
            excelHelper.getCashflow(testShow.Id);
            excelHelper.getGuildUnionForm(testShow.Id);
            excelHelper.getNetworkContactList(testShow.Id);
            excelHelper.getNetworkDistributionList(testShow.Id);
            excelHelper.getPackageFeeCalculation(testShow.Id);
            excelHelper.getSAGAFTRAFinalCastList(testShow.Id);
            excelHelper.getWGAWeeklyWorkList(testShow.Id);
        Test.stopTest();
    }

}