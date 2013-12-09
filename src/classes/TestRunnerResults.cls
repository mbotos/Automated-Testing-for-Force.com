global class TestRunnerResults implements Schedulable {
	
   global void execute(SchedulableContext SC) {
   		emailUnprocessedJobStatus();
   }
   
   public static list<Messaging.SingleEmailMessage> emailUnprocessedJobStatus() {
   	  list<Messaging.SingleEmailMessage> messages = new list<Messaging.SingleEmailMessage>();
      
	  list<Test_Runner_Job__c> jobs = getUnprocessedJobs();
	  
	  for (Test_Runner_Job__c job : jobs) {
	      messages.add(TestRunner.emailMethodStatus(job)); 
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