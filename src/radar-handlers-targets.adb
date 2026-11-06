with AWS.Messages;
with Radar.Api.Context;
with Radar.Service;
with Radar.Simulation;
with Radar.JSON;

package body Radar.Handlers.Targets is

   use type Radar.Api.Context.Service_Access;
   function Get_All return AWS.Response.Data is

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
         Snapshot : constant Radar.Simulation.Simulation :=
            Radar.Service.Get_Snapshot (Service_Ref.all);

      begin
         return AWS.Response.Build
         (Content_Type => "application/json",
            Message_Body =>
            Radar.JSON.To_JSON (Snapshot).Write);

      end;

   end Get_All;

end Radar.Handlers.Targets;