import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ArrowDown, ArrowUp, Radar } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { cn } from '@/lib/utils'
import {
  applyFilter,
  distanceKm,
  fmt,
  isFilterActive,
  useFilter,
  useSelectedTargetId,
  useTargets,
} from '@/lib/radar/hooks'
import type { Target } from '@/lib/radar/types'

type SortKey = 'id' | 'x' | 'y' | 'speed' | 'heading' | 'distance'

const COLUMNS: { key: SortKey; label: string; numeric?: boolean }[] = [
  { key: 'id', label: 'ID' },
  { key: 'x', label: 'X (units)', numeric: true },
  { key: 'y', label: 'Y (units)', numeric: true },
  { key: 'speed', label: 'Speed (units/s)', numeric: true },
  { key: 'heading', label: 'Heading', numeric: true },
  { key: 'distance', label: 'Distance', numeric: true },
]

function sortValue(t: Target, key: SortKey) {
  if (key === 'distance') return distanceKm(t)
  return t[key]
}

export function TargetsTable() {
  const { targets, isLoading, error } = useTargets()
  const [filter] = useFilter()
  const [selectedId, setSelectedId] = useSelectedTargetId()
  const [sort, setSort] = useState<{ key: SortKey; dir: 1 | -1 }>({ key: 'id', dir: 1 })
  const navigate = useNavigate()

  const rows = applyFilter(targets, filter).sort((a, b) => {
    const va = sortValue(a, sort.key)
    const vb = sortValue(b, sort.key)
    return (va < vb ? -1 : va > vb ? 1 : 0) * sort.dir
  })

  const activeCount = targets.filter((t) => t.status === 'ativo').length

  function toggleSort(key: SortKey) {
    setSort((s) => (s.key === key ? { key, dir: s.dir === 1 ? -1 : 1 } : { key, dir: 1 }))
  }

  function showOnRadar(id: string) {
    setSelectedId(id)
    navigate('/')
  }

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-wrap items-end justify-between gap-2">
        <div className="flex flex-col gap-1">
          <h1 className="text-lg font-semibold text-balance">Discovered targets</h1>
          <p className="text-sm leading-relaxed text-muted-foreground">
            {targets.length} currently detected, {activeCount} actively tracked.
            {isFilterActive(filter) && ` Showing ${rows.length} with the current filter.`}
          </p>
        </div>
      </div>

      <div className="overflow-hidden rounded-lg border border-border bg-card">
        <Table>
          <TableHeader>
            <TableRow className="hover:bg-transparent">
              <TableHead>Status</TableHead>
              {COLUMNS.map((col) => {
                const activeSort = sort.key === col.key
                return (
                  <TableHead
                    key={col.key}
                    className={cn(col.numeric && 'text-right')}
                    aria-sort={activeSort ? (sort.dir === 1 ? 'ascending' : 'descending') : 'none'}
                  >
                    <button
                      type="button"
                      onClick={() => toggleSort(col.key)}
                      className={cn(
                        'inline-flex items-center gap-1 rounded hover:text-foreground focus-visible:ring-2 focus-visible:ring-ring focus-visible:outline-none',
                        activeSort && 'text-foreground',
                      )}
                    >
                      {col.label}
                      {activeSort &&
                        (sort.dir === 1 ? (
                          <ArrowUp className="size-3" aria-hidden="true" />
                        ) : (
                          <ArrowDown className="size-3" aria-hidden="true" />
                        ))}
                    </button>
                  </TableHead>
                )
              })}
              <TableHead>
                <span className="sr-only">Actions</span>
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {rows.length === 0 ? (
              <TableRow>
                <TableCell
                  colSpan={COLUMNS.length + 2}
                  className="py-10 text-center text-muted-foreground"
                >
                  {error
                    ? 'Backend unavailable.'
                    : isLoading
                      ? 'Loading targets…'
                      : 'No targets match the filter.'}
                </TableCell>
              </TableRow>
            ) : (
              rows.map((t) => {
                const selected = t.id === selectedId
                return (
                  <TableRow
                    key={t.id}
                    data-state={selected ? 'selected' : undefined}
                    onClick={() => setSelectedId(selected ? null : t.id)}
                    className={cn(
                      'cursor-pointer font-mono tabular-nums',
                      selected && 'bg-accent/10',
                    )}
                  >
                    <TableCell>
                      <Badge variant={t.status === 'ativo' ? 'default' : 'secondary'}>
                        {t.status === 'ativo' ? 'Active' : 'Lost'}
                      </Badge>
                    </TableCell>
                    <TableCell className={cn('font-medium', selected && 'text-accent')}>
                      {t.id}
                    </TableCell>
                    <TableCell className="text-right">{t.x.toFixed(1)}</TableCell>
                    <TableCell className="text-right">{t.y.toFixed(1)}</TableCell>
                    <TableCell className="text-right">{Math.round(t.speed)}</TableCell>
                    <TableCell className="text-right">{fmt.deg(t.heading)}</TableCell>
                    <TableCell className="text-right">{fmt.km(distanceKm(t))}</TableCell>
                    <TableCell className="text-right">
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={(e) => {
                          e.stopPropagation()
                          showOnRadar(t.id)
                        }}
                        aria-label={`View ${t.id} on radar`}
                      >
                        <Radar className="size-4" aria-hidden="true" />
                        <span className="hidden sm:inline">View on radar</span>
                      </Button>
                    </TableCell>
                  </TableRow>
                )
              })
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  )
}
