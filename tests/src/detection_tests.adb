
with AUnit.Assertions;
with Radar.Detection;
with Radar.Targets;

package body Detection_Tests is

   use AUnit.Assertions;

   Station : constant Radar.Detection.Radar_Station :=
      (X           => 0.0,
       Y           => 0.0,
       Radar_Range => 500.0);

   function Create_Target
      (X, Y : Float) return Radar.Targets.Target
   is
   begin
      return
         (ID      => 1,
          X       => X,
          Y       => Y,
          Speed   => 0.0,
          Heading => 0.0);
   end Create_Target;

   procedure Should_Calculate_Distance_Correctly
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (300.0, 400.0);

      Result : constant Float :=
         Radar.Detection.Distance (Station, Target);

   begin
      Assert
        (abs (Result - 500.0) < 0.001,
         "Expected distance of 500");
   end Should_Calculate_Distance_Correctly;


   procedure Should_Calculate_Zero_Distance
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (0.0, 0.0);

   begin
      Assert
        (abs (Radar.Detection.Distance (Station, Target))
           < 0.001,
         "Expected distance of zero");
   end Should_Calculate_Zero_Distance;


   procedure Should_Calculate_Distance_With_Negative_Coordinates
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (-300.0, -400.0);

   begin
      Assert
        (abs (Radar.Detection.Distance (Station, Target)
              - 500.0) < 0.001,
         "Expected distance of 500 with negative coordinates");
   end Should_Calculate_Distance_With_Negative_Coordinates;


   procedure Should_Detect_Target_When_Inside_Range
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (100.0, 200.0);

   begin
      Assert
        (Radar.Detection.Is_Detected (Station, Target),
         "Target inside range should be detected");
   end Should_Detect_Target_When_Inside_Range;


   procedure Should_Not_Detect_Target_When_Outside_Range
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (600.0, 400.0);

   begin
      Assert
        (not Radar.Detection.Is_Detected (Station, Target),
         "Target outside range should not be detected");
   end Should_Not_Detect_Target_When_Outside_Range;


   procedure Should_Detect_Target_When_On_Range_Boundary
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : constant Radar.Targets.Target :=
         Create_Target (500.0, 0.0);

   begin
      Assert
        (Radar.Detection.Is_Detected (Station, Target),
         "Target on range boundary should be detected");
   end Should_Detect_Target_When_On_Range_Boundary;

end Detection_Tests;
