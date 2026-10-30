with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
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

   procedure Move
      (T          : in out Target;
       Delta_Time : in Float)
   is
      use Ada.Numerics.Elementary_Functions;

      Angle : constant Float := 
         T.Heading * Ada.Numerics.Pi / 180.0;

   begin

      T.X := T.X + T.Speed * Cos (Angle) * Delta_Time;
      T.Y := T.Y + T.Speed * Sin (Angle) * Delta_Time;
      
   end Move;
end Radar.Targets;