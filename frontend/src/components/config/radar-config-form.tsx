import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Slider } from '@/components/ui/slider'
import { Switch } from '@/components/ui/switch'
import { useRadarConfig } from '@/lib/radar/hooks'
import { DEFAULT_CONFIG, type RadarConfig } from '@/lib/radar/types'
import { Input } from '@/components/ui/input'
import type { RadarConfigRequest } from '@/types/radar'
const SLIDERS: {
  key: 'sweepRpm' | 'refreshMs'
  label: string
  description: string
  min: number
  max: number
  step: number
  unit: string
}[] = [
  {
    key: 'sweepRpm',
    label: 'Antenna rotation',
    description: 'Speed of the visual sweep.',
    min: 5,
    max: 60,
    step: 1,
    unit: 'RPM',
  },
  {
    key: 'refreshMs',
    label: 'Refresh rate',
    description: 'Polling interval for targets from the backend.',
    min: 500,
    max: 5000,
    step: 250,
    unit: 'ms',
  },
]

const TOGGLES: { key: 'showLabels' | 'showVectors'; label: string; description: string }[] = [
  { key: 'showLabels', label: 'ID labels', description: 'Show the ID next to each target.' },
  {
    key: 'showVectors',
    label: 'Heading vectors',
    description: 'Line indicating heading and speed.',
  },
]

function StationForm({
  initial,
}: {
  initial: RadarConfigRequest
}) {
  const { updateStation } = useRadarConfig()

  const [draft, setDraft] = useState({
    x: String(initial.x),
    y: String(initial.y),
    radar_range: String(initial.radar_range),
  })

  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState('')
  const [failed, setFailed] = useState(false)

  const request: RadarConfigRequest = {
    x: Number(draft.x),
    y: Number(draft.y),
    radar_range: Number(draft.radar_range),
  }

  const valid =
    Object.values(draft).every((v) => v.trim() !== '') &&
    Object.values(request).every(Number.isFinite) &&
    request.radar_range > 0

  const dirty =
    request.x !== initial.x ||
    request.y !== initial.y ||
    request.radar_range !== initial.radar_range

  function update(
    key: keyof RadarConfigRequest,
    value: string,
  ) {
    setDraft((previous) => ({
      ...previous,
      [key]: value,
    }))

    setMessage('')
    setFailed(false)
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()

    if (!valid || saving) return

    setSaving(true)
    setMessage('')
    setFailed(false)

    try {
      await updateStation(request)

      setMessage('Radar configuration saved.')
    } catch (error) {
      setFailed(true)

      setMessage(
        error instanceof Error
          ? error.message
          : 'Could not update radar configuration.',
      )
    } finally {
      setSaving(false)
    }
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="radar-settings-form"
    >
      <fieldset
        disabled={saving}
        className="radar-settings-card"
      >
        <legend className="px-1 text-sm font-medium">
          Radar station
        </legend>

        <div className="radar-settings-fields">
          <p className="text-xs text-muted-foreground">
            Configure the radar position and detection range.
          </p>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div className="flex flex-col gap-2">
              <Label htmlFor="station-x">
                Position X
              </Label>

              <Input
                id="station-x"
                type="number"
                step="any"
                required
                value={draft.x}
                onChange={(e) =>
                  update('x', e.target.value)
                }
              />
            </div>

            <div className="flex flex-col gap-2">
              <Label htmlFor="station-y">
                Position Y
              </Label>

              <Input
                id="station-y"
                type="number"
                step="any"
                required
                value={draft.y}
                onChange={(e) =>
                  update('y', e.target.value)
                }
              />
            </div>
          </div>

          <div className="flex flex-col gap-2">
            <Label htmlFor="station-range">
              Radar range (units)
            </Label>

            <Input
              id="station-range"
              type="number"
              step="any"
              required
              value={draft.radar_range}
              onChange={(e) =>
                update('radar_range', e.target.value)
              }
            />

            <span className="text-xs text-muted-foreground">
              Detection range must be greater than zero.
            </span>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <Button
              type="submit"
              disabled={!valid || !dirty || saving}
            >
              {saving
                ? 'Saving…'
                : 'Save radar configuration'}
            </Button>

            <Button
              type="button"
              variant="outline"
              disabled={!dirty || saving}
              onClick={() => {
                setDraft({
                  x: String(initial.x),
                  y: String(initial.y),
                  radar_range: String(initial.radar_range),
                })

                setMessage('')
                setFailed(false)
              }}
            >
              Reset changes
            </Button>
          </div>

          <p
            role="status"
            className={
              failed
                ? 'text-xs text-destructive'
                : 'text-xs text-muted-foreground'
            }
          >
            {message}
          </p>
        </div>
      </fieldset>
    </form>
  )
}

