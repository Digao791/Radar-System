with AWS.Messages;
with GNATCOLL.JSON;

with Radar.API.Context;
with Radar.Service;
with Radar.Detection;

package body Radar.Handlers.Config is

   use GNATCOLL.JSON;
   use type Radar.API.Context.Service_Access;

   function Get return AWS.Response.Data is

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
         Station : constant Radar.Detection.Radar_Station :=
            Radar.Service.Get_Station (Service_Ref.all);

         Result : JSON_Value := Create_Object;

      begin
         Result.Set_Field ("x",  (Station.X));
         Result.Set_Field ("y",  (Station.Y));
         Result.Set_Field
           ("radar_range",  (Station.Radar_Range));

         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => Result.Write);
      end;

   end Get;

end Radar.Handlers.Config;