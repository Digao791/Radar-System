with Ada.Text_IO;
with Ada.Real_Time;

package body Radar.Engine is
   
   task body Engine_Task is

      use Ada.Text_IO;
      use Ada.Real_Time;

      type Task_Status is (Running, Paused, Stopped);

      Status    : Task_Status := Running;
      Next_Time : Time := Clock + Seconds (1);
      Tick      : Natural := 0;

   begin

      loop 

         if Status = Running then

            select 
               accept Pause (Success : out Boolean) do
                  Status := Paused;
                  Success := True;
               end Pause;

            or

               accept Resume (Success : out Boolean) do
                  Success := False;
               end Resume;
            
            or

               accept Stop do
                  Status := Stopped;
               end Stop;
            
            or 

               accept Get_Status (Status : out Engine_Status) do
                  Status := Running;
               end Get_Status;

            or

               delay until Next_Time;

               Shared.Step (1.0);
               Tick := Tick + 1;

               Put_Line
                 ("[ENGINE] Tick:" & Tick'Image);

               Next_Time := Clock + Seconds (1);

            end select;
         
         elsif Status = Paused then

            select 
               accept Resume (Success : out Boolean) do
                  Status := Running;
                  Next_Time := Clock + Seconds (1);
                  Success := True;
               end Resume;
            
            or

               accept Pause (Success : out Boolean) do
                  Success := False;
               end Pause;

            or

               accept Stop do
                  Status := Stopped;
               end Stop;

            or

               accept Get_Status (Status : out Engine_Status) do
                  Status := Paused;
               end Get_Status;

            end select;
         end if;

      exit when Status = Stopped;
      end loop;

      Put_Line ("[ENGINE] Stopped.");
   end Engine_Task;  

end Radar.Engine;