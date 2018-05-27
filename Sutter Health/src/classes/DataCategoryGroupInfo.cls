/**
* This class holds the Data Category Group Info.
* from the describe result
*/
public class DataCategoryGroupInfo {
private String name;
private String label;
private String description;

/**Req 2978 Release5 Bargaining Unit Code(Added string default value).**/
private DataCategoryInfo[] groupStructure;
private String defaultValue;
public DataCategoryGroupInfo (String name, String label, String description, DataCategoryInfo[] structure) {
    this.name = name;
    this.label = label;
    this.description = description;
    this.groupStructure = structure;
    this.defaultValue = 'NoFilter';
}
/**Req 2978 Release 5 Bargaining Unit code(get,set for default value).**/
public void setValue(String v) {
    this.defaultValue = v;
}

public String getValue() {
    return this.defaultValue;
}



public String getName(){
    return this.name;
}

public String getLabel(){
    return this.label;
}

public String getDescription(){
    return this.description;
}

public DataCategoryInfo[] getGroupStructure(){
    return this.groupStructure;
}
}