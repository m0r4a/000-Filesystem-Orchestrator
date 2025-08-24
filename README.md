# 000-Filesystem-Orchestrator

## TODOs after reading the new butterdocs thingy
- extra_dirs on example:  docs, data, scripts and metadata
- outputs:
  - final workspace path
  - list of created files
- pinning: Ox's example of pinning is way prettier
- Change pinned versions:
  - terraform: >= 1.6.0
  - local: ~> 2.5
  - null: ~> 2.3

### Checksums

**This is the weakest part of the project right now**

goal: script that enumerates files: computes checksums and writes a manifest JSON

- file checksums: maybe a checksum of all the default files combined? do I include the dirs? maybe only the templates 
- How will using README as a trigger make it idempotent?
- What do you mean every run?
- Each apply? Is this supposed to be re-applied more than once?
- Maybe add the script at the workspace level using the `default_dirs` thing under the `workspace` module.

The most confusing part is the re-apply. I hadn’t thought about the possibility of making changes to the infrastructure,
then doing a terraform re-apply, and having the trigger run when it detects a new change and creates new metadata.
If that’s the case, wouldn’t it be better to track each file?

_Edit: I don't think so, the doc says "avoid triggers that change on every run"_

Maybe that's what Ox meant by “version history”? Terraform applies and logging the checksums of the differences?

metadata.json vs seed.json

Maybe seed.json can be a checksum for all currently created files? like the baseline type thing


## Differences
- Randomized suffix: this will prevent different `projects` from being part of the same `workspace`


Glossary:

`workspace`: this is the root, the place where your projects will live
`project`: this is the project itself, what is inside the workspace
