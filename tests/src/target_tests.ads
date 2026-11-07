
with AUnit.Test_Fixtures;

package Target_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Not_Move_When_Speed_Is_Zero
      (T : in out Test);

   procedure Should_Move_Horizontally
      (T : in out Test);

   procedure Should_Move_Vertically
      (T : in out Test);

   procedure Should_Move_In_Negative_Direction
      (T : in out Test);

end Target_Tests;
