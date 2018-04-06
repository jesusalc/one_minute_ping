# One Minute Ping

A small ruby gem that exposes a cli to check status of a website.
After probing the website for one minute every ten seconds it prints the average response time.

This gem would be looking to do the average like in 
apache benchmark. 

For Example:
```bash
ab -k -c 1 -n 1 -t 60 -s 10 https://www.gitlab.com/
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'one_minute_ping'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install one_minute_ping
```


## Usage

```bash
bundle exec exe/one_minute_ping for https://www.gitlab.com/
```
Sample Output:

    Server Hostname:      https://www.gitlab.com/
    
    Counted requests:     6
    Time taken for tests: 6.025 seconds
    
    Time for status 308:  561.648 [ms] (mean, only per all responses with status 308)
    Time per request:     561.648 [ms] (mean, across all concurrent requests)

```bash
bundle exec exe/one_minute_ping for https://www.about.gitlab.com/
```

Would Output:

    Server Hostname:      https://www.about.gitlab.com/
    
    Counted requests:     6
    Time taken for tests: 6.025 seconds
    
    Time for status 308:  561.648 [ms] (mean, only per all responses with status 308)
    Time per request:     561.648 [ms] (mean, across all concurrent requests)

## Generate GEM

```bash
rake build
```

## Install CLI

```bash
rake install 
```
After install there should be a new CLI command:

```bash
one_minute_ping
```

which now you can call simply:
```bash
one_minute_ping for https://www.about.gitlab.com/
```

## Run Tests

```bash
rake
```
and with coverage 
```bash
deep-cover exec rspec
```



## Development

After checking out the repo, run `bin/setup` 
to install dependencies. 
You can also run `bin/console` for an interactive 
prompt that will allow you to experiment.

To install this gem onto your local machine, 
run `bundle exec rake install`.
To release a new version, 
update the version number in `version.rb`, 
and then run 
`bundle exec rake release`, 
which will create a git tag for the version, 
push git commits and tags, 
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Bug Reports

Bug reports and pull requests are welcome on GitHub at https://gitlab.com/jesusalc/one_minute_ping/issues

## Contributing

1. Create your feature branch (`git checkout -b my-new-feature`)
2. Create tests (`rake`)
3. Pass your tests (`deep-cover exec rspec`)
4. Check with Rubocop (`bundle exec rubocop -a`)
5. Commit your changes (`git commit -am "Add some feature"`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
