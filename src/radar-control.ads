package Radar.Control is 

   type Simulation_Status is 
      (Running, Paused, Stopped);

   protected type Simulation_Control is

      procedure Pause;
      procedure Resume;
      procedure Stop;
      function Get_Status return Simulation_Status;
      entry Wait_Until_Active
         (Status : out Simulation_Status);

   private 

      Current_Status : Simulation_Status := Running;

   end Simulation_Control;

end Radar.Control;