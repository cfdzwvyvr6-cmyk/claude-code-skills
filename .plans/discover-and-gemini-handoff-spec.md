# Spec: /discover, /gemini-handoff and the Gemini-side research skill

## 1. Problem

The existing `/interview` skill takes the goal the user states as final and
goes straight to implementation, UI and tradeoff questions. The user often
starts with a fuzzy idea and does not yet know what they actually want. They
need a step before the spec that finds the real goal and the use cases.

Also, some questions cannot be answered from the user's head: existing
products, technical feasibility, best practices, market facts. The user has
Google AI Pro (Gemini web app) and wants heavy research to run there, not in
Claude, to save Claude usage.

## 2. Scope

Domain: software and products (apps, tools, automations, skills, agents).

Deliverables, in a **new repository** (separate from `23jmo/jmo-skills`):

| Item | Type | Purpose |
|---|---|---|
| `/discover` | Claude Code skill | Find the real goal and use cases. Writes a goal brief. |
| `/gemini-handoff` | Claude Code skill | Pick the right Gemini mode, write the prompt, take the report back in. |
| Gemini research skill | Gemini web app skill | Makes Gemini return reports in a fixed format. |
| Small edit to `/interview` | Change to existing skill | Read the goal brief; call `/gemini-handoff` for unknown facts. |

Environments: Claude Code cloud sessions and local terminal/desktop.

Out of scope: running Gemini automatically (no Gemini CLI, no API calls). All
Gemini work is a manual copy-paste step in the Gemini web app.

## 3. User flow

```
/discover <rough idea>
   │  questions about the goal, users and use cases
   │  (may call /gemini-handoff when facts are needed)
   ▼
.plans/<topic>-goal.md  (goal brief, confirmed by user)
   │
   ├─► /gemini-handoff  (if research is still needed)
   │      prompt → user pastes into Gemini → report back → brief updated
   ▼
/interview  (reads the brief, writes the spec;
             may call /gemini-handoff for unknowns)
   ▼
.plans/<topic>-spec.md
```

## 4. `/discover`

### 4.1 Frontmatter

```yaml
name: discover
description: Find out what the user actually wants before planning. Interviews about the real goal, users, use cases and success criteria, without assuming the stated goal is final. Writes a goal brief. Use before /interview when an idea is new or fuzzy.
allowed-tools: AskUserQuestion, Write, Read, Skill
```

### 4.2 Behavior

1. Treat the user's stated goal as a starting hypothesis, not the final goal.
2. **Auto-detect pushback mode** from the request:
   - Fuzzy idea ("I want something that helps with X") → **explore**: open,
     gentle questions about the problem and the situation.
   - Specific solution ("build a Chrome extension that does Y") → **challenge**:
     ask what need the solution serves, and whether another approach serves it
     better.
   - In between → **probe**: "why" and "what if" questions, no arguing.
   - The skill can change mode during the session when answers show it is
     wrong. It says so in one line when it changes mode.
3. Ask with `AskUserQuestion`, up to 4 questions per round. Questions must not
   be obvious. Cover:
   - The trigger: what happened that made the user want this now.
   - Who uses it, and in which situations (concrete use cases).
   - What "success" looks like, and how the user would notice it.
   - What the user does today instead (current workaround).
   - Constraints: time, money, platforms, skills.
   - Non-goals: what it must not become.
4. **Research trigger.** When a question depends on facts the user does not
   know (existing solutions, technical feasibility, best practices,
   user/market facts), the skill decides from the situation whether research
   is worth it. If yes, it calls `/gemini-handoff` instead of guessing.
5. **Build vs buy.** If discovery or research shows that an existing product
   already solves the real need, stop and ask the user: use it, extend it, or
   build their own. Do not decide for the user.
6. **Stop rule (checklist).** Stop asking when the skill can state all of:
   real goal, users, top use cases, success criteria, non-goals, constraints.
   Then present the restated goal and ask the user to confirm or correct it.
   Loop until confirmed.
7. Write the goal brief (4.3). State the absolute path in the reply.
8. Suggest next steps: `/gemini-handoff` for any open research questions,
   then `/interview` with the brief.

### 4.3 Goal brief

Path: `<cwd>/.plans/<topic>-goal.md` (kebab-case topic slug). Create
`.plans/` if missing. Never save under `~/.claude/`.

Sections:

1. Stated goal (what the user first said)
2. Real goal (confirmed restatement)
3. Trigger / why now
4. Users and use cases
5. Success criteria
6. Current workaround
7. Constraints
8. Non-goals
9. Alternatives found (existing products) and the user's decision
10. Open questions
11. Research to do (each with a ready `/gemini-handoff` prompt or a link to it)
12. Research findings (filled in after reports come back)

