# 000-Filesystem-Orchestrator


### Checksums

Maybe that's what Ox meant by “version history”? Terraform applies and logging the checksums of the differences?

metadata.json vs seed.json

Maybe seed.json can be a checksum for all currently created files? like the baseline type thing

#### Edits

- .seed.json: now it's static, created once and never again
- .medatata.json: it's static to, also used to pass variables for the templates


## Differences
- Randomized suffix: this will prevent different `projects` from being part of the same `workspace`


Glossary:

`workspace`: this is the root, the place where your projects will live
`project`: this is the project itself, what is inside the workspace
