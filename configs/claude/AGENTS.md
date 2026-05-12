# Briant's Claude Interaction Requirements

These communication preferences define how I want to interact with Claude. When operating under a Captain persona (see CAPTAIN.md), these requirements still apply — the persona governs voice and delegation style, but these rules govern behavior.

## General Communication

### Honesty
- You must always be honest and up front with me. Specifically, please consider these specific scenarios:
  - When I understand something incorrectly, or propose a solution that doesn't make sense, I'd like to discuss. Do not just assume I'm correct by default.
  - When you encounter unknowns, knowledge gaps, story questions, etc, stop and discuss. You must never respond with fabrications or guesses.

### Response Length & Pacing
- Be concise. Unless I request a more detailed explanation, avoid unnecessary explanation or preamble.
- In discussion and planning, present one step, decision, or concept at a time. Wait for my input before moving forward. Do not front-load information from steps I haven't reached yet.
- For instructional content (how-tos, debugging steps), a full numbered list is appropriate — I need the whole picture to follow along.
- For architecture and planning discussions, treat it like conversation — propose one piece, get my feedback, then move to the next.

### Formatting
- Emoji use is encouraged.
- Use bulleted and numbered lists in conversation, especially when:
  - Presenting a process with steps to follow.
  - Presenting debugging steps or bugs.
<!-- - Include a dad joke or a reference to Star Trek 75% of the time. -->
- Shell commands must always be on a single line — no line continuations, no multiline formatting. This applies to commands in code blocks and commands mentioned inline in conversation.

## Git
- You are required to ask me before taking any actions with git, even if I ask you to "save" or "finish" work.
- Commit messages:
  - Convention: <type>(<optional scope>): [<ticket>] <summary>
  - The “type” should be one of feat, fix, or cleanup
  - Do not include the "co-authored by claude" statement
- My branch name style is <story-number>-brief-description-of-story

## Coding Style
- Use early returns and guard clauses.
- Edit existing files rather than creating new ones.
- Case statements must use multi-line `when` blocks — no `then` on the same line as `when`. Put the condition/result on its own indented line.
- Don't align operators with padding. Use a single space around `=`, `=>`, and similar operators regardless of surrounding key/variable name lengths. This applies to assignments, hash literals, and constants.
- Any refactors that are unrelated to the in-scope task require my approval. If you notice refactors surrounding our work that make sense, present them for discussion.

## Code Reviews
- **One at a time means one at a time.** Present a single item, then stop and wait. Do not address, fix, or move on to the next item until I explicitly respond. This applies even if the fix seems obvious.
- You are required to present me with comments before posting them.
- Tone: These comments have my name on them. Keep them kind, concise, and conversational — not directive. Frame feedback as discussion, not instructions. For suggestions where either approach is valid, leave the decision to the other person.

### Providing Feedback
- Post each piece of feedback as an inline review comment on the relevant line of code — not as a general PR comment.
- Before presenting feedback, check existing PR comments from other reviewers. Skip items already covered — don't post duplicates.

### Responding to Feedback
- Respond directly on the inline comment when possible, rather than posting a general PR comment.

## Testing
- Tests are required:
  - For bugs, add tests to cover any missed scenario(s). If existing tests have coverage gaps, correct them.
  - For new features, always add tests to cover all new functionality.

## Workflow & Autonomy
- Before making any significant changes, discuss and agree on a plan first.
- Ask before installing new dependencies.
- Ask before creating new files.
- When in doubt, ask rather than guess.
- When crew members are deployed via CAPTAIN.md, the captain is responsible for coordinating their work. Approval still flows through Briant.
