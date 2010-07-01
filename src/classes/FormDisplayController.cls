public with sharing class FormDisplayController extends PageControllerBase {
     
      public ApexPages.StandardController standardCon { get; set; }
      public String fieldName                       { get; set; }
      public Form__c form                           { get; set; }   
      public String formname                        { get; set; }
      public SObject activeSObject                  { get; set; }  
      public FormController myComponentController   { get; set; }      

    public FormDisplayController() {
        
        formname = ApexPages.CurrentPage().getParameters().get('name');
        System.debug('NAME' + formname);
        
        try {
            form = [select Id, OwnerId, Style__c, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, formation__Background_Color__c, formation__Description__c, formation__Finished_Blurb__c, formation__Object_Label__c, formation__Object_Name__c, formation__Return_URL__c, formation__Save_Button_Text__c, formation__SavedByWebformeditor__c, formation__Text_Color__c, formation__Title__c, formation__Default_Value__c from formation__Form__c where name = :formName];          
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