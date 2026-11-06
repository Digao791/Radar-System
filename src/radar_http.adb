with Ada.Text_IO;
with AWS.Server;
with Radar.API;
with Radar.Shared_State;
with Radar.Engine;
with Radar.API.Context;
with Radar.Service;
with Radar.Targets;

procedure Radar_HTTP is

   use Ada.Text_IO;
   
   Web_Server : AWS.Server.HTTP;
   Shared     : aliased Radar.Shared_State.Shared_Simulation;
   State      : aliased Radar.Engine.Engine_State;
   Engine     : aliased Radar.Engine.Engine_Task
     (Shared'Access, State'Access);
   Service    : aliased Radar.Service.Radar_Service
     (Engine'Access, State'Access, Shared'Access);

     -- First target
   Target_1 : constant Radar.Targets.Target :=
     (ID      => 1,
      X       => 10.0,
      Y       => 0.0,
      Speed   => 1.0,
      Heading => 90.0);

   -- Second target
   Target_2 : constant Radar.Targets.Target :=
     (ID      => 2,
      X       => 40.0,
      Y       => 0.0,
      Speed   => 2.0,
      Heading => 180.0);

begin

   Put_Line ("=== RADAR HTTP SERVER ===");

   Shared.Initialize;
   Shared.Add_Target (Target_1);
   Shared.Add_Target (Target_2);
   Radar.API.Context.Initialize (Service'Unchecked_Access);

   AWS.Server.Start (Web_Server => Web_Server,
                     Name => "Radar HTTP Server",
                     CallBack => Radar.API.Handle_Request'Access,
                     Port => 8080);

   Put_Line ("[HTTP] Server started on port 8080.");
   Put_Line ("[HTTP] Press Enter or Ctrl+C to stop the server.");

   declare
      Dummy : constant String := Get_Line;
   begin
      null;
   end;

   AWS.Server.Shutdown (Web_Server);
   Put_Line ("[HTTP] Server stopped.");

   declare
      Success : Boolean;
   begin
      Radar.Service.Stop (Service, Success);
   end;
end Radar_HTTP;