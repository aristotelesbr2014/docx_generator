# DocxGenerator

A gem to generate docx files.

## Installation

Add this line to your application's Gemfile:

    gem 'docx_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docx_generator

## Usage

To create a new docx file, just type:

```ruby
require 'docx_generator'

DocxGenerator::Document.new("filename").save # Will save the document to filename.docx
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request