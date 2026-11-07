export type RadarStatus =
  | "RUNNING"
  | "PAUSED"
  | "STOPPED"
  | "FAILED";

export interface RadarTarget {
  id: number;
  x: number;
  y: number;
  speed: number;
  heading: number;
}

export interface RadarConfig {
  x: number;
  y: number;
  radar_range: number;
}

export interface RadarStatusResponse {
  status: RadarStatus;
}

export interface RadarTargetsResponse {
  targets: RadarTarget[];
}

export interface RadarDetectionsResponse {
  detected_targets: RadarTarget[];
}