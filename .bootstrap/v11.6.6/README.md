# AI Training v11.6.6 source import

Status: **the source ZIP has not been uploaded to GitHub yet.** The earlier multipart bootstrap was incomplete and its extraction runs failed before any source was extracted. This directory is retained only to explain that failure; no multipart upload is used by the corrected workflow.

## Complete archive input

Upload `AI_Training_v11.6.6_Source_NoBinaries.zip` to the **repository root on branch `source-v11.6.6`**, not to this directory or to `main`.

Expected archive SHA-256:

```text
e741d0e88752b617efd6d2b629b10a604086d3bf7545a5379929e0653e4856de
```

This source-only ZIP contains 256 files: the HTML template, JavaScript modules, Go launcher/backend source, build scripts, tests, retained text baselines, and documentation. It does not include the compiled licensed Windows executables.

The corrected workflow starts only when the complete archive is uploaded, or on an explicit manual dispatch. It checks the archive hash and safe paths, confirms version 11.6.6 and all 24 simulation modules, assembles developer HTML, checks JavaScript syntax, runs Go tests with the race detector, and runs the six-check v11.6.6 browser source regression. Only after these checks pass does it commit the browsable source to `source/v11.6.6` on this branch.

It does not modify `main`, `version.json`, live updater metadata, or licensing files. It refuses to replace an existing, different source tree. Native Windows startup and licence activation are outside this source-only validation.

Historical failed runs remain failed; a corrected workflow is not evidence that a source upload has completed. Use the source directory and a successful import run as the completion criteria.
