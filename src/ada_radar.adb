with Ada.Text_IO;
with Radar.Targets;
with Radar.Simulation;

use Ada.Text_IO;

procedure Ada_Radar is

   Sim : Radar.Simulation.Simulation;

   Target_1 : Radar.Targets.Target := 
      (ID => 1,
       X => 25.0,
       Y => 40.0,
       Speed => 0.25,
       Heading => 90.0
      );

   Target_2 : Radar.Targets.Target := 
      (ID => 2,
       X => -15.0,
       Y => 30.0,
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

   New_Line;

   Put_Line ("Initial State");

   Radar.Simulation.Print (Sim);

   for Second in 1 .. 5 loop

      Radar.Simulation.Step 
         (Sim  => Sim,
          Delta_Time => 1.0);
      
      New_Line;

      Put_Line 
         ("=== Time: " & Second'Image & " seconds");

      Radar.Simulation.Print (Sim);
   end loop;
end Ada_Radar;
