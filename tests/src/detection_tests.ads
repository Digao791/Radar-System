with AUnit.Test_Fixtures;

package Detection_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Calculate_Distance_Correctly (T : in out Test);

end Detection_Tests;