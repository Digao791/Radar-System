package body Radar.Routes is

   Hello_Path : constant String := "/api/radar/hello";
   Status_Path : constant String := "/api/radar/status";
   Targets_Path : constant String := "/api/radar/targets";
   Detections_Path : constant String := "/api/radar/detections";
   Pause_Path : constant String := "/api/radar/pause";
   Resume_Path : constant String := "/api/radar/resume";
   Config_Path : constant String := "/api/radar/config";

   function Resolve (Method : String; URI : String) return Route_Type is
   begin
      if Method = "GET" and then URI = Hello_Path then
         return Hello;
      elsif Method = "GET" and then URI = Status_Path then
         return Get_Status;
      elsif Method = "GET" and then URI = Targets_Path then
         return Get_Targets;
      elsif Method = "GET" and then URI = Detections_Path then
         return Get_Detections;
      elsif Method = "GET" and then URI = Config_Path then
            return Get_Config;
      elsif Method = "POST" and then URI = Pause_Path then
         return Pause_Radar;
      elsif Method = "POST" and then URI = Resume_Path then
         return Resume_Radar;
      else
         return Not_Found;
      end if;

   end Resolve;

end Radar.Routes;