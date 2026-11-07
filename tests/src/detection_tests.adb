with AUnit.Assertions;
with Radar.Detection;
with Radar.Targets;

package body Detection_Tests is

   use AUnit.Assertions;

   procedure Should_Calculate_Distance_Correctly (T : in out Test) is
      pragma Unreferenced (T);

      Station : constant Radar.Detection.Radar_Station :=
         (X           => 0.0,
          Y           => 0.0,
          Radar_Range => 500.0);

      Target : constant Radar.Targets.Target :=
         (ID      => 1,
          X       => 300.0,
          Y       => 400.0,
          Speed   => 0.0,
          Heading => 0.0);

      Result : constant Float :=
         Radar.Detection.Distance (Station, Target);

   begin

      Assert
        (abs (Result - 500.0) < 0.001,
         "Distance should be 500");

   end Should_Calculate_Distance_Correctly;

end Detection_Tests;