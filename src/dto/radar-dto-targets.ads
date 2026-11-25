package Radar.DTO.Targets is

   type Target_Response is record
      ID : Positive;
      X  : Float;
      Y  : Float;
      Speed : Float;
      Heading : Float;
   end record;

   type Target_Response_Array is 
      array (Positive range <>) of Target_Response;

   type Targets_Response (Count : Natural) is record
      Targets: Target_Response_Array(1 .. Count);
   end record;

end Radar.DTO.Targets;