with Ada.Text_IO;
with Radar.Detection;
with Radar.Targets;
with Radar.Simulation;

use Ada.Text_IO;

procedure Ada_Radar is

   Sim : Radar.Simulation.Simulation;
   Station : Radar.Detection.Radar_Station := 
      (X => 0.0, Y => 0.0, Radar_Range => 20.0);

   Target_1 : Radar.Targets.Target := 
      (ID => 1,
       X => 25.0,
       Y => 40.0,
       Speed => 0.25,
       Heading => 90.0
      );

   Target_2 : Radar.Targets.Target := 
      (ID => 2,
       X => 20.0,
       Y => 0.0,
       Speed => 0.30,
       Heading => 180.0
      );

   Target_3 : Radar.Targets.Target := 
      (ID => 3,
       X => -45.0,
       Y => 10.0,
       Speed => 0.10,
       Heading => 120.0
      );
begin
   Put_Line ("==== ADA RADAR ====");
   
   Radar.Simulation.Initialize (Sim);

   Radar.Simulation.Add_Target (Sim, Target_1);
   Radar.Simulation.Add_Target (Sim, Target_2);
   Radar.Simulation.Add_Target (Sim, Target_3);

   for Second in 1 .. 5 loop

      Put_Line 
         ("=== Time: " & Second'Image & " seconds");

      Radar.Simulation.Scan (Sim, Station);

      Radar.Simulation.Step (Sim, 1.0);
      Radar.Simulation.Print (Sim);
      New_Line;

   end loop;
end Ada_Radar;
