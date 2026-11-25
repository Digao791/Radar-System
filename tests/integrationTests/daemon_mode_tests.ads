with AUnit.Test_Fixtures;

package Daemon_Mode_Tests is

   type Test is new AUnit.Test_Fixtures.Test_Fixture
      with null record;

   procedure Should_Serve_HTTP_In_Daemon_Mode
     (T : in out Test);

end Daemon_Mode_Tests;
