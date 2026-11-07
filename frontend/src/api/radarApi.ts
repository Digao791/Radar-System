import type {
  RadarStatusResponse,
  RadarTargetsResponse,
  RadarDetectionsResponse,
  RadarConfig,
} from "../types/radar";

const BASE_URL = "/api/radar";

async function request<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  const response = await fetch(`${BASE_URL}${endpoint}`, options);

  if (!response.ok) {
    throw new Error(`HTTP error: ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export const radarApi = {
  getStatus: () =>
    request<RadarStatusResponse>("/status"),

  getTargets: () =>
    request<RadarTargetsResponse>("/targets"),

  getDetections: () =>
    request<RadarDetectionsResponse>("/detections"),

  getConfig: () =>
    request<RadarConfig>("/config"),

  pause: () =>
    request<{ status: string }>("/pause", {
      method: "POST",
    }),

  resume: () =>
    request<{ status: string }>("/resume", {
      method: "POST",
    }),
};