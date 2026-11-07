with AUnit.Test_Caller;
with AUnit.Test_Suites;
with Detection_Tests;

package body Radar_Test_Suite is

   package Caller is new AUnit.Test_Caller
      (Detection_Tests.Test);

   function Suite return AUnit.Test_Suites.Access_Test_Suite is

      Result : constant AUnit.Test_Suites.Access_Test_Suite :=
         AUnit.Test_Suites.New_Suite;

   begin

      Result.Add_Test
        (Caller.Create
           ("Should calculate distance correctly",
            Detection_Tests.Should_Calculate_Distance_Correctly'Access));

      return Result;

   end Suite;

end Radar_Test_Suite;