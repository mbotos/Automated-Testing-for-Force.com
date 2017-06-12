Salesforce Testing Automation
=============================

About
-----    

Salesforce testing automation runs all tests and emails your team. Native Force.com Apex code delivers lightweight Salesforce continuous integration. Schedule daily, nightly, or hourly recursion unit tests.

![Automated Testing Setup Screenshot](https://github.com/mbotos/Automated-Testing-for-Force.com/blob/master/Automated%20Testing%20Setup%20Screenshot.png)

Setup
-----

1. Navigate to the Automated Testing app and Automated Test Setup tab.
2. Follow the instructions. 

Troubleshooting
---------------
**[Email Privileges Revoked message when sending mass emails from Production or Sandbox](https://help.salesforce.com/HTViewSolution?id=000176020&language=en_US)**

If you created a sandbox after the Spring '13 release, go to [Your Name > Setup > Email Administration > Deliverability](https://test.salesforce.com/email/admin/editOrgEmailSettings.apexp) and choose Access Level: All Emails.  

Limitations
-----------

Because we can't create a trigger on the asynchronous test objects, we run a second scheduled job to process the results. By default, this runs half an hour after the tests are launched; you may need to adjust for longer test runs.

Future Work
-----------

* Validate Automated Test Run fields
* Allow individual scheduling of different runs
* Web service for post-commit hook from source control systems  
