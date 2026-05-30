# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "minitest"

# We reuse sus's own mock implementation so that fixtures which rely on `mock`
# (e.g. sus-fixtures-async-http) work unchanged. It loads standalone.
require "sus/mock"

require_relative "sus/version"

module Minitest
	# A bridge that lets sus fixtures (plain modules exposing `before`, `after`,
	# `around`, helper methods and `mock`) be used inside Minitest tests.
	module Sus
		# Include this into a `Minitest::Test` subclass to host sus fixtures,
		# *before* the fixtures themselves so they sit above it in the ancestor
		# chain.
		#
		# It is opt-in per test class — nothing about Minitest::Test is patched
		# globally, so tests that don't use it are completely unaffected.
		#
		# It is the terminal of the fixture hook chain: it mirrors `Sus::Base`'s
		# `before`/`after`/`around` contract, bridges `mock`, and wraps the whole
		# Minitest run (setup + test + teardown) in the `around` chain so fixtures
		# such as the async reactor are active throughout.
		#
		# @example Use an async reactor fixture within a Minitest test:
		# 	class MyTest < Minitest::Test
		# 		include Minitest::Sus::Context
		# 		include Sus::Fixtures::Async::ReactorContext
		# 		
		# 		def test_example
		# 			Async::Task.current # We are running inside the reactor.
		# 		end
		# 	end
		module Context
			# A hook which is called before the test is executed. Fixtures override
			# this and call `super`.
			def before
			end
			
			# A hook which is called after the test is executed. Fixtures override
			# this and call `super`.
			# @parameter error [Exception | Nil] The error raised by the test, if any.
			def after(error = nil)
			end
			
			# Wrap logic around the test being executed. This is the terminal
			# implementation: it runs `before`, yields, then `after`. Fixtures
			# override this and call `super(&block)` to compose.
			def around(&block)
				self.before
				
				return block.call
			rescue => error
				raise
			ensure
				self.after(error)
			end
			
			# Bridge sus's `mock` API onto the Minitest instance. The first call
			# upgrades the instance with `Sus::Mocks`, which also installs the
			# `after` cleanup that clears the mocks.
			# @parameter target [Object] The object to mock.
			def mock(target, &block)
				self.singleton_class.prepend(::Sus::Mocks)
				
				# Redirect to the freshly prepended implementation:
				self.mock(target, &block)
			end
			
			# Run the test, wrapping the entire Minitest lifecycle in the `around`
			# chain so fixture state (reactor, server, client, ...) is available to
			# setup, the test body and teardown alike.
			def run
				result = nil
				
				around do
					result = super
				end
				
				return result
			end
		end
	end
end
