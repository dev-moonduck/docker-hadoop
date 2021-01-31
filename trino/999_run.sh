#!/bin/bash

su --preserve-environment trino -c "trino $TRINO_HOME/bin/launcher start" &
