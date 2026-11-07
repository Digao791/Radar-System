with AWS.Messages;
with GNATCOLL.JSON;

with Radar.API.Context;
with Radar.Service;
with Radar.Simulation;
with Radar.Targets;
with Radar.Detection;
with Radar.JSON;
with Radar.Detection;
package body Radar.Handlers.Detection is

   use GNATCOLL.JSON;
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
         Snapshot : constant Radar.Simulation.Simulation :=
            Radar.Service.Get_Snapshot (Service_Ref.all);

         Result : JSON_Value := Create_Object;
         Items  : JSON_Array := Empty_Array;
         Count  : constant Natural    := Radar.Simulation.Get_Count (Snapshot);
         Station : constant Radar.Detection.Radar_Station :=
            Radar.Service.Get_Station (Service_Ref.all);

      begin
         for I in 1 .. Count loop
            declare
               Target : constant Radar.Targets.Target :=
                  Radar.Simulation.Get_Target_At (Snapshot, I);
            begin
               if Radar.Detection.Is_Detected (Station, Target) then
                  Append (Items, Radar.JSON.To_JSON (Target));
               end if;
            end;
         end loop;

         Result.Set_Field ("detected_targets", Items);

         return AWS.Response.Build
         (Content_Type => "application/json",
            Message_Body =>
            Result.Write);

      end;
   end Get_All;

end Radar.Handlers.Detection;