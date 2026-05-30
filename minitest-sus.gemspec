# frozen_string_literal: true

require_relative "lib/minitest/sus/version"

Gem::Specification.new do |spec|
	spec.name = "minitest-sus"
	spec.version = Minitest::Sus::VERSION
	
	spec.summary = "Use sus fixtures within Minitest tests."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.homepage = "https://github.com/socketry/minitest-sus"
	
	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/minitest-sus/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/socketry/minitest-sus.git",
	}
	
	spec.files = Dir.glob(["{context,lib}/**/*", "*.md"], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.3"
	
	spec.add_dependency "minitest", ">= 5"
	spec.add_dependency "sus", "~> 0.31"
end
