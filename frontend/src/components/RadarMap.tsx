import { useEffect } from "react";
import { Circle, CircleMarker, MapContainer, TileLayer, Tooltip, useMap } from "react-leaflet";
import type { LatLngExpression } from "leaflet";
import "leaflet/dist/leaflet.css";
import type { RadarConfig, RadarTarget } from "../types/radar";
import { METERS_PER_SIMULATION_UNIT, RADAR_STATION_GEO } from "../config/map";
import "./RadarMap.css";

interface RadarMapProps {
  targets: RadarTarget[];
  config: RadarConfig;
  selectedTargetId: number | null;
  onSelectTarget: (id: number) => void;
}

/** Local X points east; local Y points north. Approximation suitable for small radar ranges. */
function toLatLng(x: number, y: number, config: RadarConfig): [number, number] {
  const latitude = RADAR_STATION_GEO.latitude;
  const longitude = RADAR_STATION_GEO.longitude;
  const northMeters = (y - config.y) * METERS_PER_SIMULATION_UNIT;
  const eastMeters = (x - config.x) * METERS_PER_SIMULATION_UNIT;
  const metersPerDegreeLatitude = 111_320;
  const metersPerDegreeLongitude = metersPerDegreeLatitude * Math.cos((latitude * Math.PI) / 180);
  return [
    latitude + northMeters / metersPerDegreeLatitude,
    longitude + eastMeters / metersPerDegreeLongitude,
  ];
}

function KeepRadarInView({ rangeMeters }: { rangeMeters: number }) {
  const map = useMap();
  useEffect(() => {
    // React-Leaflet manages the map instance; update the view only when the range changes.
    const latitude = RADAR_STATION_GEO.latitude;
    const latitudeOffset = rangeMeters / 111_320;
    const longitudeOffset = rangeMeters / (111_320 * Math.cos((latitude * Math.PI) / 180));
    map.fitBounds(
      [
        [latitude - latitudeOffset, RADAR_STATION_GEO.longitude - longitudeOffset],
        [latitude + latitudeOffset, RADAR_STATION_GEO.longitude + longitudeOffset],
      ],
      { padding: [24, 24], animate: false },
    );
  }, [map, rangeMeters]);
  return null;
}

export default function RadarMap({ targets, config, selectedTargetId, onSelectTarget }: RadarMapProps) {
  const center: LatLngExpression = [RADAR_STATION_GEO.latitude, RADAR_STATION_GEO.longitude];
  const rangeMeters = Math.max(1, config.radar_range * METERS_PER_SIMULATION_UNIT);

  return (
    <div className="radar-map-container" aria-label="Geographic radar map">
      <MapContainer center={center} zoom={14} className="radar-leaflet-map" scrollWheelZoom={true} touchZoom={true} doubleClickZoom={true} zoomControl={true}>
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          maxZoom={19}
        />
        <KeepRadarInView rangeMeters={rangeMeters} />
        <Circle
          center={center}
          radius={rangeMeters}
          pathOptions={{ color: "#4ade80", weight: 2, fillColor: "#16a34a", fillOpacity: 0.12 }}
          interactive={false}
        />
        {[0.25, 0.5, 0.75].map((fraction) => (
          <Circle
            key={fraction}
            center={center}
            radius={rangeMeters * fraction}
            pathOptions={{ color: "#4ade80", weight: 1, opacity: 0.55, fillOpacity: 0 }}
            interactive={false}
          />
        ))}
        <CircleMarker center={center} radius={6} pathOptions={{ color: "#fff", fillColor: "#22c55e", fillOpacity: 1, weight: 2 }}>
          <Tooltip direction="top">Radar station</Tooltip>
        </CircleMarker>
        {targets.map((target) => {
          const selected = target.id === selectedTargetId;
          return (
            <CircleMarker
              key={target.id}
              center={toLatLng(target.x, target.y, config)}
              radius={selected ? 10 : 7}
              pathOptions={{
                color: selected ? "#fff7b0" : "#fff",
                fillColor: selected ? "#facc15" : "#86efac",
                fillOpacity: 1,
                weight: selected ? 3 : 1,
              }}
              eventHandlers={{ click: () => onSelectTarget(target.id) }}
            >
              <Tooltip direction="top" offset={[0, -8]} permanent={selected}>
                TGT-{String(target.id).padStart(3, "0")}
              </Tooltip>
            </CircleMarker>
          );
        })}
      </MapContainer>
      <div className="radar-map-caption">MAP OVERLAY · 1 SIM UNIT = {METERS_PER_SIMULATION_UNIT} m</div>
    </div>
  );
}
