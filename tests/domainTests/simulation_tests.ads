with AUnit.Test_Fixtures;

package Simulation_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Initialize_Empty_Simulation
      (T : in out Test);

   procedure Should_Add_Retrieve_And_Count_Targets
      (T : in out Test);

   procedure Should_Step_All_Targets
      (T : in out Test);

   procedure Should_Reject_Invalid_Target_Index
      (T : in out Test);

end Simulation_Tests;
