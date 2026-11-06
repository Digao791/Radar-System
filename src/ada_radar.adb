
with Ada.Text_IO;

with Radar.Targets;
with Radar.Simulation;
with Radar.Detection;
with Radar.Shared_State;
with Radar.Engine;

procedure Ada_Radar is

   use Ada.Text_IO;

   Shared : aliased
     Radar.Shared_State.Shared_Simulation;

   Station : constant Radar.Detection.Radar_Station :=
     (X           => 0.0,
      Y           => 0.0,
      Radar_Range => 30.0);

   Target_1 : constant Radar.Targets.Target :=
     (ID      => 1,
      X       => 10.0,
      Y       => 0.0,
      Speed   => 1.0,
      Heading => 90.0);

   Target_2 : constant Radar.Targets.Target :=
     (ID      => 2,
      X       => 40.0,
      Y       => 0.0,
      Speed   => 2.0,
      Heading => 180.0);

begin

   Put_Line ("=== ADA RADAR ===");

   Shared.Initialize;
   Shared.Add_Target (Target_1);
   Shared.Add_Target (Target_2);

   
declare

   Engine : Radar.Engine.Engine_Task
     (Shared'Access);

   Success : Boolean;
   Status  : Radar.Engine.Engine_Status;

begin

   Engine.Get_Status (Status);

   Put_Line
     ("[MAIN] Initial status: " & Status'Image);

   -- Invalid command: already running
   Engine.Resume (Success);

   Put_Line
     ("[MAIN] Resume accepted: " & Success'Image);

   delay 2.5;

   Engine.Pause (Success);

   Put_Line
     ("[MAIN] Pause accepted: " & Success'Image);

   Engine.Get_Status (Status);

   Put_Line
     ("[MAIN] Current status: " & Status'Image);

   -- Invalid command: already paused
   Engine.Pause (Success);

   Put_Line
     ("[MAIN] Second pause accepted: " & Success'Image);

   delay 3.0;

   Engine.Resume (Success);

   Put_Line
     ("[MAIN] Resume accepted: " & Success'Image);

   delay 3.5;

   Put_Line ("[MAIN] Stopping...");
   Engine.Stop;

end;

end Ada_Radar;
