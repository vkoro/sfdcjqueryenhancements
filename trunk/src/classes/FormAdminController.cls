public with sharing class FormAdminController {

	public fieldGroup currGroup						{ get; set; }
    public List<fieldGroup> groups 					{ get; set; }
    public Form__c webform 							{ get; set; }  
    public List<Form_Field__c> formFields 			{ get; set; }
    public List<SelectOption> formFieldNames		{ get; set; }

    public String val { get; set; }
    public String groupName { get; set; }
    public String showFieldName { get; set; }
    public String fieldName { get; set; }
    public Boolean displayPopup 					{ get; set; }
	public Form_Field__c activeFormField 			{ get; set; }

    public FormAdminController(ApexPages.StandardController stdController) {
    	init();
    }

    public FormAdminController() {
    	init();
    }
    
	public void init() {

        displayPopup = false;
		formFields = new List<Form_Field__c>();        
        String webformid = System.currentPageReference().getParameters().get('id');
        currGroup = new fieldGroup();
        groups = new List<fieldGroup>();
        
        if(webformid != null) {      
            webform = [select Id, Name, Object_Name__c, Object_Label__c, Finished_Blurb__c, Return_URL__c, Description__c, Title__c, Background_Color__c, Save_Button_Text__c, Text_Color__c, 
            		Style__c, Default_Record__c,  Use_Enhanced_Datepicker__c, Use_Enhanced_Lookup__c, Use_Enhanced_Multiselect__c, Use_Enhanced_Picklist__c, Use_Enhanced_Text__c, Use_Enhanced_Textarea__c
            	    from Form__c where Id = :webformid];          
            formFields = [Select f.id, f.Form__c, f.Type__c, f.Order__c, 
            					 f.Name, f.Label__c, f.Hidden__c, 
            					 f.Group__c, f.PicklistEntries__c
                            	 from Form_Field__c f where f.Form__c = :webform.Id 
                            	 and f.Hidden__c != true order by f.Order__c];    
                            	 
		   formFieldNames = new List<SelectOption>();
		   	
           for(Integer i = 0; i < formFields.size();i++) {  
           	
				formFieldNames.add(new SelectOption(formFields.get(i).name, formFields.get(i).Label__c));
				
				if(formFields.get(i).group__c != null && formFields.get(i).Group__c != '')
				{

					Boolean addedToExistingGroup = false;					
	                for(fieldGroup g : groups) {
	                	
						if(formFields.get(i).Name == g.groupName)
						{
							g.fields.add(formFields.get(i));
							formFields.remove(i);
							addedToExistingGroup = true;
						}
	                }
	                
	                if(addedToExistingGroup == false)
	                {
	                	groups.add(new fieldGroup(formFields.get(i).Group__c));
	                	groups.get(groups.size() - 1).fields.add(formFields.get(i));
	                	formFields.remove(i);
	                }
                
				}
                
            }    
            for(fieldGroup g : groups)
            {
            	List<Field_Show_Rule__c> sr = [select name, Form_Field__c, Form_Field__r.name, Form_Field__r.PicklistEntries__c, Value_to_show__c from Field_Show_Rule__c where name =: g.groupName limit 1];
            	if(sr.size() == 1)
            	{
            		g.showVals = sr.get(0).value_to_show__c.split(',');
            		g.showRule = sr.get(0);

            	}	
            }               
        }
		
		
	}  
	
	public PageReference enablePopup() {
    	displayPopup = true;
    	return null;
    }

	public PageReference disablePopup() {
    	displayPopup = false;
    	return null;
    }


    public List<SelectOption> getGroupsSO() {
    	
    	List<SelectOption> so = new List<SelectOption>();
    	so.add(new SelectOption('','--SELECT--'));
		for(fieldGroup g : groups)
			so.add(new SelectOption(g.groupName,g.groupName));
		return so;
    }
    
	public Boolean getHasGroups() {
		
		return (groups != null && groups.size() > 0); 
	}
	
	public PageReference addGroup() {
		groups.add(currGroup);
		currGroup = new fieldGroup();
        return null;
    }
	
	public PageReference addFieldToGroup() {

	   		System.debug('fieldname:' + fieldname);
		   	System.debug('groupname:' + groupname);

	   Form_Field__c formFieldtoAdd;
	   Boolean found = false;
	   for(Integer i = 0; i < formFields.size(); i++)
	   {	   	
	   		System.debug('fieldname:' + fieldname);
	   		System.debug('formFields.get(i).name:' + formFields.get(i).name);
	   		
		   	if(formFields.get(i).name == fieldname)
		   	{	
		   		formFieldtoAdd = formFields.get(i);
		   		formFields.remove(i);
		   		found = true;
		   		
		   		System.debug('MATCH!');
		   		break;
		   	}
	   }	   
	
	   for(fieldGroup g : groups) {

		   	System.debug('groupname:' + groupname);
		   	System.debug('g.groupname:' + g.groupname);
	                	
			if(groupName == g.groupName)
			{
				g.fields.add(formFieldtoAdd);
		  	 	System.debug('GROUP MATCH');
				
				break;	
			}
	    }

        displayPopup = false;
		return null;

    }
    
	public PageReference removeFieldFromGroup() {
	   
	   for(fieldGroup g : groups) {
	        for(Integer i=0;i < g.fields.size();i++)
	        {        	
				if(g.fields[i].name == fieldName)
					{
						Form_Field__c f = g.fields.get(i);
						g.fields.remove(i);  
						formFields.add(f);
					   formFields = WebFormUtils.sortByOrder(formFields);
					   return null;
					}
					
	        }
	    }

        return null;
    }

	public PageReference saveShowField() {

	   System.debug('groupname:' + groupname);

	   Form_Field__c showField;
	   
	   Boolean found = false;
	   String showFieldName;
	   
	  for(fieldGroup g : groups) {

		   	System.debug('g.groupname:' + g.groupname);
	                	
			if(groupName == g.groupName)
			{
				showFieldName = g.ShowFieldName;
		  	 	System.debug('FOUND SHOWNAME');
				break;	
			}
	    }
	    
   		System.debug('showfieldname:' + showFieldName);
	   
	   for(Integer i = 0; i < formFields.size(); i++)
	   {	   	
	   		System.debug('showFieldname:' + showFieldName);
	   		System.debug('formFields.get(i).name:' + formFields.get(i).name);
		   	if(formFields.get(i).name == showFieldName)
		   	{	
		   		showField = formFields.get(i);
		   		System.debug('MATCH!');  
		   		break;
		   	}
	   }	   
	
	   for(fieldGroup g : groups) {

		   	System.debug('groupname:' + groupname);
		   	System.debug('g.groupname:' + g.groupname);
	                	
			if(groupName == g.groupName)
			{
				g.showField = showField;
		  	 	System.debug('GROUP MATCH');
				break;	
			}
	    }

		return null;

    }

    public PageReference removeVal() {

	   for(fieldGroup g : groups) {
	                	
			if(groupName == g.groupName)
			{
				for(Integer i=0;i < g.showVals.size(); i++)
				{
					if(val == g.showVals[i])
					{
						g.showVals.remove(i);
						return null;	
					}

				}
			}
	    }
	    
	    return null;
	    
    }


    public PageReference addVal() {

	   for(fieldGroup g : groups) {
	                	
			if(groupName == g.groupName)
			{
				g.showVals.add(val);
				val = '';
				return null;
			}
	    }
    	return null;
    }


	public PageReference save()	
	{
		List<Form_Field__c> fieldsToSave = new List<Form_Field__c>();
		List<Field_Show_Rule__c> showRulesToSave = new List<Field_Show_Rule__c>();
		
		for(fieldGroup g : groups)
		{
			
			String ffid;
			
			for(Form_Field__c f : g.fields)
			{
				f.Group__c = g.groupName;
				fieldsToSave.add(f);
				
			}  
			if (g.showField != null)
			{
				g.showRule.name = groupName;
	
				//crazy work around for bug when assigning string
				
				if(g.showVals.size() > 0)
				{
					g.showRule.Value_To_Show__c = g.showVals.get(0) + ',';
										 
					for(Integer i = 1; i < g.showVals.size(); i++)
						g.showRule.Value_To_Show__c += g.showVals.get(i) + ',';
					
					if(g.showRule.Value_To_Show__c.length() > 0)
						g.showRule.Value_To_Show__c = g.showRule.Value_To_Show__c.substring(0, g.showRule.Value_To_Show__c.length()-1);
				
				}
				
				if ((g.showRule.Form_Field__c == null ) || (((String) g.showRule.Form_Field__c) == ''))
					g.showRule.Form_Field__c = g.showField.id;				
				
				showRulesToSave.add(g.ShowRule);
			}
				
		}
		
		update fieldsToSave;
		upsert showRulesToSave;
		
		return null;
	}

    public class fieldGroup
    {
    	public String groupName { get; set; }
    	public String showFieldName { get; set; }
    	public Form_Field__c showField { get; set; }
    	//public String showFieldPicklistEntries { get; set; }
    	public Field_Show_Rule__c showRule { get; set; }
    	public List<String> showVals { get; set; }
    	public List<Form_Field__c> fields { get; set; } 
    	    	
    	public fieldGroup() {
    		fields = new List<Form_Field__c>();
    		showVals = new List<String>();
    		//showVals.add('value');
    		showRule = new Field_Show_Rule__c();
    		

    	}

    	public fieldGroup(String name) {
    		groupName = name;
    		fields = new List<Form_Field__c>();
    		showVals = new List<String>();
    		//showVals.add('value');  
    		showRule = new Field_Show_Rule__c();
    			

    	}

    public List<SelectOption> getShowFieldPicklistSO() {

		    	        List<SelectOption> picklistSO = new List<SelectOption>();
		                SelectOption so;
		                List<String> values = new List<String>();
		                if(showField != null && showField.PicklistEntries__c != null) 
		                	values = showField.PicklistEntries__c.split(',', 0);
		                if(showRule.Form_Field__r.PicklistEntries__c != null) 
		                	values = showRule.Form_Field__r.PicklistEntries__c.split(',', 0);
		                for(String s:values) {
		                    so = new SelectOption(s,s);  
		                    picklistSO.add(so);
		                }
		                return picklistSO;
    	
    }
    	
    }


}