# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "minitest/autorun"
require "minitest/sus"

require "sus/fixtures/async/reactor_context"
require "sus/fixtures/async/http/server_context"

# Exercises the async reactor fixture:
class ReactorContextTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::ReactorContext
	
	def test_runs_inside_the_reactor
		refute_nil Async::Task.current
		assert_kind_of Async::Task, Async::Task.current
	end
	
	def test_exposes_the_scheduler_helper
		assert_equal Fiber.scheduler, scheduler
	end
end

# Exercises the HTTP server fixture, which itself relies on `before`/`after` and
# the `mock` API supplied by the bridge:
class ServerContextTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	def test_can_perform_a_request
		response = client.get("/")
		
		assert_equal 200, response.status
		assert_equal "Hello World!", response.read
	end
	
	def test_has_a_bound_url
		assert_match %r{\Ahttp://127\.0\.0\.1}, bound_url
	end
	
	def test_has_a_server
		assert_kind_of Async::HTTP::Server, server
	end
end

# Helper methods defined on the test class override the fixture defaults:
class CustomApplicationTest < Minitest::Test
	include Minitest::Sus::Context
	include Sus::Fixtures::Async::HTTP::ServerContext
	
	def app
		Protocol::HTTP::Middleware.for do |request|
			Protocol::HTTP::Response[200, {}, ["Custom!"]]
		end
	end
	
	def test_serves_the_custom_application
		assert_equal "Custom!", client.get("/").read
	end
end
