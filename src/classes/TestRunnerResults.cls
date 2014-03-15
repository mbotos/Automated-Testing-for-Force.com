global class TestRunnerResults implements Schedulable {
	
   global void execute(SchedulableContext SC) {
   		emailUnprocessedJobStatus();
   }
   
   public static list<Messaging.SingleEmailMessage> emailUnprocessedJobStatus() {
	  list<Test_Runner_Job__c> jobs = getUnprocessedJobs();
	  
   	  list<Messaging.SingleEmailMessage> messages = TestRunner.emailMethodStatus(jobs);
      
	  for (Test_Runner_Job__c job : jobs) {
	      job.Processed__c = true;
	  }
	  
	  update jobs;
	  
	  return messages;
   }
   
   public static list<Test_Runner_Job__c> getUnprocessedJobs() {
   		return [Select t.Name, 
	      t.Automated_Test_Run__r.Emails__c, 
	      t.Automated_Test_Run__r.Email_on_Pass__c, 
	      t.Automated_Test_Run__r.Name, 
	      t.Automated_Test_Run__c 
	      From Test_Runner_Job__c t where Processed__c = false];
   }
   
}