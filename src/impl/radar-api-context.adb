with Radar.Service;

package body Radar.Api.Context is

   Service_Ref : Service_Access := null;
   
   procedure Initialize
     (Service : Service_Access) is
   begin
      Service_Ref := Service;
   end Initialize;

   function Get_Service return Service_Access is
   begin
      return Service_Ref;
   end Get_Service;

end Radar.Api.Context;