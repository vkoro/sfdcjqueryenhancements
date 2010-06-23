public with sharing class randomTestClass {
	
	public randomTestClass()
	{
	}

	static testmethod void init() {    
		
		  List<String> l = new List<String>();
		  
		  String s = '';
		  for(Integer i = 0; i< 10; i++)
		  {
		  	s += '0';
		  	l.add(s);
		  	System.debug(s.length());
		  }
		  for(Integer i = 9; i >= 0; i--)
		  {
		  	System.debug(l[i].length());
		  	System.assertEquals(0, l[i].replace('0','').length());
		  }
	}


}