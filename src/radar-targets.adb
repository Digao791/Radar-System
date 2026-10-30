with Ada.Text_IO;
use Ada.Text_IO;

package body Radar.Targets is

   procedure Print (T : Target) is
   begin
      Put_Line ("Target ID : " & T.ID'Image);
      Put_Line ("Position X: " & T.X'Image);
      Put_Line ("Position Y: " & T.Y'Image);
      Put_Line ("Speed     : " & T.Speed'Image);
      Put_Line ("Heading   : " & T.Heading'Image);
   end Print;
end Radar.Targets;