with Radar.Shared_State;

package Radar.Engine is

   type Engine_Status is (Running, Paused, Stopped);

   protected type Engine_State is

      procedure Set_Status (New_Status : in Engine_Status);
      function Get_Status return Engine_Status;

   private
   
      Current_Status : Engine_Status := Running;

   end Engine_State;

   task type Engine_Task 
      (Shared : not null access
         Radar.Shared_State.Shared_Simulation;
         State : not null access Engine_State) 
   is
      entry Pause (Success : out Boolean);
      entry Resume (Success : out Boolean);
      entry Stop;
      
   end Engine_Task;

end Radar.Engine;