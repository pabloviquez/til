# Delete Branch Local and Remote

## Create new branch

```bash
git checkout -b branch_abc


... Change stuff ...

# Commit changes
git commit -m "Some changes xyz"

# Push to remote
git push -u origin branch_abc

```

## Delete the branch locally

```
git checkout master

git branch -d branch_abc
```

## Delete the branch on remote

Once deleted locally, you need to push the changes to remote, letting the server know the branch was deleted

```
git push origin --delete branch_abc
```