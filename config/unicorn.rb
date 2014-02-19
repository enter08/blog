root = "/home/deployer/apps/blog/current"
working_directory root
pid "#{fetch(root)}/tmp/pids/unicorn.pid"
stderr_path "#{fetch(root)}/log/unicorn.log"
stdout_path "#{fetch(root)}/log/unicorn.log"

listen "/tmp/unicorn.blog.sock"
worker_processes 2
timeout 30