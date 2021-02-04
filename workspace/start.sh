#!/bin/bash
if [ -d bel_projects ]
then
  echo "Info: Directory bel_projects already exists!"
else
  echo "Info: Cloning bel_projects ..."
  git clone https://github.com/GSI-CS-CO/bel_projects.git
  cd bel_projects
  make
  make etherbone
  make etherbone-install
  make saftlib
  make saftlib-install
  make tools
  make tools-install
  chmod -R o+rwx .
fi
