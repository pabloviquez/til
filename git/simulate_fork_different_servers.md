# Working with multiple remotes

## Simulate a Fork using different servers

2 remotes:
* origin -> Server A (ssh://git@bitbucket.org/pabloviquez/myrepository.git)
* yyyyyy -> Server B (git@github.com:pabloviquez/my_original_repo.git)

Main development will happen in `origin` and changes from `yyyyyy` needs to be merged into `origin`


### 1. Initial Setup

By doing this, origin is automatically point it to the bitbucket repo

```
git clone ssh://git@bitbucket.org/aleemb/myrepository.git
cd myrepository
```

### 2. Add new remote
```
git remote add yyyyyy git@github.com:pabloviquez/my_original_repo.git

```

List all remotes in the repo:

```
> git remote -v

origin  ssh://git@git.na.possible.com:2222/flor/flo.git (fetch)
origin  ssh://git@git.na.possible.com:2222/flor/flo.git (push)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (fetch)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (push)
```

### 3. Create new branch to track repository yyyyyy

The new branch will be called: `fork_branch` and the branch will point to master on yyyyyy.

Prior to creating the new branch, you need to pull the data from the yyyyyy remote

```
git pull yyyyyy
git branch --track fork_branch yyyyyy/master
```

Now, your repo is still empty, however theres a new branch called `fork_branch`

```
> git branch
  fork_branch
* master

```

**(Test Step 1) Switch to new branch**

```
git branch fork_branch

ls -l

```

As you can see, contains all the code which is awesome!

**(Test Step 2) Switch back to master**

```
git branch master

ls -l
```

### 4. Create new integration branch from master

```
git checkout -b integration
```

### 5. Rebase from fork_branch

```
git rebase fork_branch
```

Once rebased, you need to pull from origin

```
git pull origin
```

Now push changes to origin remote

```
git push -u origin integration
```


## Notes

### Merge or Rebase?

Merge should be done while working on internal branches, however, to pull code from yyyyyy and **merge** it into origin, its better to
use `rebase`.

**GOLDEN RULE ALERT** You do not rebase to a public branch, instead you rebase to a branch, otherwise, there will be monsters.
**SEE** https://www.atlassian.com/git/tutorials/merging-vs-rebasing/conceptual-overview/#the-golden-rule-of-rebasing


### Remove remotes

```
git remote rm REMOTE_NAME
```

**Example**
```
> git remote -v

origin  ssh://git@git.na.possible.com:2222/flor/flo.git (fetch)
origin  ssh://git@git.na.possible.com:2222/flor/flo.git (push)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (fetch)
yyyyyy  git@github.com:pabloviquez/my_original_repo.git (push)


> git remote rm yyyyyy

> git remote -v

origin  ssh://git@git.na.possible.com:2222/flor/flo.git (fetch)
origin  ssh://git@git.na.possible.com:2222/flor/flo.git (push)
```