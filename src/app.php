<?php

require __DIR__.'/../vendor/autoload.php';

use Silex\Application;
use Silex\Provider\TwigServiceProvider;
use Silex\Provider\UrlGeneratorServiceProvider;
use Silex\Provider\ValidatorServiceProvider;
use dflydev\markdown\MarkdownExtraParser;

$app = new Application();
$app->register(new UrlGeneratorServiceProvider());
$app->register(new ValidatorServiceProvider());
$app->register(new TwigServiceProvider(), array(
    'twig.path'    => array(__DIR__.'/../views'),
));
$app['twig'] = $app->share($app->extend('twig', function($twig, $app) {
    return $twig;
}));

$app['octower.doc_dir'] = __DIR__.'/../octower-src/doc';

$app['markdown'] = function () {
    return new MarkdownExtraParser();
};

return $app;