with Radar.Targets;
with GNATCOLL.JSON;
with Radar.Simulation;
with Radar.DTO.Targets;

package Radar.JSON is

   function To_JSON (Target : Radar.Targets.Target)
    return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Target : Radar.DTO.Targets.Target_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON
   (Response : Radar.DTO.Targets.Targets_Response)
   return GNATCOLL.JSON.JSON_Value;

   function To_JSON (Sim : Radar.Simulation.Simulation)
    return GNATCOLL.JSON.JSON_Value;
    
end Radar.JSON;