import { Crosshair, X } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { bearingDeg, distanceKm, fmt } from '@/lib/radar/hooks'
import type { Target } from '@/lib/radar/types'

interface TargetDetailProps {
  target: Target | null
  onClear: () => void
}

export function TargetDetail({ target, onClear }: TargetDetailProps) {
  if (!target) {
    return (
      <section
        aria-label="Target details"
        className="flex flex-col items-center justify-center gap-2 rounded-lg border border-dashed border-border px-4 py-10 text-center"
      >
        <Crosshair className="size-5 text-muted-foreground" aria-hidden="true" />
        <p className="text-sm font-medium">No target selected</p>
        <p className="max-w-56 text-xs leading-relaxed text-pretty text-muted-foreground">
          Click a contact on the radar or in the list, or search by ID at the top.
        </p>
      </section>
    )
  }

  const rows = [
    { label: 'X', value: fmt.km(target.x) },
    { label: 'Y', value: fmt.km(target.y) },
    { label: 'Speed', value: fmt.kn(target.speed) },
    { label: 'Heading', value: fmt.deg(target.heading) },
    { label: 'Distance', value: fmt.km(distanceKm(target)) },
    { label: 'Bearing', value: fmt.deg(bearingDeg(target)) },
  ]

  return (
    <section
      aria-label={`Target ${target.id} details`}
      aria-live="polite"
      className="flex flex-col gap-4 rounded-lg border border-accent/40 bg-card p-4"
    >
      <div className="flex items-start justify-between gap-2">
        <div className="flex flex-col gap-1">
          <span className="text-xs text-muted-foreground">ID</span>
          <h2 className="font-mono text-xl font-medium text-accent">{target.id}</h2>
        </div>
        <div className="flex items-center gap-1">
          <Badge variant={target.status === 'ativo' ? 'default' : 'secondary'}>
            {target.status === 'ativo' ? 'Active' : 'Lost'}
          </Badge>
          <Button variant="ghost" size="icon" onClick={onClear} aria-label="Clear selection">
            <X className="size-4" aria-hidden="true" />
          </Button>
        </div>
      </div>

      <dl className="grid grid-cols-2 gap-px overflow-hidden rounded-md border border-border bg-border">
        {rows.map((row) => (
          <div key={row.label} className="flex flex-col gap-1 bg-card px-3 py-2">
            <dt className="text-xs text-muted-foreground">{row.label}</dt>
            <dd className="font-mono text-sm tabular-nums">{row.value}</dd>
          </div>
        ))}
      </dl>
    </section>
  )
}
