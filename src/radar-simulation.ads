with Radar.Targets;
with Radar.Detection;

package Radar.Simulation is

   Max_Targets : constant Positive := 10;

   type Target_Array is
      array (Positive range 1 .. Max_Targets)
         of Radar.Targets.Target;
   
   type Simulation is private;

   procedure Initialize (Sim : out Simulation);

   procedure Add_Target (Sim : in out Simulation;
                         T   : in Radar.Targets.Target);
   
   procedure Step 
      (Sim        : in out Simulation;
       Delta_Time : in Float);
      
   procedure Scan
      (Sim        : in Simulation;
       Station    : Radar.Detection.Radar_Station);
      
   procedure Print (Sim : in Simulation);

private

   type Simulation is record
      Targets : Target_Array := 
         (others => 
            (ID => 1,
             X => 0.0,
             Y => 0.0,
             Speed => 0.0,
             Heading => 0.0));

      Count : Natural := 0;
   end record;
end Radar.Simulation;