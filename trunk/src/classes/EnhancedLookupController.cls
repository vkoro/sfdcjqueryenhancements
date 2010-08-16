public with sharing class EnhancedLookupController extends EnhancedComponentController {
	
	String secondDisplayColumn;
	public String displayColumn 	{ get; set; }
	public String objectToLookup 	{ get; set; }
	public String displayName 		{ get; set; }
	public String filterString 		{ get; set; }
    public transient List<JsonObject> jsonObjs { get; set; }        
	public Boolean bigset 			{ get; set; }

	private transient String jsonData;  
	private Map<String,String> values;

  public List<String> paramValues { get; set; }
  public List<String> paramKeys { get; set; }
  public Map<String,String> params { get; set; }
  Map<String, Schema.SObjectType> gd;
  SObjectType sot;  
	


	public String getOnLoad(){

		onLoad();		
		
		if(bigset == null)
			bigset = false;

		List<String> columns = new List<String>();

		List<String> displayCols = new List<String>();

		if (displayColumn == null)
			displayColumn = 'name';
		else {
			
			displayCols = displayColumn.split('[.]');
			if(displayCols.size() > 1)
				{
					displayColumn = displayCols.get(0);
					secondDisplayColumn = displayCols.get(1);
				}
			
		}
		
		String initialize;
			
		//columns.add('id');  
		columns.add(displayColumn);
		 
		if(!bigset)	
		{	
			jsonData = JsonUtils.getJsonFromObject(objectToLookup, columns, filterString);
			 initialize = 'var ' + uid + 'data = ' + jsonData + ';\n' +
					
					'$(".L' + uid + '").autocomplete(' + uid + 'data, { \n' +
					'\n' + 			
					'						 formatItem: function(item) {  \n' +
					'						   return item.' + displayColumn + ';      \n' +
					'						   }   \n' +
					'\n' +
					'						 }).result(function(event, item) {\n' +
					'								  $(".' + uid + '").val(item.id);\n' +
					'								});  \n';
		}	
		else
		{
			//doSearch();  
			//jsonData = getResult();  
			uid = 'LL' + uid;
			initialize = '' +
		'		        $(".L' + uid + '").autocomplete({\n' +
				        
		'		            source: function(request, response) {\n' +
		'		                    $.getJSON("' + System.Page.largeLookup.getUrl() + '?otl=' + objectToLookup + '&", {\n' + 
							// Not sure if we need this
							// see: http://www.tgerm.com/2010/02/visualforce-salesforce-jquery-ajax-how.html
				            // "core.apexpages.devmode.url" :'1',   
		'		                        term: request.term\n' +
				                        
		'		                   }, response);\n' +
		'		               },\n' +
		'		        select: function(event, ui) {\n' +
				        
		'		           $(".' + uid +'").val(ui.item.id);\n' +
				        
		'		        },\n' +
		'		        minLength: 2\n' +
				            
		'		        });\n';  
		//'		    });\n';
		}
								  		
								  		
							
		if (myValueHolder != null)
				initialize += 	'$(".' + uid + '").val("' + (String) myValueHolder + '");\n';
		    

		addOnLoadJavascriptToParentController(initialize);
		return '';
		
	}
      	
  public override Object getCastedValue() {
  	
  	String s = (String) myValueHolder;
  	if(s == '')
  		return null;
  	else
	 	return myValueHolder;
  }
     
    
    /** invoked on an Ajax request */    
    public void doSearch() {
    	
    	  	  params = ApexPages.currentPage().getParameters();
      paramValues = params.values();
      paramKeys = new List <String>();
      paramKeys.addAll(params.keySet());
      //gd = Schema.getGlobalDescribe();
      //String soType = ApexPages.currentPage().getParameters().get('type');
//      sot = gd.get(soType);
      
      
      for(String s: paramKeys)  
          System.debug('k:' + s);
      for(String s: paramValues)
          System.debug('v:' + s);
        
    	
    	
        //Map<string,string> params = ApexPages.currentPage().getParameters();
        //json = new JsonObject();
        
        if(params.get('otl') != null)
	        objectToLookup = params.get('otl');
	    else if (objectToLookup == null)
	    	objectToLookup = 'Account';
	    	
	    if(params.get('dc') != null)
	        displayColumn = params.get('dc');
	    else if (displayColumn == null)
	    	displayColumn = 'name';         
  

	    if(params.get('filterstring') != null)
	        filterString = params.get('filterstring');
	    else if (filterString == null)  
	    	filterString = '';
	    
        
        // Do SOQL query to see if there are any records !
        List<Sobject> records = getRecords(params.get('term'));
        
        if (!records.isEmpty()) {  
            // Jsonify the results !
            jsonObjs = new List<JSONObject>();   
            for (Sobject o : records) {
                JSONObject cjson = new JSONObject();
                cjson.putOpt('id', new JSONObject.value((String) o.get('id')));
                if(secondDisplayColumn != null)            
	                cjson.putOpt('label', new JSONObject.value((String) o.get(displayColumn) + '(' + ( (String) o.get(secondDisplayColumn) ) + ')' ));
	            else
	            	cjson.putOpt('label', new JSONObject.value((String) o.get(displayColumn)));
	            	
                cjson.putOpt('value', new JSONObject.value((String) o.get(displayColumn)));
                jsonObjs.add(cjson);  

            }   

           // JsonArray ja = json.optJSONArray('objects');  
        }
    }
    
    // Does the SOQL query, using Ajax request data
    public List<SObject> getRecords(String filter) {
        List<SObject> records = new List<SObject>();

  			String limitString;
  			if(filter.length() > 3) 
  				limitString = 'limit 100';  
  			else
  				limitString = 'limit 8';  


        if (filter != null && filter.trim().length() > 0){
  
  				
            String completeFilter = '%' + String.escapeSingleQuotes(filter)  + '%';
            if(filterString.trim().startsWith('WHERE'))
            	filterString = 'AND' + filterString.trim().substring(5, filterString.length());
            	
            String queryString = 'select id, ' + displayColumn;
            if(secondDisplayColumn != null)
            	queryString += ', ' + secondDisplayColumn;
            queryString += ' from ' + objectToLookup + ' where ' + displayColumn + ' like \'' + completeFilter + '\' ';
            
            if(filterString.toLowerCase().contains('limit'))
            	queryString += filterString;
            else
            	queryString += filterString + ' ' + limitString;
            
            System.debug('QUERYSTRING: ' + queryString);
            
            records = Database.query(queryString);
            
        }     
        else {

            String queryString = 'select id, ' + displayColumn;
            if(secondDisplayColumn != null)
            	queryString += ', ' + secondDisplayColumn;
            queryString += ' from ' + objectToLookup + ' ';
            
            if(filterString.toLowerCase().contains('limit'))
            	queryString += filterString;
            else
            	queryString += filterString + ' ' + limitString;


            System.debug('QUERYSTRING: ' + queryString);
            records = Database.query(queryString);
        	        	
        }  
        return records;      
    }    

    // Returns the JSON result string
    public String getResult() {
    	//List<String> jsonStrings = new List<String>();
    	
    	//for(JsonObject jo: jsonObjs)
	    //     jsonStrings.add(jo.ValuetoString());
	    if(jsonObjs != null)
		    return JsonUtils.jsonify(jsonObjs);
		else return '[ ]';        
    }

	

}