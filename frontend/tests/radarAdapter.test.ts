import { describe, expect, it } from 'vitest'
import { toDisplayTarget } from '@/lib/radarAdapter'

describe('toDisplayTarget', () => {
  it('converts absolute coordinates to station-relative coordinates', () => {
    const target = toDisplayTarget(
      { id: 12, x: 30, y: -15, speed: 40, heading: 90 },
      { x: 10, y: 5, radar_range: 500 },
    )

    expect(target).toEqual({
      id: 'TGT-012',
      x: 20,
      y: -20,
      speed: 40,
      heading: 0,
      status: 'ativo',
    })
  })

  it('wraps headings and converts them to clockwise display headings', () => {
    const target = toDisplayTarget(
      { id: 1, x: 0, y: 0, speed: 0, heading: 270 },
      { x: 0, y: 0, radar_range: 100 },
    )

    expect(target.heading).toBe(180)
  })
})
