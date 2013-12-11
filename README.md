About
-----    

This project allows you to natively schedule automated test runs of your Force.com Apex code and email the results to multiple addresses.

Installation
------------

For an easy, 1-click installation: [Automated Testing for Force.com Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04ti0000000Cjj9) ([sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04ti0000000Cjj9)).

To use the source code with a Salesforce org: [GitHub Salesforce Deploy Tool](https://githubsfdeploy.herokuapp.com/?owner=mbotos&repo=Automated-Testing-for-Force.com)   

Setup
-----

1. Navigate to the Automated Testing app and Automated Test Setup tab.
2. Follow the instructions.   

Limitations
-----------

Because we can't create a trigger on the asynchronous test objects, we run a second scheduled job to process the results. By default, this runs half an hour after the tests are launched; you may need to adjust for longer test runs.

Future Work
-----------

* Validate Automated Test Run fields
* Allow individual scheduling of different runs
* Web service for post-commit hook from source control systems  
