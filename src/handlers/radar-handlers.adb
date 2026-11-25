with AWS.Messages;
with AWS.Response;
with Radar.API.Context;
with Radar.Service;
with Radar.DTO.Status;
with Radar.JSON;
with Radar.DTO.Control;
with Radar.API.Responses;

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
         return Radar.API.Responses.Build_Error
         ("Radar service unavailable", AWS.Messages.S503);
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

         Service_Ref : constant Radar.API.Context.Service_Access :=
            Radar.API.Context.Get_Service;

         Success : Boolean;

      begin
         if Service_Ref = null then
            return Radar.API.Responses.Build_Error
            ("Radar service unavailable", AWS.Messages.S503);
         end if;

         Radar.Service.Pause (Service_Ref.all, Success);

         if not Success then
            return Radar.API.Responses.Build_Error
            ("Failed to pause radar service", AWS.Messages.S500);
         end if;

         declare
            Response : constant Radar.DTO.Control.Control_Response :=
               (Status => Radar.DTO.Control.Paused);

         begin
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body => Radar.JSON.To_JSON (Response).Write,
               Status_Code  => AWS.Messages.S200);
         end;

      end Pause;

      function Resume return AWS.Response.Data is

         Service_Ref : constant Radar.API.Context.Service_Access :=
            Radar.API.Context.Get_Service;

         Success : Boolean;

      begin
         if Service_Ref = null then
            return Radar.API.Responses.Build_Error
            ("Radar service unavailable", AWS.Messages.S503);
         end if;

         Radar.Service.Resume (Service_Ref.all, Success);

         if not Success then
            return Radar.API.Responses.Build_Error
            ("Failed to resume radar service", AWS.Messages.S500);
         end if;

         declare
            Response : constant Radar.DTO.Control.Control_Response :=
               (Status => Radar.DTO.Control.Resumed);

         begin
            return AWS.Response.Build
            (Content_Type => "application/json",
               Message_Body => Radar.JSON.To_JSON (Response).Write,
               Status_Code  => AWS.Messages.S200);
         end;

      end Resume;

end Radar.Handlers;