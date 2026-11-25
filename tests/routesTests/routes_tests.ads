with AUnit.Test_Fixtures;

package Routes_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Resolve_Put_Config_Request
      (T : in out Test);

   procedure Should_Reject_Post_To_Config_Request
      (T : in out Test);

end Routes_Tests;
