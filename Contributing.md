Contributing
====

The ECDSA gem is hosted on the [DavidEGrayson/ruby_ecdsa github page](https://github.com/DavidEGrayson/ruby_ecdsa).

To report a bug, go to the github page and create a new issue.

If you want to contribute code, these are the general steps:

1. Clone the git repository to your computer.
2. Run these commands to get the development dependencies:

        gem install bundler
        bundle
        
3. Run the specs with the command `bundle exec rspec` to make sure they are working.
4. Add a new spec somewhere in the `spec` directory for the bug or feature you want to fix.
5. Run the specs again to make sure your spec is failing.
6. Modify the code.
7. Run the specs again to make sure they are all passing.
8. Run 'rubocop' and fix any warnings (or prepare an argument for why the rubocop configuration should be changed).
9. Fork our repository on github and push your changes to a branch of your repository.  It is good practice make a branch with a special name and push to that instead of master.
10. On github, make a pull request from your branch to our repository.
    