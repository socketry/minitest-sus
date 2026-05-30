# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "minitest/autorun"
require "minitest/sus"

class MinitestSusVersionTest < Minitest::Test
	def test_has_a_version
		assert_match(/\A\d+\.\d+\.\d+\z/, Minitest::Sus::VERSION)
	end
end

# A plain Minitest test must be completely unaffected by the bridge:
class MinitestSusIsolationTest < Minitest::Test
	def test_does_not_respond_to_bridge_hooks
		refute_respond_to self, :around
		refute_respond_to self, :mock
	end
end

# A bare bridge (no fixtures) should still run tests normally via the `around`
# chain, invoking `before` and `after`:
class MinitestSusContextTest < Minitest::Test
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
