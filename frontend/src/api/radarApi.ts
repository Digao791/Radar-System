import type {
  RadarConfig,
  RadarStatusResponse,
  RadarTargetsResponse,
  RadarDetectionsResponse,
  RadarControlResponse,
} from '@/types/radar'
async function request<T>(path: string, method = 'GET'): Promise<T> {
  const res = await fetch(`/api/radar/${path}`, { method, cache: 'no-store' })
  if (!res.ok) throw new Error(`Radar API: ${res.status}`)
  return res.json() as Promise<T>
}
export const radarApi = {
  getConfig: () => request<RadarConfig>('config'),
  getStatus: () => request<RadarStatusResponse>('status'),
  getTargets: () => request<RadarTargetsResponse>('targets'),
  getDetections: () => request<RadarDetectionsResponse>('detections'),
  pause: () => request<RadarControlResponse>('pause', 'POST'),
  resume: () => request<RadarControlResponse>('resume', 'POST'),
}
