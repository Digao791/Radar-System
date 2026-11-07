
with AUnit.Assertions;
with Radar.Targets;

package body Target_Tests is

   use AUnit.Assertions;

   Tolerance : constant Float := 0.001;

   procedure Should_Not_Move_When_Speed_Is_Zero
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : Radar.Targets.Target :=
         (ID      => 1,
          X       => 100.0,
          Y       => 200.0,
          Speed   => 0.0,
          Heading => 45.0);

   begin
      Radar.Targets.Move (Target, 10.0);

      Assert
        (abs (Target.X - 100.0) < Tolerance,
         "X should remain unchanged");

      Assert
        (abs (Target.Y - 200.0) < Tolerance,
         "Y should remain unchanged");

   end Should_Not_Move_When_Speed_Is_Zero;


   procedure Should_Move_Horizontally
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : Radar.Targets.Target :=
         (ID      => 1,
          X       => 0.0,
          Y       => 0.0,
          Speed   => 10.0,
          Heading => 0.0);

   begin
      Radar.Targets.Move (Target, 5.0);

      Assert
        (abs (Target.X - 50.0) < Tolerance,
         "X should be 50");

      Assert
        (abs (Target.Y) < Tolerance,
         "Y should remain zero");

   end Should_Move_Horizontally;


   procedure Should_Move_Vertically
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : Radar.Targets.Target :=
         (ID      => 1,
          X       => 0.0,
          Y       => 0.0,
          Speed   => 10.0,
          Heading => 90.0);

   begin
      Radar.Targets.Move (Target, 5.0);

      Assert
        (abs (Target.X) < Tolerance,
         "X should remain zero");

      Assert
        (abs (Target.Y - 50.0) < Tolerance,
         "Y should be 50");

   end Should_Move_Vertically;


   procedure Should_Move_In_Negative_Direction
      (T : in out Test)
   is
      pragma Unreferenced (T);

      Target : Radar.Targets.Target :=
         (ID      => 1,
          X       => 0.0,
          Y       => 0.0,
          Speed   => 10.0,
          Heading => 180.0);

   begin
      Radar.Targets.Move (Target, 5.0);

      Assert
        (abs (Target.X + 50.0) < Tolerance,
         "X should be -50");

      Assert
        (abs (Target.Y) < Tolerance,
         "Y should remain zero");

   end Should_Move_In_Negative_Direction;

end Target_Tests;
