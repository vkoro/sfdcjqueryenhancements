// Wrapper class for Field_Show_Rule__c for conditional field display 

public class ShowRule {

  		public List<String> valuesToShow 	{ get; set; }
  		public String firstValueToShow 		{ get; set; }
  		public String groupName 			{ get; set; }
  		public Boolean hasValue				{ get; set; }
  		
  		public ShowRule(Field_Show_Rule__c showRule)
  		{
  			valuesToShow = new List<String>();
  			hasValue = true;
  			
			if(showRule.Value_to_Show__c != null && showRule.Value_to_Show__c != '')
	  			valuesToShow = showRule.Value_to_Show__c.split(',');
	  		else
	  			hasValue = false;
	  			
  			if (valuesToShow.size() > 0)
      			firstValueToShow = valuesToShow.remove(0);
  			groupName = showRule.name;
  		}
	
	
}