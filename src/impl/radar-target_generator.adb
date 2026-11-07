with Ada.Numerics.Elementary_Functions;
package body Radar.Target_Generator is

   function Generate 
      (ID    : Positive;
       Station : Radar.Detection.Radar_Station;
       Gen     : in out Ada.Numerics.Float_Random.Generator)
   return Radar.Targets.Target 
   is
      use Ada.Numerics;
      use Ada.Numerics.Elementary_Functions;
      use Ada.Numerics.Float_Random;

      Angle    : constant Float :=  
         Random (Gen) * 2.0 * Pi;

      Distance : constant Float :=  
         sqrt (Random (Gen)) * Station.Radar_Range;
      
      Speed : constant Float := 
         1.0 + Random (Gen) * 9.0;
      
      Heading : constant Float :=
         Random (Gen) * 360.0;

   begin

      return (ID      => ID,
              X       => Station.X + Distance * Cos (Angle),
              Y       => Station.Y + Distance * Sin (Angle),
              Speed   => Speed,
              Heading => Heading);
   end Generate;
end Radar.Target_Generator;