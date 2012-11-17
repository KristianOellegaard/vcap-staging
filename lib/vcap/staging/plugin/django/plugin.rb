class DjangoPlugin < StagingPlugin
  include PipSupport

  def stage_application
    Dir.chdir(destination_directory) do
      create_app_directories
      copy_source_files
      setup_python_env
      create_startup_script
      create_stop_script
      create_gunicorn_config
    end
  end

  def start_command
    cmds = []
    cmds << ".venv/bin/python manage.py syncdb --noinput >> ../logs/startup.log 2>&1"
    cmds << ".venv/bin/gunicorn_django -c ../gunicorn.config"
    cmds.join("\n")
  end

  private

  def startup_script
    generate_startup_script
  end

  def stop_script
    generate_stop_script
  end

  def create_gunicorn_config
    File.open('gunicorn.config', 'w') do |f|
      f.write <<-EOT
import os
bind = "0.0.0.0:%s" % os.environ['VCAP_APP_PORT']
loglevel = "debug"
      EOT
    end
  end
end
