# Getting Started

This guide explains how to use the `minitest-sus` gem to use [sus](https://github.com/socketry/sus) fixtures within [Minitest](https://github.com/minitest/minitest) tests.

## Installation

Add the gem to your project:

``` bash
$ bundle add minitest-sus
```

## Usage

A sus fixture is a plain module that exposes `before`, `after` and `around` hooks along with helper methods. `Minitest::Sus::Context` provides the small amount of glue Minitest is missing (an `around` chain and a `mock` method) so those fixtures work unchanged.

Include `Minitest::Sus::Context` into your test class **before** the fixtures. The fixtures must sit above the bridge in the ancestor chain, so ordering matters:

``` ruby
require "minitest/autorun"
require "minitest/sus"

require "sus/fixtures/async/reactor_context"

class MyTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::ReactorContext
	
	def test_runs_inside_the_reactor
		# The fixture's `around` hook wraps the whole test in a reactor:
		refute_nil Async::Task.current
	end
end
```

The entire Minitest lifecycle (`setup`, the test method and `teardown`) runs inside the fixture's `around` block, so any reactor, server or client set up by the fixture is available throughout.

### HTTP Server Fixture

`sus-fixtures-async-http` provides a server and client. It uses sus's `mock` API internally, which the bridge supplies, so it works without any changes:

``` ruby
require "minitest/autorun"
require "minitest/sus"

require "sus/fixtures/async/http/server_context"

class ServerTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	def test_can_perform_a_request
		response = client.get("/")
		
		assert_equal 200, response.status
		assert_equal "Hello World!", response.read
	end
end
```

You can override the fixture's helper methods (e.g. `app`, `url`, `protocol`) just like you would in sus, by defining them in your test class:

``` ruby
class ApplicationTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	def app
		Protocol::HTTP::Middleware.for do |request|
			Protocol::HTTP::Response[200, {}, ["Hello from my app!"]]
		end
	end
	
	def test_serves_the_application
		response = client.get("/")
		
		assert_equal "Hello from my app!", response.read
	end
end
```

## Isolation

The bridge is opt-in per test class. Nothing about `Minitest::Test` is patched globally, so any test that does not include `Minitest::Sus::Context` is completely unaffected — no reactor is started and no hooks are installed.

## Limitations

The bridge supports the fixture contract used by gems like `sus-fixtures-async` and `sus-fixtures-async-http`: module-level `include`, the `before`/`after`/`around` hooks, helper methods and `mock`.

It does not implement sus's class-level context DSL (`include_context`, shared contexts, `let`, `it`, nested `describe`/`context`), as those overlap with Minitest's own test model. Write your test methods and assertions using Minitest as usual.

When a test raises, Minitest captures the exception internally before the `around` chain unwinds. The fixture's `after` hook still runs (so cleanup such as stopping a server or reactor happens as normal), but it always receives `error = nil` rather than the actual exception. Fixtures that only use `after` for cleanup are unaffected; fixtures that need the failure itself will not receive it.
