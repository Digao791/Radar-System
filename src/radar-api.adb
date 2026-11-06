with AWS.Status;
with AWS.Response;
with AWS.Messages;

package body Radar.API is

   function Handle_Request
     (Request : AWS.Status.Data)
      return AWS.Response.Data
   is
      URI : constant String := AWS.Status.URI (Request);
   begin

      if URI = "/api/radar/hello" then
         return AWS.Response.Build
            (Content_Type => "application/json",
             Message_Body      => "{""message"": ""Hello from Radar API!""}");
      else

            return AWS.Response.Build
               (Content_Type => "application/json",
                Message_Body => "{""error"": ""Endpoint not found""}",
                Status_Code  => AWS.Messages.S404);
      end if;
   end Handle_Request;
end Radar.API;