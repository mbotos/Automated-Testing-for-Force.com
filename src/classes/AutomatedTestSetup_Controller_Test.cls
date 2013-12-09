@isTest
public with sharing class AutomatedTestSetup_Controller_Test {
	static testMethod void test() {
		AutomatedTestSetup_Controller controller = new AutomatedTestSetup_Controller();
		
		controller.scheduleJobs();
		System.assert(controller.hasScheduledJobs, 'Jobs not scheduled');
		
		controller.createTestRun();
		System.assert(controller.hasTestRun, 'Test Run not created');
		
		controller.run();
		System.assert(controller.isRunning, 'Tests not running');
		
		controller.email();
		System.assert(controller.isEmailing, 'Tests not emailing');
	}
}