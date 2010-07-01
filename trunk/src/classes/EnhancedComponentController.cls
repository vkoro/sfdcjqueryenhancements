public with sharing virtual class EnhancedComponentController {

  public SObject myObject 		{ get; set; }
  public String fieldName  		{ get; set; }
  public Object myValueHolder 	{ get; set; }
  public Boolean required		{ get; set; }
  public Boolean hidden			{ get; set; }
  public String defaultValue	{ get; set; }
  
  public PageControllerBase pageController { get; 
    set {
      if (value != null) {
    	pageController = value;
    	pageController.addComponentController(this);   
      }  
    }
  }

  public EnhancedComponentController()  {
  	
  }
 
  public virtual void onLoad() {
  	
  	try {
  		System.debug('onLoad ' + fieldName);
  		if(myObject == null)
		  	myObject = pageController.myObject;
	  	if(myObject != null && myObject.get(fieldName) != null && defaultValue == null)
		  	myValueHolder = String.valueOf(myObject.get(fieldName));
		
		try {
			//This can be a boolean which cannot be cast to a String
			String s = (String) myValueHolder;
			System.debug('onLoad Value: ' + s);
		}
		catch(Exception e)
		{
		}
  	}
  	catch(SObjectException soe)
  	{
  		System.debug(soe);
  	}  
  	if(defaultValue != null)
  		myValueHolder = (Object) defaultValue;
  	
  	
  }
  
  public virtual void addOnLoadJavascriptToParentController(String js)
  {
  	if(hidden != true)
  		pageController.addOnLoadJavascript(js);
  }
  
  public virtual Object getCastedValue() {
 	return myValueHolder;
  }
     
  
}