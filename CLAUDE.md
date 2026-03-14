# lex-cognitive-tempo

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-tempo`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::CognitiveTempo`

## Purpose

Models cognitive processing speed as domain-specific tempo records. Each domain (e.g., analytical, social, creative) tracks current processing tempo against a task requirement tempo. Mismatch indicates the cognitive rate is misaligned with task demands — either too fast (rushing) or too slow (lagging). The `adapt_tempo` method incrementally closes the gap. A periodic `Adapt` actor fires every 60 seconds to log the report.

## Gem Info

- **Gemspec**: `lex-cognitive-tempo.gemspec`
- **Require**: `lex-cognitive-tempo`
- **Ruby**: >= 3.4
- **License**: MIT
- **Homepage**: https://github.com/LegionIO/lex-cognitive-tempo

## File Structure

```
lib/legion/extensions/cognitive_tempo/
  version.rb
  helpers/
    constants.rb      # Default tempo, adjustment rate, tempo/mismatch label tables
    tempo_record.rb   # TempoRecord class — one domain's tempo snapshot
    tempo_engine.rb   # TempoEngine — multi-domain tempo registry
  runners/
    tempo.rb          # Runner module — public API
  actors/
    adapt.rb          # Actor::Adapt — fires tempo_report every 60s
  client.rb
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `DEFAULT_TEMPO` | 0.5 | Default processing speed for new records |
| `TEMPO_ADJUSTMENT` | 0.05 | Default change per `accelerate!`/`decelerate!`/`adapt_to!` |
| `MAX_TEMPO_RECORDS` | 300 | Ring buffer size per domain |

Tempo labels: `0.0..0.2` = `:slow`, `0.2..0.4` = `:deliberate`, `0.4..0.6` = `:moderate`, `0.6..0.8` = `:fast`, `0.8..1.0` = `:rapid`

Mismatch labels: `0.0..0.1` = `:synchronized`, `0.1..0.25` = `:slightly_off`, `0.25..0.5` = `:mismatched`, `0.5..1.0` = `:severely_mismatched`

## Key Classes

### `Helpers::TempoRecord`

One tempo snapshot for a domain.

- `mismatch` — `|current_tempo - task_tempo_requirement|`
- `accelerate!(amount:)` — increases current tempo
- `decelerate!(amount:)` — decreases current tempo
- `adapt_to!(target:, rate:)` — moves current tempo toward target by at most `rate` per call
- `tempo_label` — label for current tempo
- `mismatch_label` — label for current mismatch
- Fields: `id` (UUID), `domain`, `baseline_tempo`, `current_tempo`, `task_tempo_requirement`, `created_at`

### `Helpers::TempoEngine`

Multi-domain registry with per-domain history.

- `set_baseline(domain:, tempo:)` — stores domain baseline for future records
- `record_tempo(domain:, current_tempo:, task_requirement:)` — creates `TempoRecord`; fetches stored baseline or uses `DEFAULT_TEMPO`; appends to domain history; trims to `MAX_TEMPO_RECORDS`
- `adapt_tempo(domain:, target:)` — delegates `adapt_to!` on the latest record for that domain; returns nil if no records
- `average_mismatch` — mean mismatch across all records in all domains
- `domains_in_sync` — domain keys where latest record has mismatch <= 0.1
- `domains_mismatched` — domain keys where latest record has mismatch > 0.1
- `tempo_report` — `{ domains:, average_mismatch:, in_sync:, mismatched:, total_records: }`

## Runners

Module: `Legion::Extensions::CognitiveTempo::Runners::Tempo`

| Runner | Key Args | Returns |
|---|---|---|
| `set_tempo_baseline` | `domain:`, `tempo:` | `{ domain:, baseline: }` |
| `record_tempo` | `domain:`, `current_tempo:`, `task_requirement:` | `TempoRecord#to_h` |
| `adapt_tempo` | `domain:`, `target:` | `{ adapted: true, ...record }` or `{ adapted: false, domain: }` |
| `tempo_status` | `domain:` (optional) | single domain record hash, or full `tempo_report` |
| `domains_in_sync` | — | `{ domains:, count: }` |
| `domains_mismatched` | — | `{ domains:, count: }` |
| `tempo_report` | — | `{ domains:, average_mismatch:, in_sync:, mismatched:, total_records: }` |

No `engine:` injection keyword. Engine is a private memoized `@tempo_engine`.

## Actors

`Actor::Adapt` — extends `Legion::Extensions::Actors::Every`

- Fires `tempo_report` every **60 seconds**
- `run_now?: false`, `use_runner?: false`, `check_subtask?: false`, `generate_task?: false`
- Despite the name `Adapt`, the actor fires `tempo_report` not `adapt_tempo`

## Integration Points

- `record_tempo` should be called by `lex-tick` or task handlers when tempo measurements are available
- `adapt_tempo` can be called to incrementally align processing rate to task demands
- Pairs with `lex-cognitive-rhythm` — rhythm provides oscillating readiness; tempo tracks actual vs. required processing speed
- All state is in-memory per `TempoEngine` instance

## Development Notes

- Records are keyed by domain — each domain has its own ring-buffered list
- `latest_record(domain)` returns `@records[domain]&.last` — the most recent entry
- `adapt_to!` uses clamped delta: change per call is at most `rate` (default `TEMPO_ADJUSTMENT = 0.05`)
- The actor is named `Adapt` but calls `tempo_report`, not the `adapt_tempo` runner; actual adaptation is triggered by callers
- `domains_mismatched` uses `reject` with inverted condition logic; domains with no records are considered mismatched
