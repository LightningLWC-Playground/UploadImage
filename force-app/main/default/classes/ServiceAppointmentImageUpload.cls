public with sharing class ServiceAppointmentImageUpload {
    @AuraEnabled(cacheable=true)
    //get serviceappointment id for fetch the id java script code
    public static String getSaStatus(Id parentId) {
        String saStatus = 'null';

        if (saId != null) {
            ServiceAppointment sa = [SELECT Id, Status FROM ServiceAppointment WHERE Id = :saId LIMIT 1];
            saStatus = sa.Status;
        } else if (parentId != null) {
            // Use the parentId if it's a ServiceAppointment Id
            ServiceAppointment saParent = [SELECT Id, Status FROM ServiceAppointment WHERE Id = :parentId LIMIT 1];
            if (saParent != null) {
                saId = saParent.Id;
                saStatus = saParent.Status;
            }
        }

  // Modify the fileName based on the ServiceAppointment status
  if (saStatus != null && saId != null) {
    if (saStatus == 'Scheduled') {
        fileName = saStatus + '_' + saId + '_' + 'Dispatched_' + fileName;
    } 
    if (saStatus == 'Dispatched') {
        fileName = saStatus + '_' + saId + '_' + 'In Progress_' + fileName;
    } 
   
}          
    }

    //image upload and condition for file name Two status dispatch and in progress
   
    @AuraEnabled
    public static Id saveImage(String fileName, String base64Data, Id parentId, Id saId) {
       
      
       
       
               base64Data = base64Data.substring(base64Data.indexOf(',') + 1);
               Blob fileData = EncodingUtil.base64Decode(base64Data);
       
               ContentVersion cv = new ContentVersion();
               cv.ContentLocation = 'S'; // S for Salesforce, E for External
               cv.PathOnClient = fileName;
               cv.VersionData = fileData;
               cv.FirstPublishLocationId = parentId; // This links the file directly to the service appointment record
               insert cv;
       
               return cv.Id;
       
    }
}