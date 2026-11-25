import type {
  RadarConfig,
  RadarConfigRequest,
  RadarStatusResponse,
  RadarTargetsResponse,
  RadarDetectionsResponse,
  RadarControlResponse,
} from '@/types/radar'

async function request<T>(
  path: string,
  method = 'GET',
  body?: unknown,
): Promise<T> {
  const res = await fetch(`/api/radar/${path}`, {
    method,
    cache: 'no-store',
    ...(body !== undefined && {
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    }),
  })

  if (!res.ok) {
    const error = await res.json().catch(() => null)

    throw new Error(
      error?.error ?? `Radar API: ${res.status}`,
    )
  }

  return res.json() as Promise<T>
}

export const radarApi = {
  getConfig: () =>
    request<RadarConfig>('config'),

  updateConfig: (config: RadarConfigRequest) =>
    request<RadarConfig>('config', 'PUT', config),

  getStatus: () =>
    request<RadarStatusResponse>('status'),

  getTargets: () =>
    request<RadarTargetsResponse>('targets'),

  getDetections: () =>
    request<RadarDetectionsResponse>('detections'),

  pause: () =>
    request<RadarControlResponse>('pause', 'POST'),

  resume: () =>
    request<RadarControlResponse>('resume', 'POST'),
}