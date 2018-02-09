[gem]: https://rubygems.org/gems/info_hub
[travis]: https://travis-ci.org/OnApp/info_hub

# InfoHub

[![Gem Version](https://badge.fury.io/rb/info_hub.svg)][gem]
[![Build Status](https://travis-ci.org/OnApp/info_hub.svg?branch=master)][travis]

This gem delivers a simple DSL to read data from YAML files. It might be useful for storing some basic knowledge around the application.

### Installation
Add the following code to your `Gemfile` and run bundle install

```ruby
# Gemfile
gem 'info_hub'
```
and run `bundle install`

Create a new file which includes all syste-wide constants:
```ruby
# config/info_hub.yml
percentage:
    min: 1
    max: 100
```

Then add path to that file to `InfoHub` paths (in `config/initializers/info_hub.rb`)
```ruby
# config/initializers/info_hub.rb
InfoHub.info_hub_file_paths << File.expand_path('../info_hub.yml', __dir__)

InfoHub.finalize!
```
Before `finalize!` execution, you may add as many `.yml` files as you need. All of them will be deeply merged in the order they were added.

### Usage
Now anywhere in you code you can:
```ruby
InfoHub[:percentage] # => { min: 1, max: 100 }
# or the equivalent
InfoHub.fetch(:percentage) # => { min: 1, max: 100 }
```
You may also get some internal values:
```ruby
# Similar to `dig` in ruby 2.3
InfoHub.get(:percentage, :min) # => 1
InfoHub.get(:percentage, :max) # => 100
```
### Licence
See `LICENSE` file.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/OnApp/info_hub.
