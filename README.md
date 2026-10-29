# discovery-skills

Claude Code skills that find the real goal before planning, and hand heavy research off to the Gemini web app.

| Skill | What it does |
|---|---|
| `/discover` | Interviews you about the real goal, users, use cases and success criteria, without assuming your first idea is final. Writes `.plans/<topic>-goal.md`. |
| `/gemini-handoff` | Picks a Gemini mode (Deep Research, Tasks, plain chat), writes a ready-to-paste prompt, and folds the returned report into the plan. |
| `/interview` | Your jmo-skills `/interview`, plus: reads the goal brief and offers `/gemini-handoff` for unknown facts. Replaces the jmo-skills copy when installed after it. |
| `gemini/research-skill` | A skill for the Gemini web app that makes reports come back as SUMMARY + DETAILS. |

Flow: `/discover` → (`/gemini-handoff` as needed) → `/interview` → spec in `.plans/`.

## Install

### Claude Code on your computer (desktop app or terminal)

macOS / Linux:

```sh
git clone <this repo url> ~/discovery-skills
bash ~/discovery-skills/install.sh
```

Windows (PowerShell):

```powershell
git clone https://github.com/23jmo/jmo-skills $env:TEMP\jmo-skills
git clone <this repo url> $HOME\discovery-skills
New-Item -ItemType Directory -Force $HOME\.claude\skills | Out-Null
Copy-Item -Recurse -Force $env:TEMP\jmo-skills\skills\* $HOME\.claude\skills\
Copy-Item -Recurse -Force $HOME\discovery-skills\skills\* $HOME\.claude\skills\
```

Restart Claude Code (or start a new session), then type `/` to check.

### Claude Code cloud environments

In claude.ai/code, open the environment menu, choose the environment, click **Edit**, and set **Setup script** to:

```bash
#!/bin/bash
set -e
GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 <this repo url> /tmp/discovery-skills
DISCOVERY_REPO=<this repo url> bash /tmp/discovery-skills/install.sh
rm -rf /tmp/discovery-skills
```

Repeat for every environment. The environment's network access must allow github.com. If this repository is private, the setup script cannot clone it without access; keep it public or see the cloud docs on GitHub access.

### Gemini web app

Add `gemini/research-skill/SKILL.md` as a skill in the Gemini app. If your plan has no skills feature, create a Gem and paste the file's body (everything after the `---` header) as its instructions.
