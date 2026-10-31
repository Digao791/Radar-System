with Ada.Text_IO;
with Radar.Detection;
with Radar.Targets;
with Radar.Simulation;
with Radar.Shared_State;
with Ada.Real_Time;

use Ada.Text_IO;
use Ada.Real_Time;

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

   declare

      Start_Time : constant Time := Clock;
      
      task Simulation_Task;
      task body Simulation_Task is
         Next_Time : Time := Start_Time;
      begin
         for Second in 1 .. 5 loop

            Next_Time := Next_Time + Seconds (1);
            delay until Next_Time;
            Shared.Step (1.0);

            Put_Line ("[SIMULATION] Tick: " & Second'Image);
         end loop;
      end Simulation_Task;

   begin

      for Second in 0 .. 5 loop
         delay until
            Start_Time
            + Milliseconds (500)
            + Seconds (Second);

         declare
            Snapshot : Radar.Simulation.Simulation :=
               Shared.Get_Snapshot;
         begin
            Put_Line ("[RADAR] Scan: " & Second'Image);
            Radar.Simulation.Scan (Snapshot, Station);
            New_Line;
         end;
      end loop;
   end;
   
   Put_Line ("Simulation Finished.");
end Ada_Radar;
