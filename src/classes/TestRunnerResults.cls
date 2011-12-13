global class TestRunnerResults implements Schedulable {
	
   global void execute(SchedulableContext SC) {
   		emailUnprocessedJobStatus();
   }
   
   public static list<Test_Runner_Job__c> emailUnprocessedJobStatus() {
      list<Test_Runner_Job__c> jobs = [Select t.Name, t.Automated_Test_Run__r.Emails__c, t.Automated_Test_Run__r.Name, t.Automated_Test_Run__c From Test_Runner_Job__c t where Processed__c = false];
      
      for (Test_Runner_Job__c job : jobs) {
	      TestRunner.emailMethodStatus(job); 
	      job.Processed__c = true;
      }
      
      update jobs;
      
      return jobs;
   }
   
}