with Ada.Numerics;
with Ada.Numerics.Float_Random;
with Radar.Detection;
with Radar.Targets;
package Radar.Target_Generator is
   
   function Generate
      (ID  : Positive;
       Station : Radar.Detection.Radar_Station;
       Gen     : in out Ada.Numerics.Float_Random.Generator)
   return Radar.Targets.Target;
   
end Radar.Target_Generator;