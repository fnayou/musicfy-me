# Agent instructions: MusicfyMe

Project profile: POC. Save, sync, export and restore your music playlists across streaming platforms (Apple Music, Spotify).

## Commands

Use `task --list` to see available commands. Run `task setup` once, then `task doctor` before project work.

## Working rules

Preserve user changes and existing files. Keep credentials out of source control and logs. Use focused changes and Conventional Commits. Check `docs/agents/` for issue-tracker, triage-label, and domain-doc conventions when those files exist.

## Agent skills

### Issue tracker

Issues live in GitHub Issues (`gh` CLI). See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
