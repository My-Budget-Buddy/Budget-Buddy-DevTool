
Budget Buddy Dev Tool
=====================

This is a simple tool meant to make local development easier. It downloads all repositories, builds them, and containerizes them for you, rather than having to do all that work manually. It also can start up all of the services in the correct order with the correct environment variables.

It requires node, git, docker, and maven to run. Make sure that docker is running while you are using these scripts.

To remove old repositories, and then download and build all repositories, run:

    node build.js reset

To build the existing repositories in your directory, run:

    node build.js

To remove all old repositories in your directory, run:

    node build.js clean

To run all docker images built by build.js at the same time with the right order and environment variables, run:

    node run.js

To kill all docker containers run:

    docker kill $(docker ps -q)

Troubleshooting
---------------

Sometimes the scripts cannot find maven in your path (In other words, the script fails when packaging the services). In that case, on Windows, assuming chocolatey is installed (node probably installed it for you), you can open a terminal as administrator and run the following command:

    choco install maven

On macOS, the same should work for homebrew:

    brew install maven
