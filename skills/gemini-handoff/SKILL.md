---
name: gemini-handoff
description: Hand off research or structured web lookups to the Gemini web app to save Claude usage. Picks the right Gemini mode, writes a ready-to-paste prompt, and folds the returned report into the plan. Use when a planning question depends on facts that need web research, or when the user asks to research something in Gemini.
allowed-tools: Read, Write, Edit, Glob, AskUserQuestion
---

# Gemini handoff

The user runs research in the Gemini web app (Google AI Pro) so Claude does not spend its usage on it. You do not call Gemini. You write the prompt, the user runs it, and you use the report they bring back. This skill is called by `/discover` and `/interview`, or directly by the user.

## 1. Frame the question

Write down:

- **Question** — one clear research question. Split unrelated questions into separate handoffs.
- **Why it matters** — which decision in the goal or plan depends on the answer.
- **Known already** — facts and constraints from the conversation, the goal brief (`.plans/*-goal.md`) or the spec.
- **Wanted output** — for example, a comparison table of existing products, a yes/no feasibility answer with limits, or a list of best practices.

Do not include credentials, tokens, private keys, or unrelated personal material.

## 2. Pick a Gemini mode

Pick one and say why in one line:

| Mode | Use when |
|---|---|
| **Deep Research** (high thinking model) | Broad or deep questions with many sources: landscape of existing solutions, best practices, feasibility. |
| **Gemini Tasks** | Multi-step jobs Gemini can run on its own, such as collecting and comparing a long list of products. |
| **Plain chat** | Small factual checks: "list products that do X", "does API Y allow Z". |

In every mode, tell the user to start the **research-report** Gemini skill first (installed from `gemini/research-skill/` in this repository) so the report comes back in the fixed format. If the user does not have it, include the format rules from section 3 at the end of the prompt.

## 3. Write the prompt

Save it to `<cwd>/.plans/research/<topic>-prompt.md` (create the folder if needed) and also show it in chat in one fenced block the user can copy.

Prompt template:

```
Research question: <question>

Context: <goal and why the answer matters, 2–5 sentences>

Already known: <bullets>

What I need back: <wanted output>

Report format:
1. SUMMARY (at most about one page): the question restated, a direct short answer, key findings as bullets with source links and a confidence level (high/medium/low) for each, and "Impact on the goal" — what this means for the plan.
2. DETAILS: full findings, comparison tables where useful, and the complete source list.
Say plainly when something could not be found or verified. Do not invent sources.
```

Then tell the user, briefly:

1. Which Gemini mode to open.
2. To start the research-report skill and paste the prompt.
3. To return the report by pasting it here, or saving it to `<cwd>/.plans/research/<topic>-report.md` and telling you.

Then stop and wait. Do not claim research was done, and do not guess the findings.

## 4. Use the report

When the report comes back:

1. If it was pasted, save it to `<cwd>/.plans/research/<topic>-report.md`.
2. Read the **SUMMARY** first. Read the DETAILS only for points the decision needs.
3. Add the key findings, with source links, to the calling document: section 12 "Research findings" of the goal brief, or the relevant section of the spec. Remove the item from "Research to do".
4. If the findings change the goal — for example, an existing product already covers the need, or the approach is not feasible — say so plainly and return to the calling skill's confirmation or build-vs-buy step.
5. State every file path you wrote, as absolute paths.

<instructions>$ARGUMENTS</instructions>
