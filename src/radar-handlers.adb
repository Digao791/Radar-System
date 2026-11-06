with AWS.Messages;
with AWS.Response;
with Radar.API.Context;
with Radar.Service;
with Radar.Engine;

package body Radar.Handlers is 
   
   use type Radar.API.Context.Service_Access;
   function Hello return AWS.Response.Data is
   begin
      return AWS.Response.Build
         (Content_Type => "application/json",
          Message_Body => "{""message"": ""Hello from Radar API!""}");
   end Hello;

   function Status return AWS.Response.Data is

      Service_Ref : constant Radar.Api.Context.Service_Access :=
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
         Current_Status : constant Radar.Engine.Engine_Status :=
            Radar.Service.Get_Status (Service_Ref.all);

         Status_Name : constant String :=
            Radar.Engine.Engine_Status'Image (Current_Status);

      begin
         return AWS.Response.Build
         (Content_Type => "application/json",
            Message_Body =>
            "{""status"":""" & Status_Name & """}");
      end;

   end Status;
end Radar.Handlers;