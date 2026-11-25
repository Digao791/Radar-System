import useSWR from 'swr'
import {
  DEFAULT_CONFIG,
  DEFAULT_FILTER,
  HEADING_LIMITS,
  SPEED_LIMITS,
  type RadarConfig,
  type Target,
  type TargetFilter,
} from './types'

import { useState } from 'react'
import { radarApi } from '@/api/radarApi'
import { toDisplayTarget } from '@/lib/radarAdapter'

export function useRadarConfig() {
  const { data, error, isLoading } = useSWR('/api/radar/config', radarApi.getConfig, { refreshInterval: 1000 })
  const [prefs, setPrefs] = useLocalState('local:display', DEFAULT_CONFIG)
  const config = { ...prefs, range: data?.radar_range ?? 0, showLost: false }
  async function saveConfig(next: RadarConfig) {
    await setPrefs({ ...next, range: 0, showLost: false })
  }
  return { config, station: data, error, isLoading, saveConfig }
}
export function useTargets() {
  const { config, station, error: configError, isLoading: configLoading } = useRadarConfig()
  const { data, error, isLoading } = useSWR('/api/radar/detections', async () => ({ ...(await radarApi.getDetections()), timestamp: Date.now() }), { refreshInterval: config.refreshMs, dedupingInterval: 250 })
  return { targets: station ? (data?.detected_targets ?? []).map(t => toDisplayTarget(t, station)) : [], timestamp: data?.timestamp, error: error ?? configError, isLoading: isLoading || configLoading }
}
export function useRadarStatus() {
  const { data, error, mutate } = useSWR('/api/radar/status', radarApi.getStatus, { refreshInterval: 1000 })
  const [busy, setBusy] = useState(false)
  const [controlError, setControlError] = useState<unknown>(null)
  async function control(action: 'pause' | 'resume') {
    setBusy(true); setControlError(null)
    try { await radarApi[action](); await mutate() } catch (e) { setControlError(e) } finally { setBusy(false) }
  }
  return { status: data?.status, error: error ?? controlError, busy, control }
}

function useLocalState<T>(key: string, initial: T) {
  const { data, mutate } = useSWR<T>(key, null, { fallbackData: initial })
  const set = (value: T) => mutate(value, { revalidate: false })
  return [data === undefined ? initial : data, set] as const
}

export function useFilter() {
  return useLocalState<TargetFilter>('local:filter', DEFAULT_FILTER)
}

export function useSelectedTargetId() {
  return useLocalState<string | null>('local:selected', null)
}

export function isFilterActive(filter: TargetFilter) {
  return (
    filter.status !== 'todos' ||
    filter.speed[0] !== SPEED_LIMITS[0] ||
    filter.speed[1] !== SPEED_LIMITS[1] ||
    filter.heading[0] !== HEADING_LIMITS[0] ||
    filter.heading[1] !== HEADING_LIMITS[1]
  )
}

export function applyFilter(targets: Target[], filter: TargetFilter) {
  return targets.filter((t) => {
    if (filter.status !== 'todos' && t.status !== filter.status) return false
    if (t.speed < filter.speed[0]) return false
    if (filter.speed[1] < SPEED_LIMITS[1] && t.speed > filter.speed[1]) return false
    if (t.heading < filter.heading[0] || t.heading > filter.heading[1]) return false
    return true
  })
}

export function normalizeTargetId(query: string) {
  const q = query.trim().toUpperCase()
  if (/^\d+$/.test(q)) return `TGT-${q.padStart(3, '0')}`
  if (/^TGT-?\d+$/.test(q)) return `TGT-${q.replace(/\D/g, '').padStart(3, '0')}`
  return q
}

export function distanceKm(t: Target) {
  return Math.hypot(t.x, t.y)
}

export function bearingDeg(t: Target) {
  return ((Math.atan2(t.x, t.y) * 180) / Math.PI + 360) % 360
}

export const fmt = {
  km: (v: number) => `${v.toFixed(1)} units`,
  deg: (v: number) => `${String(Math.round(v)).padStart(3, '0')}°`,
  kn: (v: number) => `${Math.round(v)} units/s`,
  time: (ts: number) =>
    new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
}
