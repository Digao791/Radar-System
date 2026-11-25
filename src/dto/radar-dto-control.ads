package Radar.DTO.Control is

   type Control_Status is (Paused, Resumed);

   type Control_Response is record
      Status : Control_Status;
   end record;

end Radar.DTO.Control;