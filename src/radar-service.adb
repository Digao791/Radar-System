
package body Radar.Service is

   use type Radar.Engine.Engine_Status;
   procedure Pause
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      if Service.State.Get_Status = Radar.Engine.Running then
         Service.Engine.Pause (Success);
      else
         Success := False;
      end if;

   end Pause;

   procedure Resume
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      if Service.State.Get_Status = Radar.Engine.Paused then
         Service.Engine.Resume (Success);
      else
         Success := False;
      end if;

   end Resume;

   procedure Stop
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      if Service.State.Get_Status = Radar.Engine.Running
        or else Service.State.Get_Status = Radar.Engine.Paused
      then

         Service.Engine.Stop;
         Success := True;

      else
         Success := False;
      end if;

   end Stop;

   function Get_Status
     (Service : Radar_Service)
      return Radar.Engine.Engine_Status
   is
   begin
      return Service.State.Get_Status;
   end Get_Status;

   function Get_Snapshot
     (Service : Radar_Service)
      return Radar.Simulation.Simulation
   is
   begin
      return Service.Shared.Get_Snapshot;
   end Get_Snapshot;

end Radar.Service;
