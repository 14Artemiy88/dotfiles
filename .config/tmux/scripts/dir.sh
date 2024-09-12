#!/bin/bash

upd_dir() {
  local dir=$(tmux display-message -p '#{s|/home/artemiy|~|:pane_current_path}')

  case "$dir" in
    *search*)       echo "#[fg=cyan] $dir#[default]" ;;
    *ilium*)        echo "#[fg=cyan] $dir#[default]" ;;
    *router*)       echo "#[fg=cyan]\uE627 $dir#[default]" ;;
    *sima-land-ru*) echo "#[fg=cyan]  $dir#[default]" ;;
    *WORK*)         echo "#[fg=cyan] $dir#[default]" ;;
    *Downloads*)    echo "#[fg=cyan] $dir#[default]" ;;
    *Apps*)         echo "#[fg=cyan]󱆃  $dir#[default]" ;;
    *~*)            echo "#[fg=cyan] $dir#[default]" ;;
    *media*)        echo "#[fg=cyan] $dir#[default]" ;;
  esac
}

upd_dir
