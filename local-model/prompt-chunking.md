Read 
Completed with input: {
  "path": "D:\\Github_projects\\shoalsaa-website\\shoalsaa-website\\local-model\\build-brief.md"
}

Read 
Completed with input: {
  "path": "D:\\Github_projects\\shoalsaa-website\\local-model\\build-brief.md"
}

Read 
Completed with input: {
  "path": "D:\\Github_projects\\shoalsaa-website\\docs\\# Build Brief Comparison.md"
}

The **chunk labels are a workflow aid, not a technical requirement**. This project does not mandate a model or context size; those depend on the implementer's current hardware and model choice. A prompt also needs room for instructions, relevant code, references, and the response. Include only the material needed for the task, and budget the assembled prompt against the selected model's actual configured context rather than relying on file size or an old token estimate.

The chunks address this by making each task smaller and focused: build the skeleton, implement one report component, then move on. Starting a fresh chat for a chunk also avoids carrying an ever-growing conversation forward. But labels alone don’t enforce the limit—the prompt must include only the shared rules, relevant references, and code needed for that chunk. And because a fresh chat loses conversational memory, each chunk should leave its progress in files, not rely on “remember what we did.”

Your multi-file approach would be easier to maintain. For example:

```text
local-model/
  build-brief.md                 # purpose, shared rules, sequence, links
  chunks/
    00-skeleton.md
    01-inventory.md
    02-backup-status.md
    03-burst-stats.md
    04-changes-since.md
    05-monthly-pdf.md
    06-tests.md
  references/
    verified-data-sources.md
```

Keep universal constraints in the top-level brief instead of copying them into every chunk. Give each chunk a short **goal, inputs, outputs, acceptance checks, and dependencies**. That captures the real order—such as the monthly email depending on inventory and usage collection—without implying that independent tasks must be strictly sequential.

For the 20% growth allowance, budget the **assembled prompt**, not just the Markdown file. As a starting point, leave about 20% of the selected model's configured context available for the response and variation. For example, a 4,096-token context suggests an approximate 3,200-token prompt budget; that number is only an example for the current local profile, not a project rule. Count with the selected model's tokenizer when available, since file size and word count are not reliable token measures. If the task and response do not fit, split the work further or choose a model with a suitable context.

For human-only explanations, use explicit HTML comment blocks:

```markdown
<!-- HUMAN-ONLY:BEGIN -->
This explains why the constraint exists; it is not an instruction to the model.
<!-- HUMAN-ONLY:END -->
```

The comments are hidden in rendered Markdown, but **a model reading the raw file can still see them**. So the reliable method is to have a prompt-preparation step strip those blocks before sending a chunk, and fail if a begin/end marker is unmatched. If you don’t want a preparation step, keep human explanations in a separate notes file that is never included in the model prompt.

I'll move all that and other "root requirements to a new file, and link or copy it into the build brief. I lean toward a new file to act as a single point that can be included wherever needed...

6:42 PM
That’s a good way to prevent requirements from drifting. Make the new file the canonical source; have build-brief.md serve as the index and workflow, and have each chunk reference the relevant requirement sections rather than duplicating them.

One caveat: a file link doesn’t guarantee a local model will read that file. When preparing a prompt, include the required sections (or use a small prompt-assembly step to pull them in). That keeps the repository’s requirements in one place without relying on the model to follow links.

6:42 PM
5s
Would the local modle honor some relative ao an include statement?

6:43 PM
Not automatically. A relative path such as include: ./requirements.md is just text unless the model’s host or prompt tool explicitly supports includes. A model with file-reading tools might follow an instruction to open it, but that’s less reliable than preprocessing.

For a dependable workflow, have a small script resolve paths relative to build-brief.md and insert the required sections into the prompt before sending it. Then the model receives the actual requirements, and you can also strip the human-only comment blocks and check the token budget. Keep the path in the brief as documentation, but don’t rely on it as the include mechanism.

---- 11/20/2026: record of proposed simplifications to this project:
The document i have open now (prompt-chunking.md) is a cut/paste of the last part of yestedays conversation. Wher I left off was working on the first file to merge into the top level project, with the inerim work being done in the duplicatly-named subdirectory tree. Everthing accomplished so far is presently in D:\Github_projects\shoalsaa-website\shoalsaa-website\local-model\build-brief.md. my progress yesterday was painfully slow, partly due to interruptions (a medical appointment that took 3 hrs instead of what should have been 1 hr), and several phone calls. The document "prompt-chunking.md" is a summary of our discussion about that and how to improve the way forward. I would propose another simplification - the current project top level description i a mess, made up of what should be 3 separate projects, one of which shold be abandoned: the AI interfaces to the report  originally described as phase 1, swapped to phase2, and the out of place "website succession plan". I think todays first step should be to move everything related to the succession plan into a new project. That project has no associated code delelopment, it's all documentation for a proposed human activity with guielines and decisions on other vendor products to imlement the plan. That gets one piece of the confusion out of the Shoalsaa-website project. Next, simplify the top level description so that it describes only the plugin with self-containd daily email status repors, and a monthly status summary including useage statistics. Put aside for now any reference to the MCP adapter interfaced reporting, If ever revisited, the design is lilely to be different as wordpress' MCP adapter interface is very new and almost certain to change as it matures.
Change this chat's workspace to D:\Github_projects\Website-succession-plan and make changes directly in that folder? Other chats keep their workspaces.
