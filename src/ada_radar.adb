with Ada.Text_IO;
with Radar.Detection;
with Radar.Targets;
with Radar.Simulation;
with Radar.Shared_State;

use Ada.Text_IO;

procedure Ada_Radar is

   Shared : Radar.Shared_State.Shared_Simulation;
   Station : constant Radar.Detection.Radar_Station
      := (X => 0.0, Y => 0.0, Radar_Range => 30.0);
   
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

   Put_Line ("===== ADA RADAR ======");
   Shared.Initialize;

   Shared.Add_Target (Target_1);
   Shared.Add_Target (Target_2);

   for Second in 1 .. 6 loop

      Put_Line ("=== Time: " & Second'Image & " seconds");

      declare
         Snapshot : constant Radar.Simulation.Simulation :=
            Shared.Get_Snapshot;
      begin
         Radar.Simulation.Scan (Snapshot, Station);
      end;

      Shared.Step (1.0);

   end loop;

end Ada_Radar;
