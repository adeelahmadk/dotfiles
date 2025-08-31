#!/bin/bash

if command -v uv > /dev/null; then
  uv self update
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
