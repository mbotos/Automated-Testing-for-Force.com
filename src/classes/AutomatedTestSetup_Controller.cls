public with sharing class AutomatedTestSetup_Controller {
	public void scheduleJobs() {
		TestRunner.setup();
	}
	
	public void createTestRun() {
		User currentUser = [select Email from User where Id = :UserInfo.getUserId()];
		insert new Automated_Test_Run__c(Name = 'All Tests', Emails__c = currentUser.Email); 
	}
	
	public void run() {
		TestRunner.enqueueTests();
	}
	
	public void email() {
		TestRunnerResults.emailUnprocessedJobStatus();
	}
	
	static testMethod void test() {
		AutomatedTestSetup_Controller controller = new AutomatedTestSetup_Controller();
		controller.scheduleJobs();
		controller.createTestRun();
		controller.run();
		controller.email();
	}
}