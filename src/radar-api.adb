with AWS.Status;
with AWS.Response;
with AWS.Messages;

with Radar.Routes;
with Radar.Handlers;

package body Radar.API is

   function Handle_Request
     (Request : AWS.Status.Data)
      return AWS.Response.Data
   is
      URI : constant String :=
        AWS.Status.URI (Request);

      Method : constant String :=
        AWS.Status.Method (Request);

      Route : constant Radar.Routes.Route_Type :=
        Radar.Routes.Resolve (Method, URI);

   begin

      case Route is

         when Radar.Routes.Hello =>
            return Radar.Handlers.Hello;

         when Radar.Routes.Get_Status =>
            return Radar.Handlers.Status;

         when Radar.Routes.Pause_Radar =>
            return Radar.Handlers.Pause;

         when Radar.Routes.Resume_Radar =>
            return Radar.Handlers.Resume;
            
         when Radar.Routes.Get_Targets =>

            return AWS.Response.Build
              (Content_Type => "application/json",
               Message_Body =>
                 "{""error"":""Endpoint not implemented""}",
               Status_Code => AWS.Messages.S501);

         when Radar.Routes.Not_Found =>
            return AWS.Response.Build
              (Content_Type => "application/json",
               Message_Body =>
                 "{""error"":""Endpoint not found""}",
               Status_Code => AWS.Messages.S404);

      end case;

   end Handle_Request;

end Radar.API;