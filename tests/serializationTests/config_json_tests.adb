with AUnit.Assertions;
with Radar.JSON;
with Radar.DTO.Config;

package body Config_JSON_Tests is

   use AUnit.Assertions;

   procedure Should_Parse_Config_Request
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Request : constant Radar.DTO.Config.Config_Request :=
        Radar.JSON.From_JSON
          ("{""x"":12.5,""y"":-4,""radar_range"":300}");
   begin
      Assert
        (abs (Request.X - 12.5) < 0.001,
         "Config request should parse x");
      Assert
        (abs (Request.Y - (-4.0)) < 0.001,
         "Config request should parse y");
      Assert
        (abs (Request.Radar_Range - 300.0) < 0.001,
         "Config request should parse radar_range");
   end Should_Parse_Config_Request;

   procedure Should_Reject_Missing_Config_Field
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Raised : Boolean := False;
   begin
      begin
         declare
            Request : constant Radar.DTO.Config.Config_Request :=
              Radar.JSON.From_JSON
                ("{""x"":0,""y"":0}");
            pragma Unreferenced (Request);
         begin
            null;
         end;
      exception
         when Radar.JSON.Invalid_Config_Request =>
            Raised := True;
      end;

      Assert
        (Raised,
         "Config request without radar_range should be rejected");
   end Should_Reject_Missing_Config_Field;

   procedure Should_Reject_Non_Numeric_Config_Field
      (T : in out Test)
   is
      pragma Unreferenced (T);
      Raised : Boolean := False;
   begin
      begin
         declare
            Request : constant Radar.DTO.Config.Config_Request :=
              Radar.JSON.From_JSON
                ("{""x"":0,""y"":0,""radar_range"":""wide""}");
            pragma Unreferenced (Request);
         begin
            null;
         end;
      exception
         when Radar.JSON.Invalid_Config_Request =>
            Raised := True;
      end;

      Assert
        (Raised,
         "Config request with a non-numeric radar_range should be rejected");
   end Should_Reject_Non_Numeric_Config_Field;

end Config_JSON_Tests;
