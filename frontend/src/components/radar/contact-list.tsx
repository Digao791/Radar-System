import { cn } from '@/lib/utils'
import { distanceKm, fmt } from '@/lib/radar/hooks'
import type { Target } from '@/lib/radar/types'

interface ContactListProps {
  targets: Target[]
  selectedId: string | null
  onSelect: (id: string) => void
}

export function ContactList({ targets, selectedId, onSelect }: ContactListProps) {
  const sorted = [...targets].sort((a, b) => distanceKm(a) - distanceKm(b))

  return (
    <section aria-labelledby="contacts-heading" className="flex min-h-0 flex-col gap-2">
      <div className="flex items-baseline justify-between">
        <h2 id="contacts-heading" className="text-sm font-medium">
          Contacts in range
        </h2>
        <span className="font-mono text-xs text-muted-foreground">by distance</span>
      </div>
      {sorted.length === 0 ? (
        <p className="rounded-md border border-border px-3 py-4 text-xs text-muted-foreground">
          No contacts match the current range and filter.
        </p>
      ) : (
        <ul className="flex max-h-80 flex-col overflow-y-auto rounded-md border border-border">
          {sorted.map((t) => (
            <li key={t.id} className="border-b border-border last:border-b-0">
              <button
                type="button"
                onClick={() => onSelect(t.id)}
                aria-pressed={t.id === selectedId}
                className={cn(
                  'grid w-full grid-cols-[1fr_auto_auto] items-center gap-3 px-3 py-2 text-left font-mono text-xs transition-colors',
                  'hover:bg-muted focus-visible:bg-muted focus-visible:outline-none',
                  t.id === selectedId && 'bg-accent/10 text-accent',
                )}
              >
                <span className="flex items-center gap-2">
                  <span
                    aria-hidden="true"
                    className={cn(
                      'size-1.5 rotate-45',
                      t.status === 'ativo' ? 'bg-primary' : 'border border-muted-foreground',
                    )}
                  />
                  {t.id}
                </span>
                <span className="tabular-nums text-muted-foreground">{fmt.kn(t.speed)}</span>
                <span className="w-16 text-right tabular-nums">{fmt.km(distanceKm(t))}</span>
              </button>
            </li>
          ))}
        </ul>
      )}
    </section>
  )
}
