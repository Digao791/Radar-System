with Radar.Targets;
with GNATCOLL.JSON;
with Radar.Simulation;

package Radar.JSON is

   function To_JSON (Target : Radar.Targets.Target)
    return GNATCOLL.JSON.JSON_Value;

   function To_JSON (Sim : Radar.Simulation.Simulation)
    return GNATCOLL.JSON.JSON_Value;
    
end Radar.JSON;