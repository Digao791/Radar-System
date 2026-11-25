with AWS.Messages;
with AWS.Response;
with Radar.API.Context;
with Radar.Service;
with Radar.DTO.Status;
with Radar.JSON;

package body Radar.Handlers is 
   
   use type Radar.API.Context.Service_Access;
   function Hello return AWS.Response.Data is
   begin
      return AWS.Response.Build
         (Content_Type => "application/json",
          Message_Body => "{""message"": ""Hello from Radar API!""}");
   end Hello;

   function Status return AWS.Response.Data is

      Service_Ref : constant Radar.API.Context.Service_Access :=
         Radar.API.Context.Get_Service;

   begin
      if Service_Ref = null then
         return AWS.Response.Build
         (Content_Type => "application/json",
            Message_Body =>
            "{""error"":""Radar service unavailable""}",
            Status_Code => AWS.Messages.S503);
      end if;

      declare
         Response : constant Radar.DTO.Status.Status_Response :=
            Radar.Service.Get_Status_Response (Service_Ref.all);

      begin
         return AWS.Response.Build
         (Content_Type => "application/json",
            Message_Body => Radar.JSON.To_JSON (Response).Write,
            Status_Code  => AWS.Messages.S200);
      end;

   end Status;

   function Pause return AWS.Response.Data is

      Service_Ref : constant Radar.Api.Context.Service_Access :=
         Radar.API.Context.Get_Service;

      Success : Boolean;
   begin
         if Service_Ref = null then
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""error"":""Radar service unavailable""}",
               Status_Code => AWS.Messages.S503);
         end if;

         Radar.Service.Pause (Service_Ref.all, Success);

         if not Success then
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""error"":""Failed to pause radar service""}",
               Status_Code => AWS.Messages.S500);
         end if;

         return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""status"": ""Paused""}");
      end Pause;

      function Resume return AWS.Response.Data is

         Service_Ref : constant Radar.Api.Context.Service_Access :=
            Radar.API.Context.Get_Service;

         Success : Boolean;
      begin
         if Service_Ref = null then
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""error"":""Radar service unavailable""}",
               Status_Code => AWS.Messages.S503);
         end if;

         Radar.Service.Resume (Service_Ref.all, Success);

         if not Success then
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""error"":""Failed to resume radar service""}",
               Status_Code => AWS.Messages.S500);
         end if;

         return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body =>
               "{""status"": ""Resumed""}");
      end Resume;
end Radar.Handlers;