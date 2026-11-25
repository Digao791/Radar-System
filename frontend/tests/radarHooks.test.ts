import { describe, expect, it } from 'vitest'
import {
  applyFilter,
  distanceKm,
  bearingDeg,
  isFilterActive,
  normalizeTargetId,
} from '@/lib/radar/hooks'
import { DEFAULT_FILTER, HEADING_LIMITS, SPEED_LIMITS, type Target } from '@/lib/radar/types'

const target: Target = {
  id: 'TGT-007',
  x: 3,
  y: 4,
  speed: 50,
  heading: 90,
  status: 'ativo',
}

describe('radar hook helpers', () => {
  it('normalizes numeric and prefixed target identifiers', () => {
    expect(normalizeTargetId(' 7 ')).toBe('TGT-007')
    expect(normalizeTargetId('tgt7')).toBe('TGT-007')
  })

  it('calculates distance and bearing from target coordinates', () => {
    expect(distanceKm(target)).toBe(5)
    expect(bearingDeg(target)).toBeCloseTo(36.87, 2)
  })

  it('filters targets by speed and heading', () => {
    expect(applyFilter([target], DEFAULT_FILTER)).toEqual([target])

    const filtered = applyFilter(
      [target],
      {
        ...DEFAULT_FILTER,
        speed: [51, SPEED_LIMITS[1]],
        heading: [0, HEADING_LIMITS[1]],
      },
    )
    expect(filtered).toEqual([])
  })

  it('detects when a non-default filter is active', () => {
    expect(isFilterActive(DEFAULT_FILTER)).toBe(false)
    expect(isFilterActive({ ...DEFAULT_FILTER, status: 'perdido' })).toBe(true)
  })
})
