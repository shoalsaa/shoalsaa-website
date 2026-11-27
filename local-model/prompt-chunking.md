# Feeding the build brief to a local model in parts

Guidance for preparing prompts from `build-brief.md` for a local model with
a limited context window. The brief and the design document
(`docs/site-report-plugin-design.md`) set the requirements; this file only
covers how to deliver them to the model.

## Chunks are a workflow aid

The build brief's chunks (0–6) are a way to keep each task small and
focused, not a technical requirement. The project does not mandate a model
or context size; those depend on the implementer's hardware and model
choice. Combine or split chunks to suit the model you use.

Labels alone do not keep a prompt within the limit. Each prompt should
include only:

- the shared constraints from the build brief,
- the design sections and verified data sources that chunk needs,
- the existing code that chunk touches,
- room for the model's response.

Start a fresh chat for each chunk so the conversation does not keep
growing. A fresh chat has no memory of earlier chunks, so each chunk must
leave its progress in files (code, `BUILD-NOTES.md`), never rely on
"remember what we did".

## Prompt budget

Budget the assembled prompt, not just the Markdown file. As a starting
point, keep the prompt to about 80% of the model's configured context and
leave the rest for the response and variation. For example, a 4,096-token
context suggests a prompt of about 3,200 tokens; that number is only an
example. Count with the model's own tokenizer when you can, since file size
and word count are not reliable token measures. If a task and its response
do not fit, split the task further or choose a model with a larger context.

## Possible file layout

If the single brief becomes hard to manage, split it like this, keeping the
shared rules in one place instead of copying them into every chunk:

```text
local-model/
  build-brief.md               # purpose, shared constraints, sequence, links
  chunks/
    00-skeleton-scheduling.md
    01-inventory-changes.md
    02-backup-status.md
    03-usage-statistics.md
    04-daily-email-sending.md
    05-monthly-email.md
    06-tests.md
  references/
    verified-data-sources.md
```

Give each chunk file a short goal, inputs, outputs, acceptance checks, and
dependencies. That records the real order (the monthly email depends on
inventory and usage collection, for example) without implying that
independent tasks must run strictly in sequence.

## Includes and human-only notes

A local model does not follow links or `include:` lines by itself; a
relative path is just text unless the host tool supports includes. A model
with file-reading tools might open a linked file when told to, but that is
less reliable than preparing the prompt in advance.

The dependable approach is a small prompt-assembly script that:

1. resolves the files and sections a chunk needs, relative to
   `build-brief.md`, and inserts their text into the prompt;
2. strips human-only explanation blocks, marked like this, and fails if a
   begin or end marker is unmatched:

   ```markdown
   <!-- HUMAN-ONLY:BEGIN -->
   Why this constraint exists; not an instruction to the model.
   <!-- HUMAN-ONLY:END -->
   ```

3. checks the assembled prompt against the token budget.

HTML comments are hidden in rendered Markdown, but a model reading the raw
file still sees them, so strip them before sending. Without an assembly
step, keep human-only explanations in a separate notes file that is never
included in a prompt.
