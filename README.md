# lex-cognitive-tempo

A LegionIO cognitive architecture extension that models cognitive processing speed as domain-specific tempo records. Each domain tracks current processing tempo against the tempo required by the active task, surfacing mismatch and enabling incremental adaptation.

## What It Does

Records **tempo measurements** per domain. Each record captures:

- Current processing speed (0.0 to 1.0)
- Task tempo requirement (how fast the task demands processing)
- Mismatch (absolute difference between the two)

When mismatch is high, `adapt_tempo` can incrementally close the gap. A background actor fires `tempo_report` every 60 seconds.

## Usage

```ruby
require 'lex-cognitive-tempo'

client = Legion::Extensions::CognitiveTempo::Client.new

# Set a baseline tempo for a domain
client.set_tempo_baseline(domain: :analytical, tempo: 0.4)
# => { domain: :analytical, baseline: 0.4 }

# Record a tempo measurement
client.record_tempo(domain: :analytical, current_tempo: 0.35, task_requirement: 0.6)
# => { id: "uuid...", domain: :analytical, current_tempo: 0.35, task_tempo_requirement: 0.6, mismatch: 0.25, mismatch_label: :mismatched, tempo_label: :deliberate, ... }

# Adapt toward the task requirement
client.adapt_tempo(domain: :analytical, target: 0.6)
# => { adapted: true, current_tempo: 0.4, mismatch: 0.2, mismatch_label: :slightly_off, ... }

# Check status for a specific domain
client.tempo_status(domain: :analytical)
# => { found: true, current_tempo: 0.4, mismatch: 0.2, ... }

# Check status for all domains
client.tempo_status
# => { domains: [:analytical], average_mismatch: 0.2, in_sync: [], mismatched: [:analytical], total_records: 2 }

# Which domains are synchronized?
client.domains_in_sync
# => { domains: [], count: 0 }

# Which domains have mismatch?
client.domains_mismatched
# => { domains: [:analytical], count: 1 }

# Full tempo report
client.tempo_report
# => { domains: [:analytical], average_mismatch: 0.2, in_sync: [], mismatched: [:analytical], total_records: 2 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
