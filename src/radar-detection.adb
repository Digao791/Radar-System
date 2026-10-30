with Ada.Numerics.Elementary_Functions;

package body Radar.Detection is

   function Distance
      (Station    : Radar_Station;
       T          : Radar.Targets.Target)
       return Float
   is
      use Ada.Numerics.Elementary_Functions;

      DX : constant Float := T.X - Station.X;
      DY : constant Float := T.Y - Station.Y;

   begin
      return Sqrt (DX * DX + DY * DY);
   end Distance;

   function Is_Detected 
      (Station    : Radar_Station;
       T          : Radar.Targets.Target)
       return Boolean
   is
   begin
      return Distance (Station, T) <= Station.Radar_Range;
   end Is_Detected;
end Radar.Detection;