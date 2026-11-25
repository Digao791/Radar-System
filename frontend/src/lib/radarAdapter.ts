import type { RadarTarget, RadarConfig } from '@/types/radar'
import type { Target } from '@/lib/radar/types'
export function toDisplayTarget(t: RadarTarget, c: RadarConfig): Target {
  return { id: `TGT-${String(t.id).padStart(3, '0')}`, x: t.x-c.x, y: t.y-c.y,
    speed: t.speed, heading: ((90-t.heading)%360+360)%360, status: 'ativo' }
}
