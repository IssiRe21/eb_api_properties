# eb_api_properties
Using Ruby, a class that consumes the EasyBroker API to read all properties from the staging account and prints their titles. Includes unit tests.

# How To Run
- Install gems
    `bundle install`

- Print property titles to stdout
    `API_KEY="your staging API key" ruby property_titles.rb`

- Run unit tests
    `rspec`