# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "minitest/sus"

require "rbconfig"

# The actual Minitest tests live in `test/.minitest`, a dot directory which sus
# ignores during test discovery. We run each of them as a subprocess here and
# assert that Minitest reports success.
describe Minitest::Sus::Context do
	# The root directory of the project:
	root = File.expand_path("../../..", __dir__)
	library_path = File.join(root, "lib")
	
	Dir.glob("*_test.rb", base: File.join(root, "test/.minitest")).sort.each do |name|
		path = File.join(root, "test/.minitest", name)
		
		it "passes #{name}" do
			output = IO.popen([RbConfig.ruby, "-I#{library_path}", path], err: [:child, :out], &:read)
			status = $?
			
			# Surface the subprocess output if it failed, to aid debugging:
			inform(output) unless status.success?
			
			expect(status).to be(:success?)
			expect(output).to be(:include?, "0 failures, 0 errors")
		end
	end
end
