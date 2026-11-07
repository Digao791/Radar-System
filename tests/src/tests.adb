with AUnit;
with AUnit.Run;
with AUnit.Reporter.Text;
with Radar_Test_Suite;

procedure Tests is

   use type AUnit.Status;

   function Run is new AUnit.Run.Test_Runner_With_Status
      (Radar_Test_Suite.Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;

begin

   if Run (Reporter) /= AUnit.Success then
      raise Program_Error with "Unit tests failed";
   end if;

end Tests;