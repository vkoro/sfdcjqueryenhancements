public with sharing class EnhancedCheckboxController extends EnhancedComponentController{
	
	public String getOnLoad(){
		
		onLoad();
		String v = (String) myValueHolder;
		if(v != null && v != '')
		{
			v = v.toUpperCase();
			if (v == 'TRUE' || v == 'CHECKED')
				myValueHolder =  true;
			else
				myValueHolder = false;
		}
										  					
		return '';
	}
	
	
	/*public override Object getCastedValue() {     

  	  try
  	  {
  	  	Boolean bvh = (Boolean) myValueHolder;
	  	return bvh;
  	  }
  	  catch(Exception e)
  	  {
  	  	System.debug('Cannot cast to Boolean:' + e);
  	  	return false;
  	  }
	  
	}*/
	  
	

}