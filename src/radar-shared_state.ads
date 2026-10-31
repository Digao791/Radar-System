with Radar.Simulation;
with Radar.Targets;

package Radar.Shared_State is

   protected type Shared_Simulation is

      procedure Initialize;
      procedure Add_Target (T : in Radar.Targets.Target);
      procedure Step (Delta_Time : in Float);
      function Get_Snapshot return Radar.Simulation.Simulation;

   private 

      Data : Radar.Simulation.Simulation;

   end Shared_Simulation;
   
end Radar.Shared_State;