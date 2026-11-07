with Ada.Numerics;
with Ada.Numerics.Float_Random;
with Ada.Text_IO;
with Ada.Real_Time;
with Ada.Exceptions;
with Radar.Configuration;
with Radar.Simulation;
with Radar.Target_Generator;
with Radar.Targets;

package body Radar.Engine is
   
   protected body Engine_State is

      procedure Set_Status (New_Status : in Engine_Status) is
      begin
         Current_Status := New_Status;
      end Set_Status;

      function Get_Status return Engine_Status is
      begin
         return Current_Status;
      end Get_Status;

   end Engine_State;

   task body Engine_Task is

      use Ada.Text_IO;
      use Ada.Real_Time;

      type Task_Status is (Running, Paused, Stopped);

      Status    : Task_Status := Running;
      Next_Time : Time := Clock + Seconds (1);
      Tick      : Natural := 0;
      Spawn_Counter : Natural := 0;
      Next_Target_ID : Positive := 1;
      Gen       : Ada.Numerics.Float_Random.Generator;
   begin

      Ada.Numerics.Float_Random.Reset (Gen);
      loop 

         if Status = Running then

            select 
               accept Pause (Success : out Boolean) do
                  Status := Paused;
                  State.Set_Status (Paused);
                  Success := True;
               end Pause;

            or

               accept Resume (Success : out Boolean) do
                  Success := False;
               end Resume;
            
            or

               accept Stop do
                  Status := Stopped;
                  State.Set_Status (Stopped);
               end Stop;

            or

               delay until Next_Time;

               Shared.Step (1.0);
               Tick := Tick + 1;

               Spawn_Counter := Spawn_Counter + 1;

               if Spawn_Counter >= 10 then
                  Spawn_Counter := 0;
               
                  declare
                     Snapshot : constant Radar.Simulation.Simulation :=
                        Shared.Get_Snapshot;
                  begin
                     if Radar.Simulation.Get_Count (Snapshot) 
                        < Radar.Simulation.Max_Targets then
                        declare
                           New_Target : constant Radar.Targets.Target :=
                              Radar.Target_Generator.Generate 
                              (ID => Next_Target_ID,
                               Station => Config.Get_Station,
                               Gen => Gen);
                        begin
                           Shared.Add_Target (New_Target);
                           Put_Line ("[ENGINE] New Target created: " 
                           & Next_Target_ID'Image);
                           Next_Target_ID := Next_Target_ID + 1;
                        end;
                     end if;
                  end;
               end if;
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
                  State.Set_Status (Running);
               end Resume;
            
            or

               accept Pause (Success : out Boolean) do
                  Success := False;
               end Pause;

            or

               accept Stop do
                  Status := Stopped;
                  State.Set_Status (Stopped);
               end Stop;

            end select;
         end if;

      exit when Status = Stopped;
      end loop;

      Put_Line ("[ENGINE] Stopped.");

   exception
      when E : others =>
         State.Set_Status (Failed);
         Put_Line ("[ENGINE] Unexpected Failure.");
         Put_Line
           ("[ENGINE] Exception: "
            & Ada.Exceptions.Exception_Information (E));
         
   end Engine_Task;  

end Radar.Engine;