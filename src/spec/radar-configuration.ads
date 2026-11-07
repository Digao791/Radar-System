with Radar.Detection;

package Radar.Configuration is

   protected type Radar_Config is 

      procedure Set_Station (Station : in Radar.Detection.Radar_Station);
      function Get_Station return Radar.Detection.Radar_Station;

   private

      Current_Station : Radar.Detection.Radar_Station := 
         (X => 0.0, Y => 0.0, Radar_Range => 500.0);

   end Radar_Config;
end Radar.Configuration;