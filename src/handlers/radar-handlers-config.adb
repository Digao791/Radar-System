with AWS.Messages;
with Radar.API.Context;
with Radar.Service;
with Radar.DTO.Config;
with Radar.JSON;
with Radar.API.Responses;

package body Radar.Handlers.Config is

   use type Radar.API.Context.Service_Access;

   function Get return AWS.Response.Data is

      Service_Ref : constant Radar.API.Context.Service_Access :=
         Radar.API.Context.Get_Service;

   begin
      if Service_Ref = null then
         return Radar.API.Responses.Build_Error
         ("Radar service unavailable", AWS.Messages.S503);
      end if;

      declare
         Response : constant Radar.DTO.Config.Config_Response :=
            Radar.Service.Get_Config (Service_Ref.all);

      begin
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => Radar.JSON.To_JSON (Response).Write,
            Status_Code  => AWS.Messages.S200);
      end;

   end Get;

end Radar.Handlers.Config;