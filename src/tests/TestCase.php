<?php

use Laravel\Lumen\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    /**
     * Creates the application.
     *
     * @return \Laravel\Lumen\Application
     */
    public function createApplication()
    {
        return require __DIR__ . '/../bootstrap/app.php';
    }

    public function test_database()
    {
        $this->assertEquals('database/database.sqlite', env('DB_DATABASE'));
    }

    public function test_db_connection()
    {
        $this->assertEquals('sqlite', env('DB_CONNECTION'));
    }
}
