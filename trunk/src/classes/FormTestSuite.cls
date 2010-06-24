public with sharing class FormTestSuite {


        //** TEST METHODS **//
    
    public static testMethod void t1() {
        //set up a test web form
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'Test__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
        //create test form fields for this web form       
        Form_Field__c f1 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('EMAIL'), Name = 'Email__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f3 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('URL'), Name = 'URL__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f4 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('BOOLEAN'), Name = 'Checkbox__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f5 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DATE'), Name = 'Date__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f6 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DATETIME'), Name = 'DateTime__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f7 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('CURRENCY'), Name = 'Currency__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f8 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DOUBLE'), Name = 'Number__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f9 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PERCENT'), Name = 'Percent__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f10 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('TEXTAREA'), Name = 'Text_Area__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f11 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PHONE'), Name = 'Phone__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f12 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PICKLIST'), Name = 'Picklist__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f13 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('UNSUPPORTED'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f13b = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('INTEGER'), Name = 'Integer__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f15 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('MULTIPICKLIST'), Name = 'MultiPicklist__c', Form__c = form.Id, Label__c = 'lbl');
        
        
        insert f1;
        insert f2;
        insert f3;
        insert f4;     
        insert f5;
        insert f6;
        insert f7;
        insert f8;
        insert f9;
        insert f10;
        insert f11;
        insert f12;
        insert f13;
        insert f13b;
        insert f15;
                
        //add a field with a missing required value
        Form_Field__c f14 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl', Required__c = true);
        insert f14;
        
        //set the current page for the test, put the web form id in parameters and instantiate the controller
        PageReference pageRef = Page.form;
        //PageReference pageRef;
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('name', form.name);
        
        FormController controller = new FormController();
        System.assertEquals(16, controller.fields.size());
        //save with missing required fields
        PageReference ref = controller.saveObject();
        System.assertEquals(null,ref);
        
        //add the required values and save again
        //f14.Text_Value__c ='something';
        //upsert f14;
                
        //now do everything again but with no 'required field' validation errors
        FormController controller2 = new FormController();
        
        PageReference ref2 = controller2.saveObject();  
        //System.assertEquals('http://www.x.com',ref2.getUrl());  
    }
    
    public static testMethod void t2() {
                
        //add an object with a required field in the db, just to throw an exception (Form__c itself for example)
        //set up a test web form
        Form__c form2 = new Form__c();
        form2.Name = 'test webform';
        form2.Object_Name__c = 'Form__c';//can't use account. Not accessible via Dynamix Apex in packaged class.
        form2.Object_Label__c = 'Test';
        form2.Return_URL__c = 'http://www.x.com';
        form2.SavedByWebformeditor__c = true;
        
        insert form2;
        //create test form fields for this web form
        Form_Field__c f20 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Phone', Form__c = form2.Id, Label__c = 'lbl');
        //add just one, we ommit the required 'Name' field.     
        insert f20;
        
        // Add parameters to page URL
        PageReference pr = Page.form;
        //PageReference pr;  
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('id', form2.Id);
        
        FormController controller3 = new FormController();
        //the save needs to throw an exception because the object's required field is not in the formfields list        
        System.assert(controller3.saveObject() == null);
          
    }
    
    
    
    //no web form id url param
    public static testMethod void t3() {
        //instantiate the controller with no Id param
        FormController controller1 = new FormController();
        
        //set up a test web form - we're going to hit the nullpointer exception with this one
        Form__c form = new Form__c();
        form.Name = 'test webform';
        form.Object_Name__c = 'testbypassx'; //when people don't set up the web editor and try to fill this in manually
        form.Return_URL__c = 'www.x.com';
        
        insert form;
        //create test form fields for this web form
        Form_Field__c f1 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('EMAIL'), Name = 'Email__c', Form__c = form.Id, Label__c = 'lbl');
        
        insert f1;  
        insert f2;

    
        //set the current page for the test, put the web form id in parameters and instantiate the controller
       PageReference pageRef = Page.form;
       // PageReference pageRef;  
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', form.Id);
        //instantiate the controller with the form/wrong object name
        FormController controller = new FormController();           
    }


    public static testMethod void formFieldT1() {
        FormFieldController controller = new FormFieldController();
        Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = 'a,b,c';
        field.Type__c = 'Picklist';
        controller.field = field;
        List<SelectOption> selectlist = controller.getPicklistSelectOptions();
        System.assertEquals(4, selectlist.size());
    }

    public static testMethod void formFieldT2() {
        FormFieldController controller = new FormFieldController();
        Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = 'a,b,c';
        field.Type__c = 'Multi-Select';
        controller.field = field;
        List<SelectOption> selectlist = controller.getPicklistSelectOptions();
        System.assertEquals(3, selectlist.size());
    }  




  

}

//  Copyright (c) 2009, David Van Puyvelde, Sales Engineering, Salesforce.com Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.