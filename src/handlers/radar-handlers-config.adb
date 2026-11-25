with AWS.Messages;
with Radar.API.Context;
with Radar.Service;
with Radar.DTO.Config;
with Radar.JSON;
with Radar.API.Responses;
with AWS.Status;
with GNATCOLL.JSON;
with Ada.Exceptions;
with Ada.Strings.Unbounded;

package body Radar.Handlers.Config is

   use type Radar.API.Context.Service_Access;

   function Get return AWS.Response.Data is

      Service_Ref : constant Radar.API.Context.Service_Access :=
         Radar.API.Context.Get_Service;

   begin
      if Service_Ref = null then
         return Radar.API.Responses.Build_Error
         ("Radar service unavailable", AWS.Messages.S503);
      end if;

      declare
         Response : constant Radar.DTO.Config.Config_Response :=
            Radar.Service.Get_Config (Service_Ref.all);

      begin
         return AWS.Response.Build
           (Content_Type => "application/json",
            Message_Body => Radar.JSON.To_JSON (Response).Write,
            Status_Code  => AWS.Messages.S200);
      end;

   end Get;

   function Update
  (Request : AWS.Status.Data)
   return AWS.Response.Data
   is
      Service_Ref : constant Radar.API.Context.Service_Access :=
         Radar.API.Context.Get_Service;

      Config : Radar.DTO.Config.Config_Request;

   begin
      if Service_Ref = null then
         return Radar.API.Responses.Build_Error
         ("Radar service unavailable", AWS.Messages.S503);
      end if;

      begin
         Config := Radar.JSON.From_JSON
         (Ada.Strings.Unbounded.To_String
            (AWS.Status.Binary_Data (Request)));

      exception
         when E : Radar.JSON.Invalid_Config_Request =>
            return Radar.API.Responses.Build_Error
            (Ada.Exceptions.Exception_Message (E),
               AWS.Messages.S400);

         when GNATCOLL.JSON.Invalid_JSON_Stream |
            Constraint_Error =>
            return Radar.API.Responses.Build_Error
            ("Invalid JSON request", AWS.Messages.S400);
      end;

      if not (Config.Radar_Range > 0.0) then
         return Radar.API.Responses.Build_Error
         ("Radar range must be positive",
            AWS.Messages.S400);
      end if;

      Radar.Service.Update_Config
      (Service_Ref.all, Config);

      return AWS.Response.Build
      (Content_Type => "application/json",
         Message_Body =>
         Radar.JSON.To_JSON
            (Radar.Service.Get_Config
               (Service_Ref.all)).Write,
         Status_Code => AWS.Messages.S200);

   end Update;

end Radar.Handlers.Config;