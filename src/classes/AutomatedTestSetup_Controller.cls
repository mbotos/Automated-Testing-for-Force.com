public with sharing class AutomatedTestSetup_Controller {
	public boolean hasScheduledJobs { get; set; }
	public boolean hasTestRun { get; set; }
	public boolean isRunning { get; set; }
	public boolean isEmailing { get; set; }
	
	public void refreshHasScheduledJobs() {
		integer jobCount = [select count() from CronJobDetail where Name like 'TestRunner%' and JobType = '7'];
		hasScheduledJobs = jobCount == 2;		
	}
	
	public void refreshHasTestRun() {
		integer runCount = [select count() from Automated_Test_Run__c limit 1];
		hasTestRun = runCount > 0;		
	}
	
	public string getTestRunLink() {
		return '/' + Automated_Test_Run__c.SObjectType.getDescribe().getKeyPrefix();
	}
	
	public AutomatedTestSetup_Controller() {
		refreshHasScheduledJobs();
		refreshHasTestRun();
	}
	
	public void scheduleJobs() {
		TestRunner.setup();
		refreshHasScheduledJobs();
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Jobs scheduled'));
	}
	
	public void createTestRun() {
		User currentUser = [select Email from User where Id = :UserInfo.getUserId()];
		insert new Automated_Test_Run__c(Name = 'All Tests', Emails__c = currentUser.Email); 
		refreshHasTestRun();
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Automated Test Run created'));
	}
	
	public void run() {
		TestRunner.enqueueTests();
		isRunning = true;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Tests queued'));
	}
	
	public void email() {
		TestRunnerResults.emailUnprocessedJobStatus();
		isEmailing = true;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Results processed and emailed'));
	}
	
}