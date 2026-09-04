# Project Rules & Custom Commands

This file defines custom shorthand workflows and behavioral instructions for LookML development in this project.

---

## Shorthand Commands

### `pull` (or `/pull`, `!pull`)
When the user types `pull`, `/pull`, or `!pull`:
1. Run `git stash` to preserve local configurations or work in progress.
2. Determine the active Git branch (`git branch --show-current`).
3. Run `git pull origin <current-branch>`.
4. Pop the stash (`git stash pop`) if applicable, ensuring `.vscode/settings.json` is preserved.
5. Provide a concise summary of newly updated models, views, or files.

### `push <message>` (or `/push`, `!push`)
When the user types `push <message>`, `/push <message>`, or `!push <message>`:
1. Check `git status` to identify modified and newly created LookML files.
2. Stage modified files (`views/`, `models/`, etc.).
3. Commit with the provided commit message (or a conventional commit message describing the changes).
4. Push to origin for the active branch (`git push origin <current-branch>`).
5. Confirm successful push.

### `validate` (or `/validate`, `!validate`)
When the user types `validate`, `/validate`, or `!validate`:
1. Execute `looker-cli project validate thelook-antigravity --verify-ssl=false` (or invoke Looker validation API).
2. Report the validation status, listing any syntax errors, warnings, or confirming `Project is valid.`

### `healthcheck` (or `/healthcheck`, `!healthcheck`)
When the user types `healthcheck`, `/healthcheck`, or `!healthcheck`:
1. Query `system__activity.query_metrics` to retrieve instance health indicators against target benchmarks.
2. Check top outlier queries, per-user throttling occurrences, average async processing time, and Looker overhead.
3. Recommend corresponding optimization recipes from the `looker-healthcheck` skill.

### `cli <args>` (or `/cli`, `!cli`)
When the user types `cli <args>`, `/cli <args>`, or `!cli <args>`:
1. Execute `looker-cli <args> --verify-ssl=false` against the active Looker profile.
2. Output the formatted JSON or table result.

---

## Coding Guidelines

- **Primary Keys**: Every view MUST have exactly one dimension marked with `primary_key: yes`.
- **Naming Conventions**: Dimension and measure names should be clean, snake_case, and descriptive.
- **Skills Reference**: When creating PDTs, Period-over-Period metrics, or new Explores, always follow the guidance in the shared `looker-skills` repository (`lookml-pdt-guidelines`, `lookml-pop-guidelines`, `lookml-modeling-guidelines`).
