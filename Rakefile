# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "rake/testtask"

Rake::TestTask.new(:test) do |task|
	task.libs << "lib" << "test"
	task.pattern = "test/**/*_test.rb"
	task.warning = false
	task.verbose = true
end

task default: :test
