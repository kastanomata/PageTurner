#!/bin/bash

run_controller=false
run_system=false
run_users=false
run_posts=false
run_clubs=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    controller | controllers) run_controller=true ;;
    system | systems) run_system=true ;;
    users) run_users=true ;;
    posts) run_posts=true ;;
    clubs) run_clubs=true ;;
  esac
done

# If neither controller nor system specified, run both
if ! $run_controller && ! $run_system; then
  run_controller=true
  run_system=true
fi

# If none of users/posts/clubs specified, run all
if ! $run_users && ! $run_posts && ! $run_clubs; then
  run_users=true
  run_posts=true
  run_clubs=true
fi

if $run_controller; then
  $run_users && { echo "=== USER CONTROLLER TEST ==="; rails test test/controllers/users_controller_test.rb; echo "=== END TEST ==="; }
  $run_posts && { echo "=== POSTS CONTROLLER TEST ==="; rails test test/controllers/posts_controller_test.rb; echo "=== END TEST ==="; }
  $run_clubs && { echo "=== CLUBS CONTROLLER TEST ==="; rails test test/controllers/clubs_controller_test.rb; echo "=== END TEST ==="; }
fi

if $run_system; then
  $run_users && { echo "=== USER SYSTEM TEST ==="; rails test test/system/users_test.rb; echo "=== END TEST ==="; }
  $run_posts && { echo "=== POSTS SYSTEM TEST ==="; rails test test/system/posts_test.rb; echo "=== END TEST ==="; }
  $run_clubs && { echo "=== CLUBS SYSTEM TEST ==="; rails test test/system/clubs_test.rb; echo "=== END TEST ==="; }
fi
