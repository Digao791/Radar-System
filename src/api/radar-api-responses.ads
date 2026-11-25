with AWS.Response;
with AWS.Messages;

package Radar.API.Responses is

   function Build_Error
     (Message     : String;
      Status_Code : AWS.Messages.Status_Code)
      return AWS.Response.Data;

end Radar.API.Responses;