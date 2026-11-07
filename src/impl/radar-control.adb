package body Radar.Control is

   protected body Simulation_Control is

      procedure Pause is
      begin
         if Current_Status = Running then
            Current_Status := Paused;
         end if;
      end Pause;

      procedure Resume is
      begin
         if Current_Status = Paused then
            Current_Status := Running;
         end if;
      end Resume;

      procedure Stop is
      begin
         Current_Status := Stopped;
      end Stop;

      function Get_Status return Simulation_Status is
      begin
         return Current_Status;
      end Get_Status;

      entry Wait_Until_Active 
         (Status : out Simulation_Status) 
         when Current_Status /= Stopped is
      begin
         Status := Current_Status;
      end Wait_Until_Active;

   end Simulation_Control; 
end Radar.Control;