import { useState } from 'react'
import { cn } from '@/lib/utils'
import { fmt } from '@/lib/radar/hooks'
import type { RadarConfig, Target } from '@/lib/radar/types'

const R = 100
const VIEW = 112
const RINGS = [0.25, 0.5, 0.75, 1]
const TICKS = Array.from({ length: 36 }, (_, i) => i * 10)

interface RadarScopeProps {
  targets: Target[]
  config: RadarConfig
  selectedId: string | null
  onSelect: (id: string | null) => void
  isRunning: boolean
}

function toScope(t: Target, range: number) {
  return { sx: (t.x / range) * R, sy: (-t.y / range) * R }
}

function polar(deg: number, radius: number) {
  const rad = (deg * Math.PI) / 180
  return { x: radius * Math.sin(rad), y: -radius * Math.cos(rad) }
}

export function RadarScope({ targets, config, selectedId, onSelect, isRunning }: RadarScopeProps) {
  const [hoveredId, setHoveredId] = useState<string | null>(null)

  const visible = targets
    .filter((t) => config.showLost || t.status === 'ativo')
    .map((t) => ({ target: t, ...toScope(t, config.range) }))
    .filter(({ sx, sy }) => Math.hypot(sx, sy) <= R)

  const hovered = visible.find((v) => v.target.id === hoveredId)
  const sweepSeconds = 60 / config.sweepRpm
  const insetPct = ((VIEW - R) / (VIEW * 2)) * 100

  return (
    <div className="relative mx-auto aspect-square w-full max-w-[min(100%,72vh)]">
      <div
        aria-hidden="true"
        className="pointer-events-none absolute rounded-full bg-scope motion-safe:animate-[radar-sweep_4s_linear_infinite]"
        style={{
          inset: `${insetPct}%`,
          backgroundImage:
            'conic-gradient(from 0deg, transparent 0deg, transparent 290deg, color-mix(in oklch, var(--primary) 32%, transparent) 360deg)',
          animationDuration: `${sweepSeconds}s`,
          animationPlayState: isRunning ? 'running' : 'paused',
        }}
      >
        <div className="absolute top-0 left-1/2 h-1/2 w-px -translate-x-1/2 bg-primary/70" />
      </div>

      <svg
        viewBox={`${-VIEW} ${-VIEW} ${VIEW * 2} ${VIEW * 2}`}
        className="relative h-full w-full overflow-visible select-none"
        role="group"
        aria-label={`Radar scope, ${config.range} units range, ${visible.length} visible targets`}
      >
        <circle
          r={R}
          fill="transparent"
          className="stroke-primary/40"
          strokeWidth={0.5}
          onClick={() => onSelect(null)}
        />

        <g className="pointer-events-none" aria-hidden="true">
          {RINGS.map((f) => (
            <g key={f}>
              <circle r={R * f} fill="none" className="stroke-primary/20" strokeWidth={0.35} />
              <text
                x={1.5}
                y={-R * f + 4}
                className="fill-muted-foreground font-mono"
                fontSize={3.6}
              >
                {Math.round(config.range * f)} units
              </text>
            </g>
          ))}
          <line x1={-R} x2={R} y1={0} y2={0} className="stroke-primary/15" strokeWidth={0.3} />
          <line x1={0} x2={0} y1={-R} y2={R} className="stroke-primary/15" strokeWidth={0.3} />
          {TICKS.map((deg) => {
            const major = deg % 30 === 0
            const a = polar(deg, major ? R - 4 : R - 2)
            const b = polar(deg, R)
            const label = polar(deg, R + 6)
            return (
              <g key={deg}>
                <line
                  x1={a.x}
                  y1={a.y}
                  x2={b.x}
                  y2={b.y}
                  className="stroke-primary/40"
                  strokeWidth={0.4}
                />
                {major && (
                  <text
                    x={label.x}
                    y={label.y}
                    textAnchor="middle"
                    dominantBaseline="central"
                    className="fill-muted-foreground font-mono"
                    fontSize={3.8}
                  >
                    {deg === 0 ? 'N' : String(deg).padStart(3, '0')}
                  </text>
                )}
              </g>
            )
          })}
          <circle r={1.2} className="fill-primary" />
        </g>

        {visible.map(({ target: t, sx, sy }) => {
          const selected = t.id === selectedId
          const lost = t.status === 'perdido'
          const vectorLen = 4 + (Math.min(t.speed, 700) / 700) * 14
          const tip = polar(t.heading, vectorLen)
          return (
            <g
              key={t.id}
              role="button"
              tabIndex={0}
              aria-pressed={selected}
              aria-label={`${t.id}, ${lost ? 'lost' : 'active'}, speed ${Math.round(t.speed)} units/s, heading ${Math.round(t.heading)} degrees`}
              className="cursor-pointer outline-none [&:focus-visible_.focus-ring]:opacity-100"
              style={{
                transform: `translate(${sx}px, ${sy}px)`,
                transition: `transform ${config.refreshMs}ms linear`,
              }}
              onClick={(e) => {
                e.stopPropagation()
                onSelect(selected ? null : t.id)
              }}
              onKeyDown={(e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                  e.preventDefault()
                  onSelect(selected ? null : t.id)
                }
              }}
              onPointerEnter={() => setHoveredId(t.id)}
              onPointerLeave={() => setHoveredId((h) => (h === t.id ? null : h))}
              onFocus={() => setHoveredId(t.id)}
              onBlur={() => setHoveredId((h) => (h === t.id ? null : h))}
            >
              <circle r={7} fill="transparent" />
              <circle
                r={6}
                fill="none"
                className="focus-ring stroke-foreground opacity-0"
                strokeWidth={0.5}
              />
              {config.showVectors && !lost && (
                <line
                  x1={0}
                  y1={0}
                  x2={tip.x}
                  y2={tip.y}
                  className={selected ? 'stroke-accent' : 'stroke-primary/70'}
                  strokeWidth={0.6}
                />
              )}
              {selected && (
                <>
                  <circle
                    r={4}
                    fill="none"
                    className="stroke-accent motion-safe:animate-[radar-ping_1.6s_ease-out_infinite]"
                    strokeWidth={0.5}
                  />
                  <rect
                    x={-4.5}
                    y={-4.5}
                    width={9}
                    height={9}
                    fill="none"
                    className="stroke-accent"
                    strokeWidth={0.5}
                    strokeDasharray="2.5 4"
                  />
                </>
              )}
              <rect
                x={-1.8}
                y={-1.8}
                width={3.6}
                height={3.6}
                transform="rotate(45)"
                className={cn(
                  lost
                    ? 'fill-none stroke-muted-foreground'
                    : selected
                      ? 'fill-accent'
                      : 'fill-primary',
                )}
                strokeWidth={lost ? 0.5 : 0}
                strokeDasharray={lost ? '1 0.8' : undefined}
              />
              {config.showLabels && (
                <text
                  x={4}
                  y={-3}
                  className={cn(
                    'font-mono',
                    selected
                      ? 'fill-accent'
                      : lost
                        ? 'fill-muted-foreground'
                        : 'fill-foreground/80',
                  )}
                  fontSize={3.4}
                >
                  {t.id}
                </text>
              )}
            </g>
          )
        })}
      </svg>

      {hovered && (
        <div
          role="tooltip"
          className="pointer-events-none absolute z-10 -translate-x-1/2 -translate-y-[calc(100%+14px)] rounded-md border border-border bg-popover px-3 py-2 font-mono text-xs whitespace-nowrap text-popover-foreground shadow-lg"
          style={{
            left: `${((hovered.sx + VIEW) / (VIEW * 2)) * 100}%`,
            top: `${((hovered.sy + VIEW) / (VIEW * 2)) * 100}%`,
          }}
        >
          <p className="font-medium text-primary">{hovered.target.id}</p>
          <p>
            X {hovered.target.x.toFixed(1)} · Y {hovered.target.y.toFixed(1)}
          </p>
          <p>
            {fmt.kn(hovered.target.speed)} · {fmt.deg(hovered.target.heading)}
          </p>
        </div>
      )}
    </div>
  )
}
