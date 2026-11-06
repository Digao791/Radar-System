with Radar.Service;

package Radar.Api.Context is

   type Service_Access is
      access all Radar.Service.Radar_Service;

   procedure Initialize
     (Service : Service_Access);
   
   function Get_Service return Service_Access;

end Radar.Api.Context;