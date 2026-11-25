package Radar.DTO.Status is

   type Radar_Status is (Running, Paused, Stopped, Failed);

   type Status_Response is record
      Status : Radar_Status;
   end record;

end Radar.DTO.Status;