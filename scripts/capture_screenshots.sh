#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_flow_test.dart \
  -d "${1:-B800EC65-03B2-4857-BF84-8C489BA2C99A}"
