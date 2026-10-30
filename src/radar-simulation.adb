with Ada.Text_IO;
with Radar.Targets;

use Ada.Text_IO;

package body Radar.Simulation is

   procedure Initialize (Sim : out Simulation) is
   begin
      Sim.Count := 0;
   end Initialize;

   procedure Add_Target
      (Sim        : in out Simulation;
       T          : in Radar.Targets.Target)
   is
   begin
   
      if Sim.Count < Max_Targets then
         Sim.Count := Sim.Count + 1;
         Sim.Targets (Sim.Count) := T;
      else
         Put_Line ("Simulation Capacity reached.");

      end if;
   end Add_Target;

   procedure Step
      (Sim        : in out Simulation;
       Delta_Time : in Float) 
   is
   begin

      for I in 1 .. Sim.Count loop

         Radar.Targets.Move 
            (T    => Sim.Targets (I),
             Delta_Time => Delta_Time);
            
      end loop;
   end Step;


   procedure Scan 
      (Sim     : in Simulation;
       Station : in Radar.Detection.Radar_Station)
   is
      Count : Natural := 0;
   begin
      Put_Line ("==== RADAR SCAN ====");

      for I in 1 .. Sim.Count loop
         if Radar.Detection.Is_Detected 
            (Station, Sim.Targets (I)) then

            Put_Line ("Target detected: "
            & Sim.Targets (I).ID'Image);

            Count := Count + 1;
         end if;
      end loop;

      if Count = 0 then
         Put_Line ("No target detected");
      end if;
   end Scan;

   procedure Print (Sim : in Simulation) is
   begin
      Put_Line ("Targets : " & Sim.Count'Image);
      
      for I in 1 .. Sim.Count loop

         New_Line;
         Radar.Targets.Print (Sim.Targets (I));

      end loop;
   end Print;
end Radar.Simulation;
