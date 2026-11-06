with Ada.Text_IO;
with AWS.Server;
with Radar.API;

procedure Radar_HTTP is

   use Ada.Text_IO;
   
   Web_Server : AWS.Server.HTTP;

begin

   Put_Line ("=== RADAR HTTP SERVER ===");

   AWS.Server.Start (Web_Server => Web_Server,
                     Name => "Radar HTTP Server",
                     CallBack => Radar.API.Handle_Request'Access,
                     Port => 8080);

   Put_Line ("[HTTP] Server started on port 8080.");
   Put_Line ("[HTTP] Press Enter or Ctrl+C to stop the server.");

   declare
      Dummy : constant String := Get_Line;
   begin
      null;
   end;

   AWS.Server.Shutdown (Web_Server);
   Put_Line ("[HTTP] Server stopped.");
end Radar_HTTP;