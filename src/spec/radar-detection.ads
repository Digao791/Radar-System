with Radar.Targets;

package Radar.Detection is

   type Radar_Station is record
      X           : Float;
      Y           : Float;
      Radar_Range : Float;
   end record;

   function Distance
      (Station : Radar_Station;
       T       : Radar.Targets.Target)
      return Float;

   function Is_Detected
      (Station : Radar_Station;
       T       : Radar.Targets.Target)
       return Boolean;

end Radar.Detection;