function ConfigForm({ initial }: { initial: RadarConfig }) {
  const { saveConfig } = useRadarConfig()
  const [draft, setDraft] = useState(initial)
  const [state, setState] = useState<'idle' | 'saving' | 'saved' | 'error'>('idle')
  const dirty = JSON.stringify(draft) !== JSON.stringify(initial)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setState('saving')
    try {
      await saveConfig(draft)
      setState('saved')
    } catch {
      setState('error')
    }
  }

  function update<K extends keyof RadarConfig>(key: K, value: RadarConfig[K]) {
    setDraft((d) => ({ ...d, [key]: value }))
    setState('idle')
  }

  return (
    <form onSubmit={handleSubmit} className="radar-settings-form">
      <fieldset className="radar-settings-card">
        <legend className="px-1 text-sm font-medium">Sweep</legend>
        <div className="radar-settings-fields">
          {SLIDERS.map((s) => (
            <div key={s.key} className="flex flex-col gap-3">
              <div className="flex items-start justify-between gap-4">
                <div className="flex flex-col gap-1">
                  <span id={`cfg-${s.key}`} className="text-sm font-medium">
                    {s.label}
                  </span>
                  <span className="text-xs leading-relaxed text-muted-foreground">
                    {s.description}
                  </span>
                </div>
                <span className="font-mono text-sm text-primary tabular-nums">
                  {draft[s.key]} {s.unit}
                </span>
              </div>
              <Slider
                aria-labelledby={`cfg-${s.key}`}
                min={s.min}
                max={s.max}
                step={s.step}
                value={[draft[s.key]]}
                onValueChange={(v) => update(s.key, Array.isArray(v) ? v[0] : (v as number))}
              />
            </div>
          ))}
        </div>
      </fieldset>

      <fieldset className="radar-settings-card">
        <legend className="px-1 text-sm font-medium">Display</legend>
        <div className="radar-settings-fields">
          {TOGGLES.map((t) => (
            <div key={t.key} className="flex items-center justify-between gap-4 py-2">
              <div className="flex flex-col gap-1">
                <Label htmlFor={`cfg-${t.key}`}>{t.label}</Label>
                <span className="text-xs leading-relaxed text-muted-foreground">
                  {t.description}
                </span>
              </div>
              <Switch
                id={`cfg-${t.key}`}
                checked={draft[t.key]}
                onCheckedChange={(c) => update(t.key, c)}
              />
            </div>
          ))}
        </div>
      </fieldset>

      <div className="radar-settings-actions">
        <Button type="submit" disabled={!dirty || state === 'saving'}>
          {state === 'saving' ? 'Saving…' : 'Save settings'}
        </Button>
        <Button
          type="button"
          variant="outline"
          onClick={() => {
            setDraft({ ...DEFAULT_CONFIG, range: initial.range })
            setState('idle')
          }}
        >
          Restore defaults
        </Button>
        <p role="status" className="text-xs text-muted-foreground">
          {state === 'saved' && 'Display settings saved.'}
          {state === 'error' && <span className="text-destructive">Could not save.</span>}
        </p>
      </div>
    </form>
  )
}

export function RadarConfigForm() {
  const { config, station, isLoading, error } =
    useRadarConfig()

  return (
    <div className="radar-settings-page">
      <div className="flex flex-col gap-1">
        <h1 className="radar-settings-title">
          Radar settings
        </h1>

        <p className="text-sm leading-relaxed text-muted-foreground">
          Configure the radar station and display preferences.
        </p>
      </div>

      {isLoading ? (
        <p className="text-sm text-muted-foreground">
          Loading settings…
        </p>
      ) : (
        <>
          {station ? (
            <StationForm initial={station} />
          ) : (
            <p className="text-sm text-destructive">
              Radar configuration unavailable.
            </p>
          )}

          {error && station && (
            <p className="text-xs text-destructive">
              Could not refresh radar configuration.
            </p>
          )}

          <ConfigForm
            key={JSON.stringify(config)}
            initial={config}
          />
        </>
      )}
    </div>
  )
}