---
name: discover
description: Find out what the user actually wants before planning. Interviews about the real goal, users, use cases and success criteria, without assuming the stated goal is final. Writes a goal brief. Use before /interview when an idea is new or fuzzy.
allowed-tools: AskUserQuestion, Write, Read, Edit, Glob, Skill
---

The user has an idea for a software product, tool, automation, skill or agent. Your job is to find the **real goal** behind it before anyone plans or builds anything. Treat what the user says as a starting hypothesis, not the final goal. Do not write a spec and do not plan implementation.

## 1. Pick a pushback mode

Judge the request and pick one mode. State it in one line ("Mode: challenge — you named a specific solution, so I'll check it fits the need.").

- **Explore** — the idea is fuzzy ("something to help with my clients"). Ask open, gentle questions about the problem and the situation. Do not suggest solutions yet.
- **Probe** — the idea is partly formed. Ask "why" and "what if" questions to surface the need. Do not argue.
- **Challenge** — the user named a specific solution ("a Chrome extension that saves tabs"). Ask what need the solution serves and whether a different approach serves it better. Play devil's advocate where useful.

Change mode when the answers show the first choice was wrong, and say so in one line.

## 2. Interview

Use `AskUserQuestion`, up to 4 questions per round. Questions must not be obvious. Each option should be concrete and short, and recommend an option when you have a reason to. Cover, in roughly this order:

1. **Trigger** — what happened that made the user want this now.
2. **Users and situations** — who uses it, when, where, how often. Get 2–4 concrete use cases.
3. **Success** — what changes when this works, and how the user would notice.
4. **Current workaround** — what the user (or their users) do today instead, and what hurts about it.
5. **Constraints** — time, money, platforms, skills, accounts, legal limits.
6. **Non-goals** — what it must not become.

Follow the answers. If an answer is vague or contradicts an earlier one, ask about that before moving on. Read each answer for corrections or requests to change direction.

## 3. Research when facts are needed

When a question depends on facts the user does not know — existing solutions, technical feasibility, best practices, user or market facts — decide from the situation whether research is worth it. If it is, invoke the `gemini-handoff` skill instead of guessing. Do not do heavy web research yourself: the user runs research in Gemini to save Claude usage. Record the question under "Research to do" if the user wants to continue without waiting.

## 4. Build vs buy

If the interview or research shows an existing product already covers the real need, stop and ask the user (with `AskUserQuestion`): use it as is, extend it, or build their own. Do not decide for them. Record the decision in the brief.

## 5. Stop rule

Stop interviewing only when you can state all of: real goal, users, top use cases, success criteria, non-goals, constraints. Then show a restated goal in 2–4 sentences and ask the user to confirm or correct it. Repeat until confirmed.

## 6. Write the goal brief

Path: `<cwd>/.plans/<topic>-goal.md`, where `<cwd>` is the current working directory and `<topic>` is a short kebab-case slug. Create `.plans/` if needed. Never save under `~/.claude/`. Write the absolute path and state it in your reply.

Use these sections:

```markdown
# Goal brief: <topic>

## 1. Stated goal
## 2. Real goal (confirmed)
## 3. Trigger / why now
## 4. Users and use cases
## 5. Success criteria
## 6. Current workaround
## 7. Constraints
## 8. Non-goals
## 9. Alternatives found and decision
## 10. Open questions
## 11. Research to do
## 12. Research findings
```

Leave a section with "None found" rather than inventing content.

## 7. Next steps

End with a short list:

- For each item in "Research to do": run `/gemini-handoff <question>`.
- Then: `/interview <topic>` — it reads this brief and writes the implementation spec.

<instructions>$ARGUMENTS</instructions>
