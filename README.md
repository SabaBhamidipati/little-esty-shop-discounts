# Little Esty Shop Discounts

<img width="1247" alt="Screen Shot 2022-06-15 at 8 41 30 AM" src="https://user-images.githubusercontent.com/88849965/173834743-d3affab0-e518-4034-9ae2-8d84dde47ff5.png">

## Background and Description

"Little Esty Shop" is a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

## Saba's Learning Goals
- Practice designing a normalized database schema and defining model relationships
- Utilize advanced routing techniques including namespacing to organize and group like functionality together.
- Utilize advanced active record techniques to perform complex database queries
- Practice consuming a public API while utilizing POROs as a way to apply OOP principles to organize code
- Build out CRUD functionality for a many to many relationship
- Leverage explicit relationships to create additional ones where ActiveRecord use can be rationalized
- Use ActiveRecord to write queries that join multiple tables of data together
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
- Validate models and handle sad paths for invalid data input
- Use flash messages to give feedback to the user
- Use partials in views
- Use within blocks in tests
- Track user stories using GitHub Projects
- Deploy an application to Heroku
- Develop functional knowledge to troubleshoot Heroku errors

## Testing Coverage

Model Testing: 99.8% (Total Revenue calculation not tested in Discounts proj. as it is already tested in prior project: /models/invoice.rb) 
Feature Testing: 100%

## Requirements
- must use Rails 5.2.x
- must use PostgreSQL
- all code must be tested via feature tests and model tests, respectively
- must use GitHub branching, team code reviews via GitHub comments, and github projects to track progress on user stories
- must include a thorough README to describe the project
- must deploy completed code to Heroku

## Setup

This project uses Ruby 2.7.4 and Rails 5.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

## Phases

1. [Database Setup](./doc/db_setup.md)
1. [User Stories](./doc/user_stories.md)
1. [Extensions](./doc/extensions.md)
1. [Evaluation](./doc/evaluation.md)
