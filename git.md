# Git

This is how we use Git (and GitHub).

## 1. Clone

If you do not already have the repository locally you should clone it. We generally do not fork our repositories on GitHub, since all of us within the organization already have push rights.

    ```bash
    git clone git@github.com:standout/repository
    ```

## 2. Check out feature branch

Check out a branch from master, with a descriptive name. ```my-new-feature``` is a poor name choice.

    ```bash
    git checkout -b new-navigation-design
    ```

When naming your branch, try to make it a Friends episode title ("The one with the..."). This is a tip taken from [The RSpec book](http://pragprog.com/book/achbd/the-rspec-book), but in that case it was for naming scenarios in Cucumber. "The one with the new navigation design" works pretty good for a branch name, too.

When you have checked out your branch locally you should immediately push it to remote.

    ```bash
    git push -u origin new-navigation-design
    ```

## 3. Merge into master

When your new feature is stable (it does not necessarily has to be finished) and you feel it is time to merge it into master you have two options.

### A. Make a pull request

Many of our repositories have a "repository master". If your are not him you should ask for a code review by making a pull request. A pull request is easily done by clicking the pull request button in the repository on GitHub.

Sometimes even the repository master makes pull requests. Cases for that could for example be if there are many people working on the project, the repository master wants someone to review his code or if it is important to keep the history of the merge on GitHub.

### B. Merge into master locally

If you are working on a project alone (or pretty much alone) it does not make much sense that you should review your own code.

    ```bash
    git checkout master
    git merge new-navigation-design
    git push
    ```

## 4. Delete feature branch

When there is no more work to be done on your feature branch you can delete it.

    ```bash
    git checkout master # If your are not already there.
    git branch -d new-navigation-design
    git push origin :new-navigation-design
    ```
