import { afterEach, describe, expect, it, vi } from 'vitest'
import { radarApi } from '@/api/radarApi'

afterEach(() => {
  vi.restoreAllMocks()
})

describe('radarApi', () => {
  it('requests radar config and returns parsed JSON', async () => {
    const fetchMock = vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(JSON.stringify({ x: 10, y: 20, radar_range: 500 }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }),
    )

    await expect(radarApi.getConfig()).resolves.toEqual({
      x: 10,
      y: 20,
      radar_range: 500,
    })
    expect(fetchMock).toHaveBeenCalledWith('/api/radar/config', {
      method: 'GET',
      cache: 'no-store',
    })
  })

  it('uses POST for radar controls', async () => {
    const fetchMock = vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(JSON.stringify({ status: 'Paused' }), { status: 200 }),
    )

    await expect(radarApi.pause()).resolves.toEqual({ status: 'Paused' })
    expect(fetchMock).toHaveBeenCalledWith('/api/radar/pause', {
      method: 'POST',
      cache: 'no-store',
    })
  })

  it('rejects unsuccessful HTTP responses', async () => {
    vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response('', { status: 503 }),
    )

    await expect(radarApi.getStatus()).rejects.toThrow('Radar API: 503')
  })
})
