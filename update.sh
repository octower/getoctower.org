#!/bin/sh

# config
root=`pwd`
build="octower-src"
buildscript="bin/compile"
buildphar="octower.phar"
target="web"
repo="https://github.com/octower/octower.git"
branch="develop"
composer="php $root/composer.phar"

# init
if [ ! -d "$root/$build" ]
then
    cd ${root}
    git clone ${repo} ${build}
fi

cd "$root/$build"

#if [ ! -d "$root/$build/composer.phar" ]
#then
#    curl -sS https://getcomposer.org/installer | php
#fi

# update master
git fetch -q origin && \
git fetch --tags -q origin && \
git checkout ${branch} -q && \
git rebase origin/${branch}&& \
${composer} install -q && \
php -d phar.readonly=0 ${buildscript} && \
mv ${buildphar} "$root/$target/$buildphar" && \
git log --pretty="%H" -n1 HEAD > "$root/$target/version"

# create tagged releases
for version in `git tag`; do
    if [ ! -f "$root/$target/releases/$version/$buildphar" ]
    then
        mkdir -p "$root/$target/releases/$version/"
        git checkout ${version} -q && \
        ${composer} install -q && \
        php -d phar.readonly=0 ${buildscript} && \
        touch --date="`git log -n1 --pretty=%ci ${version}`" ${buildphar} && \
        mv ${buildphar} "$root/$target/releases/$version/$buildphar"
    else
        touch --date="`git log -n1 --pretty=%ci ${version}`" "$root/$target/releases/$version/$buildphar"
    fi
done
