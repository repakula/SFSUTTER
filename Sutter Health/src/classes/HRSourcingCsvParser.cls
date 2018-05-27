/**********************************************************************
Name: HRSourcingCsvParser
======================================================
======================================================
Purpose:
This class parse csv file of "Import candidate" module.
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 Sandeep Sharma      05-11-2015      INITIAL DEVELOPMENT         This class parse csv file of "Import candidate" module.
***********************************************************************/

public class HRSourcingCsvParser{

    
     /*******************************************************************
    Purpose: parseCSV method which reads the CSV file and processes it
    Parameters: String, Boolean
    Returns: List<List<String>>
    Throws [Exceptions]: NA
    ********************************************************************/

public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
    List<List<String>> allFields = new List<List<String>>();
    // Break line at '\n' chareacters 
    List<String> lines1 = new List<String>();
           lines1 = contents.split('\n');
          
    // if the total numebr of lines are more than 500, then we return null. We are not supporting more than 500 lines.       
    if(lines1.size()> 501){
    return null;
    }
    
    // replace instances where a double quote begins a field containing a comma
    // in this case you get a double quote followed by a doubled double quote
    // do this for beginning and end of a field
       
    contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
    
    // now replace all remaining double quotes - we do this so that we can reconstruct
    // fields with commas inside assuming they begin and end with a double quote
    
    contents = contents.replaceAll('""','DBLQT');
    // we are not attempting to handle fields with a newline inside of them
    // so, split on newline to get the spreadsheet rows
    List<String> lines = new List<String>();
    try {
        lines = contents.split('\n');
    } catch (System.ListException e) {
        string EXEPTION_MSG = '\r\n';
        Utility.handleExceptionFromCode(e.getMessage() + EXEPTION_MSG + e.getStackTraceString() + EXEPTION_MSG  + e.getTypeName() + EXEPTION_MSG  + System.now() + EXEPTION_MSG);
    }
    Integer num = 0;
    for(String line: lines) {
        // check for blank CSV lines (only commas)
        if (line.replaceAll(',','').trim().length() == 0) break;
        
        List<String> fields = line.split(',');  
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field: fields) {
            if(field == '"'){
                compositeField += '"';
                cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                makeCompositeField = false;
            }
                
            else if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {
                
                cleanFields.add(field.replaceAll('DBLQT','"'));
            }
        }
        
        allFields.add(cleanFields);
    }
    if (skipHeaders){
        allFields.remove(0);
    } 
    return allFields; 
}
}