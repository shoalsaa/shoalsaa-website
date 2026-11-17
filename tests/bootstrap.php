<?php
// Test bootstrap: loads Composer autoloading and Brain Monkey.
// The plugin's own code is loaded by the individual tests that need it;
// WordPress functions are mocked with Brain Monkey, so no WordPress install
// is needed to run the unit suite.
require __DIR__ . '/../vendor/autoload.php';
