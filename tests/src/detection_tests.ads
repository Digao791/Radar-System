
with AUnit.Test_Fixtures;

package Detection_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Calculate_Distance_Correctly
      (T : in out Test);

   procedure Should_Calculate_Zero_Distance
      (T : in out Test);

   procedure Should_Calculate_Distance_With_Negative_Coordinates
      (T : in out Test);

   procedure Should_Detect_Target_When_Inside_Range
      (T : in out Test);

   procedure Should_Not_Detect_Target_When_Outside_Range
      (T : in out Test);

   procedure Should_Detect_Target_When_On_Range_Boundary
      (T : in out Test);

end Detection_Tests;
