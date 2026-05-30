# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

# These are real Minitest tests, exercised as a subprocess by the sus suite in
# `test/minitest/sus/context.rb`. They live in a dot directory so that sus does
# not pick them up directly.

require "minitest/autorun"
require "minitest/sus"

# A plain Minitest test must be completely unaffected by the bridge:
class IsolationTest < Minitest::Test
	def test_does_not_respond_to_bridge_hooks
		refute_respond_to self, :around
		refute_respond_to self, :mock
	end
	
	def test_does_not_leak_version
		refute defined?(self.class::VERSION), "VERSION should not leak into the test class!"
	end
end

# A bare bridge (no fixtures) should still run tests via the `around` chain,
# invoking `before` and `after`:
class ContextTest < Minitest::Test
	include Minitest::Sus::Context
	
	def before
		super
		@events ||= []
		@events << :before
	end
	
	def after(error = nil)
		@events << :after
		super
	end
	
	def test_before_runs_before_the_test
		assert_equal [:before], @events
	end
	
	def test_responds_to_bridge_hooks
		assert_respond_to self, :around
		assert_respond_to self, :mock
	end
end
