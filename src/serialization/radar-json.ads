with Radar.Targets;
with GNATCOLL.JSON;
with Radar.Simulation;
with Radar.DTO.Targets;
with Radar.DTO.Detection;
with Radar.DTO.Config;

package Radar.JSON is

   function To_JSON (Target : Radar.Targets.Target)
    return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Target : Radar.DTO.Targets.Target_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Response : Radar.DTO.Targets.Targets_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Response : Radar.DTO.Detection.Detections_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Response : Radar.DTO.Config.Config_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON (Sim : Radar.Simulation.Simulation)
    return GNATCOLL.JSON.JSON_Value;
    
end Radar.JSON;