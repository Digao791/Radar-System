import { RadarScope } from './radar-scope'
import { TargetDetail } from './target-detail'
import { ContactList } from './contact-list'
import {
  applyFilter,
  distanceKm,
  fmt,
  isFilterActive,
  useFilter,
  useRadarConfig,
  useRadarStatus,
  useSelectedTargetId,
  useTargets,
} from '@/lib/radar/hooks'

export function RadarDashboard() {
  const { targets, timestamp, error, isLoading } = useTargets()
  const { config } = useRadarConfig()
  const { status } = useRadarStatus()
  const [filter] = useFilter()
  const [selectedId, setSelectedId] = useSelectedTargetId()

  const filtered = applyFilter(targets, filter)
  const inRange = filtered.filter(
    (t) => distanceKm(t) <= config.range && (config.showLost || t.status === 'ativo'),
  )
  const selected = targets.find((t) => t.id === selectedId) ?? null

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-wrap items-end justify-between gap-2">
        <div className="flex flex-col gap-1">
          <h1 className="text-lg font-semibold text-balance">Radar dashboard</h1>
          <p className="font-mono text-xs text-muted-foreground">
            Range {config.range} units · {config.sweepRpm} RPM · refresh {config.refreshMs} ms
            {isFilterActive(filter) && ' · filter applied'}
          </p>
        </div>
        <p className="font-mono text-xs text-muted-foreground" aria-live="polite">
          {error
            ? 'Failed to receive backend data'
            : isLoading
              ? 'Connecting to backend…'
              : timestamp
                ? `Last frame ${fmt.time(timestamp)}`
                : null}
        </p>
      </div>

      <div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_20rem]">
        <div className="rounded-lg border border-border bg-card p-3 md:p-5">
          {config.range > 0 ? <RadarScope targets={inRange} config={config} selectedId={selectedId} onSelect={setSelectedId} isRunning={status === 'RUNNING'}/> : <p>Waiting for radar configuration…</p>}
        </div>
        <div className="flex flex-col gap-4">
          <TargetDetail target={selected} onClear={() => setSelectedId(null)} />
          <ContactList targets={inRange} selectedId={selectedId} onSelect={setSelectedId} />
        </div>
      </div>
    </div>
  )
}
