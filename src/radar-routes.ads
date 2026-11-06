package Radar.Routes is 

   type Route_Type is 
      (Hello, Get_Status, Get_Targets, Pause_Radar,
         Resume_Radar, Not_Found);

   function Resolve (Method : String; URI : String) return Route_Type;

end Radar.Routes;