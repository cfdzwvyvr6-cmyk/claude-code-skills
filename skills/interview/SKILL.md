---
name: interview
description: Interview user in-depth to create a detailed spec
allowed-tools: AskUserQuestion, Write, Agent, Read, Glob, Skill
---

Follow the user instructions and interview me in detail using the AskUserQuestionTool about literally anything: technical implementation, UI & UX, concerns, tradeoffs, etc. but make sure the questions are not obvious. be very in-depth and continue interviewing me continually until it's complete. then, write the spec to a file.

**Goal brief:** Before the first question, look for a matching goal brief at `<cwd>/.plans/*-goal.md` (written by `/discover`). If one exists, read it and treat its confirmed real goal, users, use cases and non-goals as settled — do not ask about them again. Use its research findings and open questions. Link the brief at the top of the spec.

**Unknown facts:** If a question depends on facts I cannot answer (existing solutions, technical feasibility, best practices, market facts), do not guess. Offer to invoke the `gemini-handoff` skill to write a Gemini research prompt, and continue with other questions while the research is pending.

**Save location:** `<cwd>/.plans/<relevant-name>.md`

- `<cwd>` = the current working directory — the project you are actually working in. Specs live with the code they describe so they are easy to find, open in an editor, and commit alongside the work.
- `<relevant-name>` = a short kebab-case slug describing the spec topic, ending in `-spec.md` (e.g. `friends-tab-redesign-spec.md`).
- Create the `.plans/` directory if it does not exist — the Write tool creates parent directories automatically.
- Always resolve and write the absolute path, and state the path you wrote to in your reply.
- Do not save specs under `~/.claude/` — they become impossible to find there.

<instructions>$ARGUMENTS</instructions>
