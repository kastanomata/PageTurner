#!/bin/bash

if [ "$1" == "controllers" ]; then
  echo "=== USER CONTROLLER TEST ==="
  rails test test/controllers/users_controller_test.rb
  echo "=== END TEST ==="

  echo "=== POSTS CONTROLLER TEST ==="
  rails test test/controllers/posts_controller_test.rb
  echo "=== END TEST ==="

  echo "=== CLUBS CONTROLLER TEST ==="
  rails test test/controllers/clubs_controller_test.rb
  echo "=== END TEST ==="
elif [ "$1" == "system" ]; then
  echo "=== USER SYSTEM TEST ==="
  rails test test/system/users_test.rb
  echo "=== END TEST ==="

  echo "=== POSTS SYSTEM TEST ==="
  rails test test/system/posts_test.rb
  echo "=== END TEST ==="

  echo "=== CLUBS SYSTEM TEST ==="
  rails test test/system/clubs_test.rb
  echo "=== END TEST ==="
else
  echo "=== USER CONTROLLER TEST ==="
  rails test test/controllers/users_controller_test.rb
  echo "=== END TEST ==="

  echo "=== POSTS CONTROLLER TEST ==="
  rails test test/controllers/posts_controller_test.rb
  echo "=== END TEST ==="

  echo "=== CLUBS CONTROLLER TEST ==="
  rails test test/controllers/clubs_controller_test.rb
  echo "=== END TEST ==="


  echo "=== USER SYSTEM TEST ==="
  rails test test/system/users_test.rb
  echo "=== END TEST ==="

  echo "=== POSTS SYSTEM TEST ==="
  rails test test/system/posts_test.rb
  echo "=== END TEST ==="
  
  echo "=== CLUBS SYSTEM TEST ==="
  rails test test/system/clubs_test.rb
  echo "=== END TEST ==="
fi