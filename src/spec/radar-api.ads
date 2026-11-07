with AWS.Status;
with AWS.Response;

package Radar.API is

   function Handle_Request
     (Request : AWS.Status.Data)
      return AWS.Response.Data;

end Radar.API;