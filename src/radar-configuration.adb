with Radar.Detection;

package body Radar.Configuration is

   protected body Radar_Config is

      procedure Set_Station (Station : in Radar.Detection.Radar_Station) is
      begin
         Current_Station := Station;
      end Set_Station;

      function Get_Station return Radar.Detection.Radar_Station is
      begin
         return Current_Station;
      end Get_Station;

   end Radar_Config;
   end Radar.Configuration;