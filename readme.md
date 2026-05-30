# Minitest::Sus

Provides a bridge for using [sus](https://github.com/socketry/sus) fixtures within [Minitest](https://github.com/minitest/minitest) tests, e.g. `sus-fixtures-async` and `sus-fixtures-async-http`.

[![Development Status](https://github.com/socketry/minitest-sus/workflows/Test/badge.svg)](https://github.com/socketry/minitest-sus/actions?workflow=Test)

## Usage

Please see the [project documentation](https://socketry.github.io/minitest-sus/) for more details.

  - [Getting Started](https://socketry.github.io/minitest-sus/guides/getting-started/index) - This guide explains how to use the `minitest-sus` gem to use sus fixtures within Minitest tests.

## Releases

Please see the [project releases](https://socketry.github.io/minitest-sus/releases/index) for all releases.

### Unreleased

  - Initial implementation of the Minitest ↔ sus fixtures bridge.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Running Tests

To run the test suite:

``` shell
bundle exec sus
```

### Making Releases

To make a new release:

``` shell
bundle exec bake gem:release:patch # or minor or major
```

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
