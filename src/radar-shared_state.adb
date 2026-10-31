package body Radar.Shared_State is

   protected body Shared_Simulation is 

      procedure Initialize is 
      begin
         Radar.Simulation.Initialize (Data);
      end Initialize;

      procedure Add_Target (T : in Radar.Targets.Target) is
      begin
         Radar.Simulation.Add_Target (Data, T);
      end Add_Target;

      procedure Step (Delta_Time : in Float) is
      begin
         Radar.Simulation.Step (Data, Delta_Time);
      end Step;

      function Get_Snapshot return Radar.Simulation.Simulation
      is
      begin
         return Data;
      end Get_Snapshot;
      
   end Shared_Simulation;

end Radar.Shared_State;