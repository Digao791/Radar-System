with Radar.DTO;
with Radar.DTO.Targets;

package Radar.DTO.Detection is

   type Detections_Response (Count : Natural) is record
      Detected_Targets : Radar.DTO.Targets.Target_Response_Array ( 1 .. Count );
   end record;

end Radar.DTO.Detection;