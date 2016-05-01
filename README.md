# MdSpec: Markdown as a Testable Document :memo:

**MdSpec** is a testing tool for example codes of your markdown files like ***README.md***.

## Usage

```shell
$ mdspec --version
MdSpec version ***
$ mdspec README.md

README.md
  Usage
    should pass `$ mdspec --version`
    should pass `$ mdspec README.md`
  Example of Configurations
    should be .mdspec.yml
    should pass yaml-lint

Finished in *** seconds
4 examples, 0 failures

```

## Example of Configurations

```yml
# global rules
rules:
  # pre-defined rule to run each command
  shell: bash-repl
  # it is able to define a custom command
  yml:
    type: command
    command: yaml-lint

# rules for specified files
README.md:
  # match pattern
  /Config/:
    type: diff
    diff: .mdspec.yml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/mdspec/mdspec.
