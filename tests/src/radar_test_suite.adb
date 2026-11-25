
with AUnit.Test_Caller;
with AUnit.Test_Suites;
with Detection_Tests;
with Simulation_Tests;
with Target_Tests;

package body Radar_Test_Suite is

   package Caller is new AUnit.Test_Caller
      (Detection_Tests.Test);

   package Target_Caller is new AUnit.Test_Caller
   (Target_Tests.Test);

   package Simulation_Caller is new AUnit.Test_Caller
      (Simulation_Tests.Test);

   function Suite return AUnit.Test_Suites.Access_Test_Suite is

      Result : constant AUnit.Test_Suites.Access_Test_Suite :=
         AUnit.Test_Suites.New_Suite;

   begin

      Result.Add_Test
        (Caller.Create
           ("Should calculate distance correctly",
            Detection_Tests.Should_Calculate_Distance_Correctly'Access));

      Result.Add_Test
        (Caller.Create
           ("Should calculate zero distance",
            Detection_Tests.Should_Calculate_Zero_Distance'Access));

      Result.Add_Test
        (Caller.Create
           ("Should calculate distance with negative coordinates",
            Detection_Tests.Should_Calculate_Distance_With_Negative_Coordinates'Access));

      Result.Add_Test
        (Caller.Create
           ("Should detect target inside range",
            Detection_Tests.Should_Detect_Target_When_Inside_Range'Access));

      Result.Add_Test
        (Caller.Create
           ("Should not detect target outside range",
            Detection_Tests.Should_Not_Detect_Target_When_Outside_Range'Access));

      Result.Add_Test
        (Caller.Create
           ("Should detect target on range boundary",
            Detection_Tests.Should_Detect_Target_When_On_Range_Boundary'Access));

            
      Result.Add_Test
      (Target_Caller.Create
         ("Should not move when speed is zero",
            Target_Tests.Should_Not_Move_When_Speed_Is_Zero'Access));

      Result.Add_Test
      (Target_Caller.Create
         ("Should move horizontally",
            Target_Tests.Should_Move_Horizontally'Access));

      Result.Add_Test
      (Target_Caller.Create
         ("Should move vertically",
            Target_Tests.Should_Move_Vertically'Access));

      Result.Add_Test
      (Target_Caller.Create
         ("Should move in negative direction",
            Target_Tests.Should_Move_In_Negative_Direction'Access));

      Result.Add_Test
        (Simulation_Caller.Create
           ("Should initialize empty simulation",
            Simulation_Tests.Should_Initialize_Empty_Simulation'Access));

      Result.Add_Test
        (Simulation_Caller.Create
           ("Should add retrieve and count targets",
            Simulation_Tests.Should_Add_Retrieve_And_Count_Targets'Access));

      Result.Add_Test
        (Simulation_Caller.Create
           ("Should step all targets",
            Simulation_Tests.Should_Step_All_Targets'Access));

      Result.Add_Test
        (Simulation_Caller.Create
           ("Should reject invalid target index",
            Simulation_Tests.Should_Reject_Invalid_Target_Index'Access));


      return Result;

   end Suite;

end Radar_Test_Suite;
