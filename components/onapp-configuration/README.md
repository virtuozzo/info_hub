InfoHub

System-wide configuration.

####DSL to add a new attribute:

```ruby
class Configuration
  config_attribute :some_attribute, save_to_file: true, getter: :numerical, setter: :boolean, default: 5, presence: true, length: { maximum: 60 }
end
```

```
:some_attribute - name of new attribute
:save_to_file - add new attribute to the list of attributes to save to file (default value is `true`)
:getter - define a custom getter
:setter - define a custom setter
:default - provides a default value for attribute, and store it in `defaults`. (can be `false`, but not `nil`)
*attributes - some validations for attribute.
```