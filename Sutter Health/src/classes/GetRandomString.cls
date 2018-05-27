/**  
*     Class Name  : GetRandomString
*     Author      : IDC Offshore
*     Date        : 30-March-2015
*     Project Name: CRM - SFT - Sutter Health
*     Description : This class is for REQ- 3399. BatchProviderScheduler needs t generate a dummy email id and this class will generate a unique random string to be used as dummy email id

**/
public class GetRandomString{

	public static String generateString(){

		Blob blobKey = crypto.generateAesKey(128);
		String key = EncodingUtil.convertToHex(blobKey);
		String strKey = key.subString(3,11);

		return strKey;
	}
}