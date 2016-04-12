# What's This?

This is a stock Rails application designed to be served through Puma, which demonstrates some sort of issue with making requests via Puma's UNIX domain socket.

# How To Reproduce The Issue

- Must be running under JRuby; MRI does not exhibit the issue.
- Must make requests via Puma's UNIX domain socket; TCP sockets do not exhibit the issue.
- Reproducible on at least OS X 10.11 and CentOS 6.7.

1. `bundle install`
2. `puma`
    ```
    Puma starting in single mode...
    * Version 3.4.0 (jruby 9.0.5.0 - ruby 2.2.3), codename: Owl Bowl Brawl
    * Min threads: 0, max threads: 16
    * Environment: development
    * Listening on unix://tmp/sockets/puma.sock
    * Listening on tcp://127.0.0.1:3000
    Use Ctrl-C to stop
    ```
3. `nc -U tmp/sockets/puma.sock < resources/request_json.txt`
4. `nc -U tmp/sockets/puma.sock < resources/request_text.txt`

Both of the requests given above should return 30 lines of lorem ipsum.  On my systems, sometimes I get the full response, sometimes I get about half that.

# More Information

I created a new Rails app with a completely clean environment like this:

1. `mkdir big_response_test`
1. `cd big_response_test`
1. `echo 'jruby-9.0.5.0' > .ruby_version`
1. `echo '.gems' > .rbenv_gemsets`
1. `gem install rails`
1. `rails new .`
1. Add Puma to Gemfile
1. `bundle install`
1. Create controller in `app/controllers/things_controller.rb`
1. Create controller in `app/controllers/api/v1/things_controller.rb`
1. Added controllers to `config/routes.rb`

## Odd Behavior

This is the same command from the reproduction steps, but `nc`'s STDOUT is being redirected to a file:

`nc -U tmp/sockets/puma.sock resources/request_json.txt > response.txt`

I would expect this to *not* alter the result, but in fact it seems to greatly reduce the odds that the issue will be exposed.  In fact, the issue seems to almost disappear on my CentOS boxes when I do this - the output file will almost always contain the full, expected response.  The OS X box will still reliably show the issue when using this command though.  I don't really understand how redirection could affect this issue.

## Resources

In the `resources` directory is a collection of files describing my environment, the exact requests I used, and example responses from as a result of making those requests.

## Useful Commands

I've observed that the size of the response tends to vary between systems (it might be correlated with performance or the operating system in use).  There is a query parameter to make larger responses if needed:

```
http://127.0.0.1/things?count=100
http://127.0.0.1/api/v1/things?count=100
```

You can make files to feed to `nc` to make requests like this:
```
nc -l 3000 > my_new_request.txt
```

Now direct your browser to `http://127.0.0.1/things?count=150` or something, then kill `nc`.  The text file will contain the exact request sent by your browser.  You can now feed this file to `nc` to replay the request to Puma at will:
`nc -U tmp/sockets/puma.sock < my_new_request.txt`