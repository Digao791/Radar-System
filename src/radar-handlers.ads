with AWS.Response;

package Radar.Handlers is

   function Hello return AWS.Response.Data;
   function Status return AWS.Response.Data;
   function Pause return AWS.Response.Data;
   function Resume return AWS.Response.Data;
   
end Radar.Handlers;