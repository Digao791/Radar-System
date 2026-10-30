package Radar.Targets is

   type Target is record
      ID       : Positive;
      X        : Float;
      Y        : Float;
      Speed    : Float;
      Heading  : Float;
   end record;

   procedure Print (T : Target);

   procedure Move 
      (T : in out Target; 
       Delta_Time : in Float);

end Radar.Targets;