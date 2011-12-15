@isTest
private class TestRunner_Test {
	static Automated_Test_Run__c run;
	static Test_Runner_Job__c job;
	
	static {
		run = new Automated_Test_Run__c(Name = 'Test Automated Run', Excluded_Classes__c = 'TestRunner, Foo', Emails__c = 'test@test.com');
		insert run;
		
		job = new Test_Runner_Job__c(Name = 'Test', Automated_Test_Run__c = run.Id);
		insert job;
		
		job = [Select t.Name, t.Automated_Test_Run__r.Emails__c, t.Automated_Test_Run__r.Name, t.Automated_Test_Run__c From Test_Runner_Job__c t where t.Id = :job.Id];
	}
   
    
    public static testMethod void enqueueTestsCreatesJobs() {
    	System.assertEquals(0, TestRunner.enqueueTests().size(), 'Tests should not be queued during a test');
    }
    
	public static testMethod void emailCreatedForAllPassing() {
		Messaging.SingleEmailMessage mail = TestRunner.emailMethodStatus(job);
		
		System.assert(mail.getSubject().contains(run.Name), 'Run name not in subject');
		
		set<string> emails = new set<string>();
		emails.addAll(mail.getToAddresses());
		System.assert(emails.contains(run.Emails__c), 'Run emails not in mail');
		
		System.assert(!mail.getHtmlBody().contains('Test Failures'), 'Failures appear for passing tests');
	}
	
	public static testMethod void emailCreatedForFailures() {
		list<ApexTestResult> results = new list<ApexTestResult>();
		ApexTestResult result = new ApexTestResult(Outcome = 'Fail', ApexClass = [select Id, Name from ApexClass limit 1], MethodName = 'TestMethod', Message  = 'Test Message', StackTrace = 'Test Stack Trace'); 
		
		results.add(result);
		Messaging.SingleEmailMessage mail = TestRunner.emailMethodStatus(job, results);		
		
		System.assert(mail.getHtmlBody().contains(result.Message), 'No message for failures');				
	}
	
	public static testMethod void testRunnerResultsProcessesJobs() {
		System.assert(TestRunnerResults.emailUnprocessedJobStatus()[0].Processed__c, 'Job not marked processed');
	}
}