## 5. `/gemini-handoff`

Shared by `/discover` and `/interview`, and usable on its own. It matches the
existing `/codex` handoff skill in naming and style.

### 5.1 Frontmatter

```yaml
name: gemini-handoff
description: Hand off research or structured lookups to the Gemini web app to save Claude usage. Picks the right Gemini mode, writes a ready-to-paste prompt, and folds the returned report into the plan. Use when a planning question depends on facts that need web research.
allowed-tools: Read, Write, Edit, AskUserQuestion
```

### 5.2 Mode selection

The skill picks one mode from the question and says why in one line:

| Mode | Use when |
|---|---|
| Deep Research (high thinking) | Broad or deep question: landscape of existing solutions, best practices, feasibility with many sources. |
| Gemini Tasks | Multi-step job that benefits from Gemini running on its own (for example, collect and compare a list of products). |
| Gemini skill (section 6) | Any research where the structured report format matters. Default wrapper for the modes above when the skill is installed. |
| Plain chat question | Small factual check: "list all products that do X", "does API Y allow Z". |

### 5.3 Steps

1. Write the research question, and the context Gemini needs: the goal, why
   the answer matters, what is already known. Pass no credentials or
   unrelated private material.
2. Write the prompt to `<cwd>/.plans/research/<topic>-prompt.md` and also show
   it in chat in one copyable block. Say which mode to use and how to start
   the Gemini research skill.
3. Ask the user to return the report by pasting it in chat or saving it to
   `<cwd>/.plans/research/<topic>-report.md`.
4. When the report comes back:
   - Save it to the report file if it was pasted.
   - Read the **summary part first**. Read the detail part only for points
     that need it.
   - Fold the key findings, with sources, into the goal brief (section 12) or
     the spec being written.
   - If the findings change the goal (for example, an existing product
     already covers it), say so and go back to the calling skill's
     confirmation or build-vs-buy step.
5. Never claim research was done before a report is returned. Never invent
   findings.

## 6. Gemini-side research skill

Form: a skill in the Gemini web app's skills feature. It is built in the same
repository so the prompt and the report format match.

Content:

- Role: a research assistant whose reports will be read by another AI agent.
- Always use this report shape:
  1. **Summary** (at most about 1 page): short answer, key findings as
     bullets with source links, confidence for each, and "impact on the goal"
     (what this means for the plan).
  2. **Details**: full findings, comparison tables (for example, existing
     products with features, price, license, last update), and the source
     list.
- Say plainly when something could not be found or verified.
- Keep the question's wording and the user's goal at the top of the report so
  the report stands alone.

The repository includes install steps for adding the skill to Gemini, and a
note about which modes (Deep Research, Tasks, chat) it was tested with.

## 7. Change to `/interview`

Small edit, keeping the rest of the skill as it is:

- At the start, look for a matching `.plans/<topic>-goal.md`. If one exists,
  read it and treat its confirmed real goal as settled. Do not ask again
  about what it already covers.
- If a question depends on facts the user cannot answer, offer a
  `/gemini-handoff` prompt instead of guessing.

## 8. Repository

- New repository (name to decide), with `skills/discover/`,
  `skills/gemini-handoff/`, `gemini/research-skill/`, `README.md` and install
  steps.
- The `/interview` change goes in `23jmo/jmo-skills`, or the new repository
  includes a copy. Decide when building.
- Cloud setup: extend the "building anti" environment's setup script to also
  clone the new repository and copy its `skills/*` into `~/.claude/skills/`.

## 9. Acceptance checks

- `/discover "build a Chrome extension that saves tabs"` → challenge mode;
  asks about the need behind it; mentions that existing tab managers may
  exist and offers a `/gemini-handoff` prompt; asks build vs buy.
- `/discover "something to help me with my clients"` → explore mode; does not
  jump to a solution.
- The goal brief has all 12 sections, and the user confirmed the real goal.
- `/gemini-handoff` produces a prompt that, when pasted into Gemini with the
  Gemini skill, returns a report with the Summary/Details shape.
- A pasted report is saved, the summary is folded into the brief, and the
  detail is not read in full unless needed.
- `/interview` run after `/discover` does not ask again about the goal.

## 10. Open questions

- Name of the new repository.
- Whether the Gemini skills feature on the user's plan supports everything
  needed (fall back to a Gem if not).
- Whether `/interview` changes live in `jmo-skills` or the new repository.
