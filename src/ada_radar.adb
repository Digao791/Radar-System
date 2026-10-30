with Ada.Text_IO;
with Radar.Targets;
use Ada.Text_IO;

procedure Ada_Radar is

   Target_1 : Radar.Targets.Target := 
      (ID => 1,
       X => 25.0,
       Y => 40.0,
       Speed => 0.25,
       Heading => 90.0
      );

   Target_2 : Radar.Targets.Target := 
      (ID => 2,
       X => -15.0,
       Y => 30.0,
       Speed => 0.30,
       Heading => 180.0
      );
begin
   Put_Line ("==== ADA RADAR ====");
   New_Line;

   Radar.Targets.Print (Target_1);
   New_Line;
   Radar.Targets.Print (Target_2);

end Ada_Radar;
