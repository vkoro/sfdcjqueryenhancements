public with sharing class FormDemoController extends PageControllerBase {
	 
	  public ApexPages.StandardController standardCon { get; set; }
	  public String fieldName 						{ get; set; }
	  public Form__c form 							{ get; set; }   
	  public String formname 						{ get; set; }
	  public SObject activeSObject  				{ get; set; }  
	  public FormController myComponentController 	{ get; set; }      

    public FormDemoController() {
    	
        formname = ApexPages.CurrentPage().getParameters().get('name');

        try {
		    form = [select Id, Name, Object_Name__c, Finished_Blurb__c, Object_Label__c, Title__c, Save_Button_Text__c, Text_Color__c from Form__c where name = :formName];          
	 	  	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
	        SObjectType sot = gd.get(form.Object_Name__c);
	        try {
	            myObject = sot.newSObject();
	        }
	        catch(System.NullPointerException ex) {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The system can not create a form for : '+ form.Object_Name__c));
	        }
        
        }
        catch (QueryException qe)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no form with this name.'));
			return;      	
        }
        
        System.debug('form is:' + formName);
               
    }
	   	  
	  public void save()
	  {
	  	ecSave();
	  }
	  

}