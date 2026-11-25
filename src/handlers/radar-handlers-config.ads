with AWS.Response;
with AWS.Status;

package Radar.Handlers.Config is

   function Get return AWS.Response.Data;
   function Update (Request : AWS.Status.Data)
      return AWS.Response.Data;

end Radar.Handlers.Config;