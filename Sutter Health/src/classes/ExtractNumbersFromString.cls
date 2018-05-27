/**  
*    Class Name  : ExtractNumbersFromString
*    Date        : 19-Aug-2015
*    Description : This class is used in REQ- 3670 for extracting numbers from a given String
**/

public class ExtractNumbersFromString {

 /**
  *   @Description  : This method takes a String as input and extracts only numeric values from it and then returns it
  *   @Arguments    : String which is a Phone or Fax number on a Provide rInformation Summary record.
  *   @Return       : String
 **/

public static String extractMethod(String str) {
    String numericString;
    if(str!=null){
    numericString = '';
    integer strLength = str.length();
        for(integer i =0;i<str.length();i++){
            String s= str.mid(i,1);
            if(s.isNumeric()){
                numericString +=s;
            }
        }
    }
    return numericString;
    }
}