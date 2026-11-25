with AUnit.Assertions;
with Radar.Routes;

package body Routes_Tests is

   use AUnit.Assertions;
   use type Radar.Routes.Route_Type;

   procedure Should_Resolve_Put_Config_Request
      (T : in out Test)
   is
      pragma Unreferenced (T);
   begin
      Assert
        (Radar.Routes.Resolve
           ("PUT", "/api/radar/config") = Radar.Routes.Update_Config,
         "PUT config should resolve to the config update route");
   end Should_Resolve_Put_Config_Request;

   procedure Should_Reject_Post_To_Config_Request
      (T : in out Test)
   is
      pragma Unreferenced (T);
   begin
      Assert
        (Radar.Routes.Resolve
           ("POST", "/api/radar/config") = Radar.Routes.Not_Found,
         "POST config should not resolve to an implemented route");
   end Should_Reject_Post_To_Config_Request;

end Routes_Tests;
