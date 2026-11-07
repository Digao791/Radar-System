package Radar.Routes is 

   type Route_Type is 
      (Hello, Get_Status, Get_Targets, Get_Detections, Pause_Radar,
         Resume_Radar, Get_Config, Not_Found);

   function Resolve (Method : String; URI : String) return Route_Type;

end Radar.Routes;