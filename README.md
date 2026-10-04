# Genealogy-backend

Contains the MariaDB backend files for the Genealogy app

## General purpose of the Genealogy app

The general purpose of the Genealogy app is to learn about- and further progress on MariaDB, Sails, Node, JS, Angular, SVG (SnapSVG) and GIT.
The Genealogy App will aid this purpose, but the app is not the purpose itself. The Genealogy app will consist of a MariaDB backend, SailsJS as middleware and a Javascript / Angular (so also Typescript) frontend.
The backend and middleware will run on privately hosted docker containers. The frontend will initially run as a simple WebApp for plain browsers, but is planned to be expanded into Mobile apps for Android as well as IOS and later on also Electron (so for use on full clients). The frontend will also be run a privately hosted docker container, but this one will eventually be exposed to the Internet. 

## Specific purpose of this repo

The specific purpose of this repo is to contain all MariaDB files required to build, further develop and maintain the MariaDB backend for the Genealogy app. Later I will add to this readme.md file explanations on the included files and how to use them.

## Stored procedure integration tests

The `test_add_new_parent_to_child.py` tests exercise the parent-creation stored procedure and its database functions against the local development database. They are discovered by VS Code's Python Test Explorer as `unittest` tests and are skipped unless explicitly enabled.

Create a BE-local Python environment and install its test dependencies:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-test.txt
```

In VS Code, select `.venv/bin/python` as the Python interpreter for the BE workspace folder. To run the database tests from BE, ensure `../Deploy/synology/deploy.env` has the local development connection values (`DEV_DB_HOST` must be loopback and `DEV_DB_NAME` must be `humans`), then run:

```bash
FAMILIEZ_RUN_DB_TESTS=1 .venv/bin/python -m unittest discover -s . -p "test_add_new_parent_to_child.py" -v
```

To run these tests from VS Code's Test Explorer, add `FAMILIEZ_RUN_DB_TESTS=1` to the local, git-ignored `BE/.env`. The database tests create uniquely named temporary people and relationships and remove those records during cleanup. Do not point `DEV_DB_*` at production.

## Very much "Under Construction"!

First steps for the web client have also already been made, but are until now contained in a private GIT repo. This repo will be made available public shortly. So if it seems that things are not complete by looking at this public repo, we'll, that's (partially) true at this moment :-). So please bear with me!
