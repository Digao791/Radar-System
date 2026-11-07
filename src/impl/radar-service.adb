
package body Radar.Service is

   use type Radar.Engine.Engine_Status;
   procedure Pause
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      Success := False;

      if Service.State.Get_Status = Radar.Engine.Stopped
        or else Service.State.Get_Status = Radar.Engine.Failed
      then
         return;
      end if;

      select
         Service.Engine.Pause (Success);
      or
         delay 1.0;
         Success := False;
      end select;

   exception
      when Tasking_Error =>
         Success := False;

   end Pause;

   procedure Resume
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      Success := False;

      if Service.State.Get_Status = Radar.Engine.Stopped
        or else Service.State.Get_Status = Radar.Engine.Failed
      then
         return;
      end if;

      select
         Service.Engine.Resume (Success);
      or
         delay 1.0;
         Success := False;
      end select;

   exception
      when Tasking_Error =>
         Success := False;

   end Resume;

   procedure Stop
     (Service : in out Radar_Service;
      Success : out Boolean)
   is
   begin

      Success := False;

      if Service.State.Get_Status = Radar.Engine.Stopped
        or else Service.State.Get_Status = Radar.Engine.Failed
      then
         return;
      end if;

      select
         Service.Engine.Stop;
         Success := True;
      or
         delay 1.0;
         Success := False;
      end select;

   exception
      when Tasking_Error =>
         Success := False;

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

   function Get_Station
   (Service : Radar_Service)
      return Radar.Detection.Radar_Station
   is
   begin
      return Service.Config.Get_Station;
   end Get_Station;


   procedure Set_Station
   (Service : in out Radar_Service;
      Station : Radar.Detection.Radar_Station)
   is
   begin
      Service.Config.Set_Station (Station);
   end Set_Station;

end Radar.Service;
