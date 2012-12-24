# Git Dj - is an simple lightweight alternative for git flow. See, how it works:

**gdj integrate** – merges current branch into staging branch, executes git push origin staging and switches back to current branch
**gdj release** merges current branch into master branch, pushes changes and switches back to current branch

If you want to start new feature:

    git checkout master
    git checkout -b my_super_cool_feature_branch
    
If you want deploy it into staging use:

    gdj integrate
    cap staging deploy

If you want to finish feature:

    gdj release
    cap production deploy

Integrate and Release should fail, if git merge failes. In this case,
resolve conflits and type:

    gdj continue


This will proceed all previous commands.

If you want to push to remote branch:

    gdj put

And this will execute:

    git pull origin [branch_name]
    git push origin [branch_name]

If you want to pull remote branche, run:

    gdj get

And this will execute:

    git pull origin [branch_name]

Keep your workflow simple.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
