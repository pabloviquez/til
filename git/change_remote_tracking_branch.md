# Change Remote Tracking Branch

Going back to the [ TIL Simulate a Fork using different servers ](https://github.com/pabloviquez/til/blob/master/git/simulate_fork_different_servers.md) I needed to change a branch that was pointing to a differente remote than master.

## Branch and Remotes

### List Remotes

```bash

$ git remote -v
origin  ssh://git@bitbucket.org/pabloviquez/myrepository.git (fetch)
origin  ssh://git@bitbucket.org/pabloviquez/myrepository.git (push)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (fetch)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (push)

```

### List branches and remotes

```bash
git branch -vv

* master           eb2398d [origin/master] Merged in FYI-77 (pull request #9)
  fork_branch      4f6e7d7 [yyyyy/FYI-156: ahead 843] Merge branch 'FYI-156' of ssh://git@bitbucket.org/pabloviquez/myrepository.git into fork_branch
  
```

## Switch Remote Tracking Branch

In this case, I'm going to swtch the branch `fork_branch` to track `nicefeature` instead of `FYI-156`:

```bash

git branch fork_branch --set-upstream-to yyyyyy/nicefeature

git pull

```

**Done**