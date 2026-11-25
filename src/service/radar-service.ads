with Radar.Engine;
with Radar.Shared_State;
with Radar.Simulation;
with Radar.Detection;
with Radar.Configuration;
with Radar.DTO.Targets;
with Radar.DTO.Detection;
with Radar.DTO.Config;
with Radar.DTO.Status;

package Radar.Service is

   type Radar_Service
     (Engine : not null access Radar.Engine.Engine_Task;
      State  : not null access Radar.Engine.Engine_State;
      Shared : not null access
        Radar.Shared_State.Shared_Simulation;
      Config : not null access Radar.Configuration.Radar_Config)
   is limited private;

   procedure Pause
     (Service : in out Radar_Service;
      Success : out Boolean);

   procedure Resume
     (Service : in out Radar_Service;
      Success : out Boolean);

   procedure Stop
     (Service : in out Radar_Service;
      Success : out Boolean);

   function Get_Status
     (Service : Radar_Service)
      return Radar.Engine.Engine_Status;

   function Get_Snapshot
     (Service : Radar_Service)
      return Radar.Simulation.Simulation;

   function Get_Station
      (Service : Radar_Service)
       return Radar.Detection.Radar_Station;

   procedure Set_Station
      (Service : in out Radar_Service;
       Station : Radar.Detection.Radar_Station);

   procedure Update_Config
      (Service : in out Radar_Service;
       Request : Radar.DTO.Config.Config_Request);

   function Get_Targets
      (Service : Radar_Service) 
       return Radar.DTO.Targets.Targets_Response;

   function Get_Detections
      (Service : Radar_Service)
   return Radar.DTO.Detection.Detections_Response;

   function Get_Config
   (Service : Radar_Service)
   return Radar.DTO.Config.Config_Response;

   function Get_Status_Response
   (Service : Radar_Service)
      return Radar.DTO.Status.Status_Response;
       
private

   type Radar_Service
     (Engine : not null access Radar.Engine.Engine_Task;
      State  : not null access Radar.Engine.Engine_State;
      Shared : not null access
        Radar.Shared_State.Shared_Simulation;
      Config : not null access Radar.Configuration.Radar_Config)
   is limited null record;

end Radar.Service;
