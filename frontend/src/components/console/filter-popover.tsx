import { Filter, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
import { Slider } from '@/components/ui/slider'
import { cn } from '@/lib/utils'
import { isFilterActive, useFilter } from '@/lib/radar/hooks'
import { DEFAULT_FILTER, HEADING_LIMITS, SPEED_LIMITS, type TargetFilter } from '@/lib/radar/types'
import { useState } from 'react'

const STATUS_OPTIONS: { value: TargetFilter['status']; label: string }[] = [
  { value: 'todos', label: 'All' },
  { value: 'ativo', label: 'Active' },
]

function toPair(value: number | readonly number[]): [number, number] {
  return Array.isArray(value) ? [value[0], value[1]] : [value as number, value as number]
}

export function FilterPopover() {
  const [filter, setFilter] = useFilter()
  const active = isFilterActive(filter)
  const [open, setOpen] = useState(false)

  return (
    <div className="flex items-center gap-1">
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverTrigger
          render={
            <Button variant={active ? 'default' : 'outline'} aria-label="Create target filter">
              <Filter className="size-4" aria-hidden="true" />
              {active ? 'Filter active' : 'Create filter'}
            </Button>
          }
        />
        <PopoverContent align="end" className="w-80 gap-5 p-4">
          <div className="flex flex-col gap-1">
            <h2 className="text-sm font-semibold">Target filter</h2>
            <p className="text-xs text-muted-foreground">Applied to the radar and the targets list.</p>
          </div>

          <fieldset className="flex flex-col gap-2">
            <legend className="mb-2 text-xs font-medium text-muted-foreground">Status</legend>
            <div className="grid grid-cols-2 gap-1 rounded-md bg-muted p-1">
              {STATUS_OPTIONS.map((opt) => (
                <button
                  key={opt.value}
                  type="button"
                  aria-pressed={filter.status === opt.value}
                  onClick={() => setFilter({ ...filter, status: opt.value })}
                  className={cn(
                    'rounded px-2 py-1 text-xs transition-colors focus-visible:ring-2 focus-visible:ring-ring focus-visible:outline-none',
                    filter.status === opt.value
                      ? 'bg-background text-foreground'
                      : 'text-muted-foreground hover:text-foreground',
                  )}
                >
                  {opt.label}
                </button>
              ))}
            </div>
          </fieldset>

          <div className="flex flex-col gap-3">
            <div className="flex items-center justify-between text-xs">
              <span id="filter-speed" className="font-medium text-muted-foreground">
                Speed
              </span>
              <span className="font-mono">
                {filter.speed[0]}–{filter.speed[1] >= SPEED_LIMITS[1] ? `${SPEED_LIMITS[1]}+` : filter.speed[1]} units/s
              </span>
            </div>
            <Slider
              aria-labelledby="filter-speed"
              min={SPEED_LIMITS[0]}
              max={SPEED_LIMITS[1]}
              step={10}
              value={filter.speed}
              onValueChange={(v) => setFilter({ ...filter, speed: toPair(v) })}
            />
          </div>

          <div className="flex flex-col gap-3">
            <div className="flex items-center justify-between text-xs">
              <span id="filter-heading" className="font-medium text-muted-foreground">
                Heading
              </span>
              <span className="font-mono">
                {filter.heading[0]}°–{filter.heading[1]}°
              </span>
            </div>
            <Slider
              aria-labelledby="filter-heading"
              min={HEADING_LIMITS[0]}
              max={HEADING_LIMITS[1]}
              step={5}
              value={filter.heading}
              onValueChange={(v) => setFilter({ ...filter, heading: toPair(v) })}
            />
          </div>

          <Button variant="outline" size="sm" onClick={() => setFilter(DEFAULT_FILTER)} disabled={!active}>
            Clear filter
          </Button>
        </PopoverContent>
      </Popover>
      {active && !open &&(
        <Button
            variant="outline"
            size="icon"
            disabled={!active}
            aria-hidden={!active}
            onClick={() => setFilter(DEFAULT_FILTER)}
            className={cn(
              'shrink-0',
              !active && 'invisible pointer-events-none'
            )}
          >
            <X className="size-4" />
          </Button>
      )}
    </div>
  )
}
