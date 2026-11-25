with Radar.Targets;

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

   function To_Response
   (Target: Radar.Targets.Target) return Radar.DTO.Targets.Target_Response 
   is
   begin
      return (
         ID => Target.ID, 
         X => Target.X, 
         Y => Target.Y, 
         Speed => Target.Speed, 
         Heading => Target.Heading);
   end To_Response;   
   
   function Get_Targets
      (Service : Radar_Service) return Radar.DTO.Targets.Targets_Response
      is
         Snapshot : constant Radar.Simulation.Simulation := Get_Snapshot (Service);
         Count    : constant Natural := Radar.Simulation.Get_Count (Snapshot);
         Result   : Radar.DTO.Targets.Targets_Response (Count);
      begin
         for I in 1 .. Count loop
            Result.Targets (I) := To_Response(Radar.Simulation.Get_Target_At (Snapshot, I));
         end loop;

         return Result;
      end Get_Targets;

   function Get_Detections
   (Service : Radar_Service)
      return Radar.DTO.Detection.Detections_Response
   is
      Snapshot : constant Radar.Simulation.Simulation :=
         Get_Snapshot (Service);

      Station : constant Radar.Detection.Radar_Station :=
         Get_Station (Service);

      Count : constant Natural :=
         Radar.Simulation.Get_Count (Snapshot);

      Items : Radar.DTO.Targets.Target_Response_Array (1 .. Count);

      Detected_Count : Natural := 0;

   begin
      for I in 1 .. Count loop
         declare
            Target : constant Radar.Targets.Target :=
               Radar.Simulation.Get_Target_At (Snapshot, I);
         begin
            if Radar.Detection.Is_Detected (Station, Target) then
               Detected_Count := Detected_Count + 1;

               Items (Detected_Count) := To_Response (Target);
            end if;
         end;
      end loop;

      return
      (Count            => Detected_Count,
         Detected_Targets => Items (1 .. Detected_Count));

   end Get_Detections;

   function Get_Config
   (Service : Radar_Service)
      return Radar.DTO.Config.Config_Response
   is
      Station : constant Radar.Detection.Radar_Station :=
         Get_Station (Service);

   begin
      return
      (X           => Station.X,
         Y           => Station.Y,
         Radar_Range => Station.Radar_Range);

   end Get_Config;

   function Get_Status_Response
   (Service : Radar_Service)
      return Radar.DTO.Status.Status_Response
   is
      Current_Status : constant Radar.Engine.Engine_Status :=
         Get_Status (Service);

   begin
      case Current_Status is

         when Radar.Engine.Running =>
            return (Status => Radar.DTO.Status.Running);

         when Radar.Engine.Paused =>
            return (Status => Radar.DTO.Status.Paused);

         when Radar.Engine.Stopped =>
            return (Status => Radar.DTO.Status.Stopped);

         when Radar.Engine.Failed =>
            return (Status => Radar.DTO.Status.Failed);

      end case;
   end Get_Status_Response;

end Radar.Service;
