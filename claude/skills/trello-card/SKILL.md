---
name: trello-card
description: Drive development work from a Trello card. Use when the user pastes a Trello card URL or asks to start work on / pick up a Trello card. Fetches the card, presents an interpretation of what it asks for, waits for confirmation, hands off to the normal development flow, and after a PR exists links the PR back onto the card.
---

# Trello card workflow

Turns a Trello card into a confirmed understanding, then a normal development cycle, then a PR linked back on the card. The argument is a Trello card URL (`https://trello.com/c/<shortLink>/...`).

## Phase 1 — Fetch and understand the card

1. Fetch the card with `trelloReadCard` (`action: "get"`, pass the URL as `cardIdOrUrl`). Note the returned card ARI (`id`) — writes later need the ARI, not the URL.
2. Read everything on it: name, description, labels, comments (comments often contain the real requirements or later corrections — weigh recent comments over the original description). If the card has checklists, fetch them with `trelloReadChecklist`.
3. Ground the card in this codebase before interpreting it:
   - Search the code areas the card touches.
   - Read the matching feature docs in `docs/` (required by CLAUDE.md before planning changes).
   - Check `docs/solutions/` for prior art on the same module.

## Phase 2 — Present the interpretation and stop

Present to the user, in plain prose:

- **What the card is asking for** — the goal in product terms, not a restatement of the card text.
- **Where it lands in the code** — the files/models/flows involved, referenced as `path:line` where useful.
- **Ambiguities and open questions** — anything the card leaves undecided, with your recommended reading of each.
- **Proposed scope** — the smallest change that satisfies the card; call out anything on the card you'd defer.

Then **stop and wait for the user to confirm or correct the interpretation**. Do not start implementation, plan mode, or file edits before that confirmation. This checkpoint is the point of the skill.

## Phase 3 — Develop as normal

After confirmation, first link this Claude Code session on the card, then follow the standard workflow from CLAUDE.md (`/ce:plan` then `/ce:work` for non-trivial work; direct implementation for small fixes).

Link the session on the card:

1. Get the session ID: `echo $CLAUDE_CODE_SESSION_ID`.
2. Append to the card description (same mechanics as Phase 4 — re-fetch first, append to the existing description, never replace):

   ```
   ---
   **Claude session:** `claude --resume <session-id>`
   ```

   Local CLI sessions have no web URL (verified against the docs, Sep 2026), so the resume command is the link. If the session does have a URL (Claude Code web / cloud session), use a markdown link to that URL instead. If this session's line is already on the card, skip the update.

Traceability rules for this phase:

- Include the card's short link in the branch name, e.g. `fix-statement-rounding-abc123XY`.
- When the PR is created (typically via `ce-commit-push-pr`), include a `Trello: <card URL>` line in the PR body.

## Phase 4 — Link the PR back to the card

Once the PR exists:

1. Re-fetch the card (`trelloReadCard` `get`) to get the current description.
2. Update it with `trelloWriteCard` (`action: "update"`, `cardId: <card ARI>`), setting `desc` to the existing description with this appended at the end:

   ```
   ---
   **PR:** <PR URL>
   ```

   Never replace the description — always append to what is there. If a `**PR:**` line for this PR is already present, skip the update.

The Trello MCP tools cannot add comments or attachments, so the description line is the mechanism. Do not move the card to another list or mark it done — the user manages card state in Trello.

## Resuming in a fresh session

If the development happened earlier and the current session only needs to link the PR: invoke this skill with the card URL, skip to Phase 4, and take the PR URL from the open PR on the current branch (`gh pr view --json url`).

Any session that does real work on the card (not just the Phase 4 PR link) appends its own **Claude session:** line per Phase 3, so the card accumulates one line per working session.
