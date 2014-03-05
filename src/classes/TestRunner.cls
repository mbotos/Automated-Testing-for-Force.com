global class TestRunner implements Schedulable {
	// derived from http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_testing_unit_tests_running.htm#APISectionTitle

	public static void setup() {
		try {
			system.schedule('TestRunner', '0 0 23 ? * SUN-THU', new TestRunner());
			system.schedule('TestRunnerResults', '0 30 23 ? * SUN-THU', new TestRunnerResults());
		} catch (Asyncexception ex) {
			system.debug('Job already scheduled');
		}
	}
	
   global void execute(SchedulableContext SC) {
      enqueueTests(); 
   }
	
    // Enqueue all unit test classes as spec'd by Automated_Test_Run__c record(s)
    public static list<ID> enqueueTests() {
    	list<Id> jobIds = new list<Id>();
    
		for (Automated_Test_Run__c run : [select Query__c, Excluded_Classes__c, 
		Email_on_Pass__c, Exclude_Managed_Packages__c
		from Automated_Test_Run__c where Active__c = true]) {
    		string whereExcluded = '';
    		if (run.Excluded_Classes__c != null) {
    			for (string c : run.Excluded_Classes__c.split('[,\\s]+')) {
    				whereExcluded += 'and Name != \'' + c + '\'';
    			}
    		}
			if (run.Exclude_Managed_Packages__c == True) {
			   whereExcluded += ' AND NameSpacePrefix = null';
			}
    		
    		string query = 'SELECT Id FROM ApexClass WHERE Name LIKE \'' + run.Query__c + '\' ' + whereExcluded;
	        ApexClass[] testClasses = Database.query(query);
	            
	        if (testClasses.size() > 0) {
	            ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
	            for (ApexClass cls : testClasses) {
	                queueItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
	            }
	
				if (!Test.isRunningTest()) {
		            insert queueItems;
		
		            // Get the job ID of the first queue item returned. 	    
		            ApexTestQueueItem item = 
		               [SELECT ParentJobId FROM ApexTestQueueItem 
		                WHERE Id=:queueItems[0].Id LIMIT 1];
		                
		            insert new Test_Runner_Job__c(Name = item.parentjobid, Automated_Test_Run__c = run.Id);
		            
		            jobIds.add(item.parentjobid);
				}
	        }
    	}
    	
        return jobIds;
    }

    public static Messaging.SingleEmailMessage emailMethodStatus(Test_Runner_Job__c job) {
        ApexTestResult[] results = 
           [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace 
            FROM ApexTestResult 
            WHERE AsyncApexJobId=:job.Name];
            
        return emailMethodStatus(job, results);
    }
        
    public static Messaging.SingleEmailMessage emailMethodStatus(Test_Runner_Job__c job, ApexTestResult[] results) {
        integer passed = 0;
        integer total = 0;
        
        string failTable = '<table border="1" cellpadding="5px">';
        string className = '';
            
        for (ApexTestResult atr : results) {
        	if (atr.Outcome == 'Pass') {
        		passed++;
        	} else {
        		if (atr.ApexClass.Name != className) {
        			className = atr.ApexClass.Name;
        			failTable += '<tr style="background: #ddd; font-weight: bold;"><td colspan="2">' + className + '</td></tr>\n';
        		}
	            failTable += '<tr><td>' + atr.MethodName + '</td><td> ' + atr.message + '</td></tr>\n';
        	}
        	total++;
        }
        
        failTable += '</table>';
        
        string body = '<p>' + passed + '/' + total + ' tests passed</p>\n';
        boolean allPassed = passed == total;
        
        if (!allPassed) {
        	body += '<p>Test Failures:</p>\n' + failTable;
        }
        
        Messaging.SingleEmailMessage mail;
        
        if ((allPassed && job.Automated_Test_Run__r.Email_on_Pass__c) || !allPassed) { 
	        mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(job.Automated_Test_Run__r.Emails__c.split('[,\\s]+'));
	        mail.setSubject(job.Automated_Test_Run__r.Name + ' Automated Test Results: ' + (passed < total ? 'Fail' : 'Pass'));
	        mail.setHtmlBody(body);
	        System.debug(mail);
	
			if (!Test.isRunningTest()) {
	        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
        }
		
		return mail;
    }
 }