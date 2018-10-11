# ece552-project
## Introduction
This is the repository for the ECE 552 project for Group 10 / Who Are We. 

## File Locations
Each project phase's files are located in a directory demarked p(#) where # is the phase number. Please try to place files in the corresponding phase directory. 

## Files To Upload
Please do not upload any files except .v files. .BAK files are used internally for ModelSim's backup system and are not important for the actual project.

## Workflow
Please (generally) do not commit to master. Instead, always commit to a new branch (unless a merge commit) and...
####
If you made no changes to existing modules please merge your branch into master when **all modules of that branch are done**.
####
If there is a potential for merge conflicts (i.e. editing a file already pushed to master) open a pull request when **all modules of that branch are done**.

## Merging
To perform a simple merge from a specialized branch to master, first check it out to your local repository. Then git pull from the specialized branch on remotes/origin and then push it back up to master:
```
git checkout master
git pull origin MY_BRANCH_NAME
git push --set-upstream origin master
```
####
To perform a pull request click "New Pull Request" on the repository page. If there are no merge conflicts then press the Merge button at the bottom of the pull request page. If time allows, it may be safer to request a review from the original author of the modified file(s) and then have that author merge the file.
