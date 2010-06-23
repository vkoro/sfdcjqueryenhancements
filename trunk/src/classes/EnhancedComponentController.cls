public with sharing virtual class EnhancedComponentController {

  public SObject myObject 		{ get; set; }
  public String fieldName  		{ get; set; }
  public Object myValueHolder 	{ get; set; }
   
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
	  	if(myObject != null && myObject.get(fieldName) != null)
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
  	
  }
  
  
  public virtual Object getCastedValue() {
 	return myValueHolder;
  }
     
  
}