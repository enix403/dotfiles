---
name: sk-all-pr-desc
description: Generates a clear and concise pull request description based on the changes made in the branch. Use when a PR description is needed for the current branch/changes.
---

# PR Description Generation

Use this skill to generate a clear and concise pull request description based on the changes made in the branch. This skill can be used when the user requests help with writing a PR description or when creating a PR description for the current branch.

## Target Changes

Unless user specifies otherwise, consider changes introduced in current branch. To get the target changes, use command `git diff master...HEAD`. Ignore merge commits from master branch. Ignore any temporary changes that are clearly there for debugigng/development purposes and are not intended to be part of the final PR.

This will include committed changes in current branch.

## Description Content

- Use the pull_request_template.md template file for creating descriptions. This file will be found in the `.github` directory of the root of the current git repository. To find the repository root, use `git rev-parse --show-toplevel`.

- Extract the JIRA ticket id from the branch name. Most of the times, the branch name will be suffixed with the JIRA ticket id e.g `feature/my-feature-PROJ-1256`, but there could be exceptions. If you cannot find the ticket id from the branch name, you can also look for it in the commit messages. If you still cannot find it, then you can leave the JIRA ticket id field empty in the description.
- Do not use em-dashes (—) in the description. Use regular hyphens (-) if needed.

## Output

Give markdown code for the description that can be directly copied and pasted into the PR description field in GitHub. **Do not** include any explanations or additional text, only the markdown content for the PR description. Give output *as RAW* MARKDOWN code, *NOT as rendered* markdown. The code should be copy-able as it is.