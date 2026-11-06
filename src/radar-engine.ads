with Radar.Shared_State;

package Radar.Engine is

   type Engine_Status is (Running, Paused, Stopped);
   task type Engine_Task 
      (Shared : not null access
         Radar.Shared_State.Shared_Simulation) 
   is
      entry Pause (Success : out Boolean);
      entry Resume (Success : out Boolean);
      entry Stop;
      entry Get_Status (Status : out Engine_Status);
   end Engine_Task;

end Radar.Engine;