with AWS.Messages;
with Radar.API.Context;
with Radar.Service;
with Radar.DTO.Detection;
with Radar.JSON;

package body Radar.Handlers.Detection is

   use type Radar.API.Context.Service_Access;

   function Get_All return AWS.Response.Data is

      Service_Ref : constant Radar.API.Context.Service_Access :=
         Radar.API.Context.Get_Service;

   begin
      if Service_Ref = null then
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body =>
              "{""error"":""Radar service unavailable""}",
            Status_Code => AWS.Messages.S503);
      end if;

      declare
         Response : constant
            Radar.DTO.Detection.Detections_Response :=
               Radar.Service.Get_Detections (Service_Ref.all);

      begin
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => Radar.JSON.To_JSON (Response).Write,
            Status_Code  => AWS.Messages.S200);
      end;

   end Get_All;

end Radar.Handlers.Detection;