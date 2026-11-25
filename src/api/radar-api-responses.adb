with Ada.Strings.Unbounded;
with Radar.DTO.Errors;
with Radar.JSON;

package body Radar.API.Responses is

   function Build_Error
     (Message     : String;
      Status_Code : AWS.Messages.Status_Code)
      return AWS.Response.Data
   is
      Response : constant Radar.DTO.Errors.Error_Response :=
        (Error =>
           Ada.Strings.Unbounded.To_Unbounded_String (Message));

   begin
      return AWS.Response.Build
        (Content_Type => "application/json",
         Message_Body => Radar.JSON.To_JSON (Response).Write,
         Status_Code  => Status_Code);
   end Build_Error;

end Radar.API.Responses;