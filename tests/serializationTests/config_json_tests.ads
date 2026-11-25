with AUnit.Test_Fixtures;

package Config_JSON_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Parse_Config_Request
      (T : in out Test);

   procedure Should_Reject_Missing_Config_Field
      (T : in out Test);

   procedure Should_Reject_Non_Numeric_Config_Field
      (T : in out Test);

end Config_JSON_Tests;
