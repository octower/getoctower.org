<?php

use Symfony\Component\Finder\Finder;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\RedirectResponse;

$app->get('/', function () use ($app) {
    return $app['twig']->render('index.html.twig');
})->bind('home');