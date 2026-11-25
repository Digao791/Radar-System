import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { RadarConfigForm } from '@/components/config/radar-config-form'

const mocks = vi.hoisted(() => ({
  updateStation: vi.fn(),
  saveConfig: vi.fn(),
}))

vi.mock('@/lib/radar/hooks', () => ({
  useRadarConfig: () => ({
    config: {
      sweepRpm: 10,
      refreshMs: 500,
      showLabels: true,
      showVectors: false,
      showLost: false,
      range: 500,
    },
    station: { x: 10, y: 20, radar_range: 500 },
    isLoading: false,
    error: undefined,
    saveConfig: mocks.saveConfig,
    updateStation: mocks.updateStation,
  }),
}))

describe('RadarConfigForm', () => {
  beforeEach(() => {
    mocks.updateStation.mockReset()
    mocks.saveConfig.mockReset()
  })

  it('submits changed station values as a config request', async () => {
    mocks.updateStation.mockResolvedValue({
      x: 25,
      y: -5,
      radar_range: 750,
    })
    const user = userEvent.setup()

    render(<RadarConfigForm />)

    const xInput = screen.getByLabelText('Position X')
    const yInput = screen.getByLabelText('Position Y')
    const rangeInput = screen.getByLabelText('Radar range (units)')

    await user.clear(xInput)
    await user.type(xInput, '25')
    await user.clear(yInput)
    await user.type(yInput, '-5')
    await user.clear(rangeInput)
    await user.type(rangeInput, '750')
    await user.click(
      screen.getByRole('button', { name: 'Save radar configuration' }),
    )

    expect(mocks.updateStation).toHaveBeenCalledWith({
      x: 25,
      y: -5,
      radar_range: 750,
    })
    expect(
      await screen.findByText('Radar configuration saved.'),
    ).toBeInTheDocument()
  })

  it('disables saving when radar range is not positive', async () => {
    const user = userEvent.setup()

    render(<RadarConfigForm />)

    const rangeInput = screen.getByLabelText('Radar range (units)')
    await user.clear(rangeInput)
    await user.type(rangeInput, '0')

    expect(
      screen.getByRole('button', { name: 'Save radar configuration' }),
    ).toBeDisabled()
  })
})
