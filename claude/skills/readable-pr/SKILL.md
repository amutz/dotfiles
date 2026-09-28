---
name: readable-pr
description: Rewrite a PR branch's history into a guided-review-style sequence of logical commits, where commit messages are the explanations. Use when Andrew asks to make a PR readable, restructure its commits, "guided-review this PR", or clean up a messy branch before review. Rewrites history and force-pushes — only on Andrew's own unreviewed branches.
---

# Readable PR (guided-review-style history)

Turns a branch whose commits record *how the work happened* into commits that record *how the change should be read* — the same transformation a Plannotator guided review does, but written permanently into history. The diff does not change; only its partitioning and narration do.

**The invariant:** the final tree must be byte-identical to the original branch tip. Verify this before pushing; if the trees differ, something was lost — stop and investigate.

## 0. Preconditions

- Work on the PR's branch: current branch by default, or `gh pr checkout <number>` if given a PR reference.
- Check for existing review activity: `gh pr view --json reviews,comments`. Rewriting history detaches inline review comments from their anchors. If the PR has reviews or inline comments, stop and ask before proceeding.
- Safety net before any rewrite:

  ```bash
  git branch backup/<branch>-pre-readable
  ```

## 1. Plan the guide

Read the full diff against the merge base (`git diff $(git merge-base origin/main HEAD)...HEAD`, plus `git log` for context the original commits may carry). Then write a guide plan with the same shape Plannotator uses:

- **Intent** — one short paragraph: what this PR accomplishes and why. Becomes (or leads) the PR description.
- **Sections** — each becomes one commit:
  - **Title** — imperative, standalone-meaningful; this is the commit subject.
  - **Overview** — the explanation a reviewer needs *before* reading the diff: what this step does, why it comes at this point, what to pay attention to. This is the commit body.
  - **Files/hunks** — which parts of the diff belong to this section. Every changed file must land in exactly one section unless a file genuinely spans two logical steps.

Ordering is narrative, not chronological: lead with the central concept (the model, the core algorithm, the schema), then the changes that build on it, then integration/plumbing, then tests if they aren't interleaved. Each commit should make sense given only the commits before it. 3–7 sections is typical; a section per file is too granular, one section is no restructuring at all.

Show Andrew the plan (section titles + one-line summaries) before rewriting. Proceed unless he objects — the backup branch makes this reversible.

## 2. Rebuild the history

```bash
git reset --soft $(git merge-base origin/main HEAD)
git restore --staged .
```

Then for each section, in narrative order: stage its files (`git add <files>`) and commit with the section title as subject and the overview as body. Follow the repo's commit-message conventions (for the main work repo: Simplified Technical English, plus the Claude co-author trailer).

When one file spans two sections, split at hunk level: build a partial patch for the earlier section and stage it with `git apply --cached <partial.patch>`; the remaining hunks stage normally in the later section. Never use interactive staging (`git add -p` has no TTY here).

## 3. Verify the invariant, then push

```bash
git diff backup/<branch>-pre-readable HEAD   # MUST be empty
git status --porcelain                        # MUST be clean
```

Only then:

```bash
git push --force-with-lease=<branch>:$(git rev-parse backup/<branch>-pre-readable) origin <branch>
```

Update the PR description so it matches the new structure: the intent paragraph, then the reading order (the commit subjects as a list, so the reviewer knows to read commit-by-commit). Keep any existing Demo/badge blocks.

## 4. Report and clean up

Report the new commit sequence (subjects only), confirm the tree-identity check passed, and note the backup branch name. Delete the backup only when Andrew says the result looks good:

```bash
git branch -D backup/<branch>-pre-readable
```
