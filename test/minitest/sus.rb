# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "minitest/sus"

describe Minitest::Sus do
	it "has a version" do
		expect(Minitest::Sus::VERSION).to be =~ /\A\d+\.\d+\.\d+\z/
	end
end
