/*
	This class used to dynamically tell to user on which page he is right now.
	================================================================
	Name 					   Date 					  version
	================================================================
	Alok Verma				  9/25/2015						1.0
	================================================================
*/
public class SH_BreadCrumb {
    public string pgName {get; set;}
    public string pgLink {get; set;}
    
    public SH_BreadCrumb(string pgName, string pgLink ) {
        this.pgName= pgName;
        this.pgLink = pgLink ;
    }
}