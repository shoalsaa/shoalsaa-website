<?php

use Brain\Monkey;
use PHPUnit\Framework\TestCase;

// Proves the test harness itself works. Real tests for the plugin land
// with the plugin code.
final class SanityTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Monkey\setUp();
    }

    protected function tearDown(): void
    {
        Monkey\tearDown();
        parent::tearDown();
    }

    public function test_harness_works(): void
    {
        $this->assertTrue(function_exists('Brain\\Monkey\\setUp'));
        $this->assertGreaterThanOrEqual(80400, PHP_VERSION_ID);
    }
}
