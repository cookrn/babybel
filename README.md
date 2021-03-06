![Babybel Logo](https://raw.githubusercontent.com/cookrn/babybel/master/_assets/babybel.png)

---------------------------------------------------

# Babybel

*Note: both of the below Lisp implementations are currently in progress.*

Babybel is Ruby gem containing two Lisp implementations:

1. [Bel](http://paulgraham.com/bel.html) as described in
   [the spec](https://sep.yimg.com/ty/cdn/paulgraham/bellanguage.txt?t=1570993483&)
   by Paul Graham. Status: non-functional.
2. Minibel, a Bel-inspired Lisp tightly integrated with the Ruby object system and
   runtime. Status: barely functional.

In both cases, see the included specs describe the implementation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'babybel'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install babybel

## Foundations

Both of the in-progress Lisp implementations are built in Ruby and are interpreted. The
excellent [Parslet](https://github.com/kschiess/parslet) library provides the tooling
for creating the parser grammar and transformation to an S-expression format used to
build the interpreter.

## Usage

Eventually, the gem will provide one or more CLI tools for executing the Babybel
and Minibel Lisps. For now though, it needs to be embedded as a library.

```ruby
require 'babybel'
bel_file = File.read('my/program.bel')
result = Babybel::Minibel::Interpreter.new.evaluate(bel_file)
```

Only the Minibel implementation is far enough along to use today as shown above.

## Inspirations

Other than Bel itself, see the following:

- Flea: https://github.com/aarongough/flea
- Parslet Minilisp Example: https://github.com/kschiess/parslet/blob/master/example/minilisp.rb
- Hy: https://docs.hylang.org/en/stable/index.html

Check out [this doc](https://github.com/cookrn/babybel/blob/master/docs/inspirations.md)
as well for lots more links!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To release a new version, update the version number in `version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cookrn/babybel.

## License

Obviously, no ownership, rights, copyright, or trademark of the Babybel name or
logo were obtained or are implied with this project. Lisp is not cheese.

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
