public with sharing class EnhancedLookupController extends EnhancedComponentController {
	
	public String displayColumn 	{ get; set; }
	public String objectToLookup 	{ get; set; }
	public String displayName 		{ get; set; }
	
	private String jsonData;
	private Map<String,String> values;
	
	//Need for testing to avoid "Too many query rows" error
	public Integer jsonRecordLimit = 2000;
	
	public void setJsonRecordLimit(Integer jsonRecordLimit) {
		this.jsonRecordLimit = jsonRecordLimit;
	}
	
	public String getOnLoad(){

		onLoad();
		

		if (displayColumn == null)
			displayColumn = 'name';
			
		String jsonData = getJson();
						  						
		String initialize = 'var ' + uid + 'data = ' + jsonData + ';\n' +
							
							'$(".L' + uid + '").autocomplete(' + uid + 'data, { \n' +
							'\n' + 			
							'						 formatItem: function(item) {  \n' +
							'						   return item.'+ displayColumn + ';      \n' +
							'						   }   \n' +
							'\n' +
							'						 }).result(function(event, item) {\n' +
							'								  $(".' + uid + '").val(item.id);\n' +
							'								});  \n';
							if (myValueHolder != null)
									initialize += 	'$(".' + uid + '").val("' + (String) myValueHolder + '");\n';
		    

		addOnLoadJavascriptToParentController(initialize);
		return '';
		
	}

    // see: http://community.salesforce.com/t5/Apex-Code-Development/Building-a-reusable-JSON-component/m-p/172428
    // and: http://joe-ferraro.com/2009/04/extjs-vf-json/
    
    public String getJson()
     {
     	if (jsonData == null) 
     	{
			values = new Map<String,String>();
	     	jsonData = '';
			try {
				System.debug('getJsonifiedObjectRecords for:' + fieldname + ' ' + objectToLookup );
				  
				List<String> columns = new List<String>();
				  
				columns.add('id');
				if(displayColumn != null)
					columns.add(displayColumn);
				else
					columns.add('name');   
				  
				String queryString = 'Select id, ' + displayColumn + ' from ' + objectToLookup + ' limit ' + jsonRecordLimit;
				System.debug('queryString:' + queryString);
				List<sObject> sos = Database.query(queryString);
				//Map<String, Schema.SObjectField> columns = sos.getSObjectType().getDescribe().fields.getMap();
									  
				jsonData += '[';    
		        for (sObject so : sos) {  
		        		jsonData += ' { ';
						  for(String column : columns)
				          {   
				          			//System.debug('jsonData:' + jsonData);
				                     try 
				                     {
				                     	String cellVal = String.valueOf( so.get(column));
				                        jsonData += ''+column+': "'+cellVal+'",';
				                        if (cellVal == (String) myValueHolder)
				                        	displayName = cellVal;   
				                     }   
				                     catch(Exception ex) 
				                     {
										System.debug(ex);
				                     }
						 }
			 			 jsonData = jsonData.substring(0, jsonData.length() - 1);
	                	 jsonData = jsonData + '},';  
						 
		        }
		
				jsonData = jsonData.subString(0,jsonData.length() - 1);
		        jsonData = jsonData + ']';
				
	        }
			catch(Exception e)
			{	
				System.debug('Bad query in Jsonify Call ' + e);			
			}
     }
     	
      	System.debug('jsonData:' + jsonData);
        return jsonData;
      	}
      	
  public override Object getCastedValue() {
  	
  	String s = (String) myValueHolder;
  	if(s == '')
  		return null;
  	else
	 	return myValueHolder;
  }
     

	

}